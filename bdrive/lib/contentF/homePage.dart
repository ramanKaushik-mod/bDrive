import 'dart:async';
import 'dart:io';

import 'package:bdrive/contentF/favoriteDoc.dart';
import 'package:bdrive/contentF/homeDocPage.dart';
import 'package:bdrive/contentF/recentDoc.dart';
import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? file;
  FlutterLocalNotificationsPlugin? localNotification;
  TextEditingController fCon = TextEditingController();
  late HandlingFS handlingFS;
  @override
  void initState() {
    super.initState();
    getDBInstance();
    addHomeFolder();
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = IOSInitializationSettings();

    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    localNotification = FlutterLocalNotificationsPlugin();
    localNotification?.initialize(initializeSettings);
  }

  addHomeFolder() async {
    GetChanges changes = Provider.of<GetChanges>(context, listen: false);
    await changes.updatePathListA(list: [await Utility.getHomeUID(), 'Home']);

    await changes.updateUserImage();
    changes.tellImageExist();
  }

  getDBInstance() async {
    handlingFS = HandlingFS(contactID: await Utility.getUserContact());
    await Provider.of<GetChanges>(context, listen: false)
        .updateReadyDBStatus(status: 1);
  }

  _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        priority: Priority.high, importance: Importance.high);
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification?.show(0, 'Notification Title',
        'This is the body of the notification', generalNotificationDetails,
        payload:
            "This  is not something that i like but it is something or you can say payload");
  }

  @override
  Widget build(BuildContext context) {
    var column = Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Container(
          color: Colors.black38,
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Card(
                  margin:
                      EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
                  color: Colors.black38,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white24),
                  ),
                ),
              ),
              IU.diconl(icon: Icons.search, callback: () {}, size: 28),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Consumer<GetChanges>(
                    builder: (BuildContext builder, value, win) {
                  return value.getView() == 0
                      ? IU.diconl(
                          icon: Icons.list,
                          callback: () {
                            Provider.of<GetChanges>(context, listen: false)
                                .updateView();
                          },
                          size: 28)
                      : IU.diconl(
                          icon: Icons.grid_view,
                          callback: () {
                            Provider.of<GetChanges>(context, listen: false)
                                .updateView();
                          },
                          size: 28);
                }),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        TU.tuD(context),
        Consumer<GetChanges>(builder: (BuildContext context, changes, win) {
          int i = changes.getNIIndex();
          if (changes.readyDB == 1) {
            if (i == 2)
              return HomeDocPage(
                handlingFS: handlingFS,
              );
            else if (i == 1)
              return RecentDocPage(
                handlingFS: handlingFS,
              );
            else
              return StarDocPage(
                handlingFS: handlingFS,
              );
          } else {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          }
        }),
      ],
    );
    return WillPopScope(
      onWillPop: () {
        GetChanges changes = Provider.of<GetChanges>(context, listen: false);
        if (changes.dial.value == true) {
          changes.updateDialStatus();
          return Future.value(false);
        } else {
          if (changes.pathList.length > 1) {
            changes.updatePathListD();
            return Future.value(false);
          } else {
            SystemNavigator.pop();
            return Future.value(false);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        // drawer: DrawerPage(),
        bottomNavigationBar: Container(
          color: Colors.black38,
          child:
              Consumer<GetChanges>(builder: (BuildContext context, value, win) {
            return BottomNavigationBar(
                unselectedItemColor: Colors.white70,
                selectedFontSize: 15,
                selectedItemColor: Colors.red,
                backgroundColor: Colors.white12,
                currentIndex: value.getNIIndex(),
                onTap: (index) {
                  value.updateNIIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    label: 'Starred',
                    icon: IU.dNIcon(
                      icon: Icons.star,
                      size: 28,
                    ),
                  ),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      label: 'Recent',
                      icon: IU.dNIcon(icon: Icons.history, size: 28)),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      label: 'Files',
                      icon: IU.dNIcon(icon: Icons.home, size: 28)),
                ]);
          }),
        ),
        body: NestedScrollView(
          body: column,
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              leadingWidth: 76,
              backgroundColor: Colors.white12,
              leading: Consumer<GetChanges>(
                  builder: (BuildContext context, value, win) {
                return value.tellImageExist() == true
                    ? IU.dicon(
                        icon: Icons.person,
                        callback: () {},
                        size: 22,
                        cSize: 22,
                      )
                    : Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                            radius: 21.5,
                            backgroundColor: Colors.black,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: value.getUserImage(),
                            ),
                          ),
                        ),
                      );
              }),
              title: Consumer<GetChanges>(
                builder: (BuildContext context, change, win) {
                  int i = change.niindex;
                  if (i == 2)
                    return Text(change.pathList.length != 0?change.pathList.last[1]:"");
                  else if (i == 1)
                    return Text('Recent');
                  else
                    return Text('Starred');
                },
              ),
              toolbarHeight: 70,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<GetChanges>(
                          builder: (BuildContext context, value, win) {
                        return value.getUploadTask() != null
                            ? uploadStatus(value.getUploadTask()!)
                            : Container();
                      })
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        floatingActionButton:
            Consumer<GetChanges>(builder: (BuildContext context, changes, win) {
          return SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            iconTheme: IconThemeData(color: Colors.white70, size: 25),
            backgroundColor: Colors.grey[900],
            overlayColor: Colors.black45,
            overlayOpacity: 0.6,
            closeManually: true,
            openCloseDial: changes.dial,
            children: [
              SpeedDialChild(
                backgroundColor: Colors.transparent,
                label: 'Upload',
                child: IU.ditask(
                    icon: Icons.upload_outlined,
                    callback: () async {
                      await changes.updateDialStatus();
                      await selectFile();
                      await uploadFile();
                    },
                    size: 28),
              ),
              SpeedDialChild(
                  backgroundColor: Colors.transparent,
                  label: 'create folder',
                  child: IU.ditask(
                      icon: Icons.create_new_folder_outlined,
                      callback: () async {
                        fCon.text = '';
                        changes.updateDialStatus();

                        SB.sdb(context, () async {
                          var text = fCon.text.trim().toString();
                          if (text.length == 0) {
                            SB.ssb(context, text: 'enter a name for folder');
                          } else {
                            SB.ssb(context, text: '$text created');

                            await handlingFS.addFolderToFolderList(
                                folder: Folder(
                                    docUid:
                                        handlingFS.getHomeCollection().doc().id,
                                    fName: fCon.text.trim(),
                                    createdAt: DateTime.now().toString(),
                                    folderList: [],
                                    fileList: []),
                                parentDocUid: changes.pathList.last[0]);
                          }

                          fCon.text = '';
                        }, () {}, fCon, dialog: 'New folder');
                      },
                      size: 28))
            ],
          );
        }),
      ),
    );
  }

  selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      SB.ssb(context, text: 'No File is selected');
      return;
    }
    final path = result.files.single.path;
    setState(() => file = File(path));
    SB.ssb(context, text: '${file!.path.split('/').last} is uploading');
  }

  uploadFile() async {
    if (file == null) return;

    final fileName = '${file!.path.split('/').last}';
    final destination = 'files/${await Utility.getUserContact()}/$fileName';
    GetChanges changes = Provider.of<GetChanges>(context, listen: false);
    changes.updateUploadTask(
        tsk: handlingFS.uploadFile(destination: destination, file: file!));
    setState(() {});

    if (changes.getUploadTask() == null) return;
    final snapshot = await changes.getUploadTask()!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();

    handlingFS.addFileToFileList(
        file: CFile(
            fileName: fileName,
            uploadTime: DateTime.now().toString(),
            dLink: url),
        parentDocUid: changes.pathList.last[0]);
    changes.updateUploadTask(tsk: null);

    //********  Use the 'url' variable to get the download link */
  }

  uploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(3);
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Center(
              child: Text(
                '$percentage % uploaded',
                style: TU.teeesmall(context, 50),
              ),
            ),
          );
        } else {
          return Container();
        }
      });

  @override
  void dispose() {
    super.dispose();
    fCon.dispose();
  }
}
