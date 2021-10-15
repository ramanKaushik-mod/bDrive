import 'dart:async';
import 'dart:io';

import 'package:bdrive/contentF/favoriteDoc.dart';
import 'package:bdrive/contentF/homeDocPage.dart';
import 'package:bdrive/contentF/recentDoc.dart';
import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  String starId = '', recentId = '';
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
    localNotification?.initialize(initializeSettings,
        onSelectNotification: (String? payload) async {
      selectNotification(payload!);
    });
  }

  Future selectNotification(String payload) async {
    if (payload == "upload") {
      Provider.of<GetChanges>(context, listen: false).updateNIIndex(1);
    }
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
    starId = await Utility.getStarDID();
    recentId = await Utility.getRecentDID();
    if (!await handlingFS.crle(docId: recentId)) {
      await handlingFS.takeCareOfRecentDoc(docId: recentId);
    }
    if (!await handlingFS.csle(docId: starId)) {
      await handlingFS.takeCareOfStarDoc(docId: starId);
    }
  }

  _showNotification(
      {required String text,
      required String title,
      required String payload}) async {
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        playSound: true, priority: Priority.high, importance: Importance.high);
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification?.show(0, title, text, generalNotificationDetails,
        payload: payload);
  }

  @override
  Widget build(BuildContext context) {
    var column = Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white10,
          ),
          padding: EdgeInsets.only(right: 5),
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: InkResponse(
                  onTap: () => Navigator.pushNamed(context, '/seap'),
                  child: Hero(
                    tag: 'searchbox',
                    child: Card(
                      margin: EdgeInsets.only(
                          left: 5, right: 10, top: 5, bottom: 5),
                      color: Colors.black38,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, right: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white24),
                          child: Text(
                            'Search bCLOUD',
                            style: TU.tesmall(context, 44),
                          )),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/seap'),
                icon: Hero(
                  tag: 'seap',
                  child: Icon(
                    Icons.search,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
              ),
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
              return RecentDocPage(handlingFS: handlingFS, docId: recentId);
            else
              return StarDocPage(
                handlingFS: handlingFS,
                docId: starId,
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
        if (changes.getLoadingIndicatorStatus() == true) {
          changes.updateLoadingIndicatorStatus(flag: false);
          return Future.value(false);
        } else {
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
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black87,
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
                      icon: value.niindex == 0 ? Icons.star : Icons.star_border,
                      size: 28,
                    ),
                  ),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      label: 'Recent',
                      icon: IU.dNIcon(
                          icon: value.niindex == 1
                              ? Icons.change_history
                              : Icons.change_history,
                          size: 28)),
                  BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      label: 'Files',
                      icon: IU.dNIcon(
                          icon: value.niindex == 2
                              ? Icons.folder
                              : Icons.folder_outlined,
                          size: 28)),
                ]);
          }),
        ),
        body: NestedScrollView(
          body: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                GetChanges change =
                    Provider.of<GetChanges>(context, listen: false);
                if (notification.direction == ScrollDirection.forward &&
                    change.isVisible == true) {
                  change.updateIsVisible(flag: false);
                }
                if (notification.direction == ScrollDirection.reverse &&
                    change.isVisible == false) {
                  change.updateIsVisible(flag: true);
                }
                return true;
              },
              child: column),
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              backgroundColor: Colors.white12,
              leading: Consumer<GetChanges>(
                  builder: (BuildContext context, value, win) {
                return value.pathList.isNotEmpty
                    ? value.pathList.last[1] == 'Home'
                        ? Icon(
                            Icons.home_filled,
                            color: Colors.red,
                            size: 28,
                          )
                        : IU.diconl(
                            icon: Icons.arrow_back_ios_new_outlined,
                            callback: () {
                              value.updatePathListD();
                            },
                            size: 28)
                    : Container();
              }),
              title: Consumer<GetChanges>(
                builder: (BuildContext context, change, win) {
                  int i = change.niindex;
                  if (i == 2)
                    return Text(change.pathList.length != 0
                        ? change.pathList.last[1]
                        : "");
                  else if (i == 1)
                    return Text('Recent');
                  else
                    return Text('Starred');
                },
              ),
              toolbarHeight: 70,
              actions: [
                Consumer<GetChanges>(
                    builder: (BuildContext context, value, win) {
                  return value.getLoadingIndicatorStatus() == true
                      ? Tooltip(
                        message: 'loading file \npress back button to stop',
                        padding:EdgeInsets.all(3),
                        child: Wrap(
                            runAlignment: WrapAlignment.center,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: CircularProgressIndicator(
                                    color: Colors.white70,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      )
                      : Container();
                }),
                Consumer<GetChanges>(
                    builder: (BuildContext context, value, win) {
                  return value.getHandleUTaskSema() != 0
                      ? value.getUploadTask() != null
                          ? uploadStatus(value.getUploadTask()!)
                          : Container()
                      : Container();
                }),
                Consumer<GetChanges>(
                    builder: (BuildContext context, change, win) {
                  return change.getHandleUTaskSema() != 0
                      ? change.getUploadTask() != null
                          ? IconButton(
                              onPressed: () {
                                Provider.of<GetChanges>(context, listen: false)
                                    .cancelUploadTask(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 28,
                              ),
                            )
                          : Container()
                      : Container();
                }),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/sep'),
                  icon: Hero(
                    tag: 'settingspage',
                    child: Icon(
                      Icons.settings,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        floatingActionButton:
            Consumer<GetChanges>(builder: (BuildContext context, changes, win) {
          return changes.getIsVisible() == false && changes.getNIIndex() == 2
              ? SpeedDial(
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
                      labelWidget:
                          TU.tSDLabel(context: context, label: 'upload'),
                      child: IU.ditask(
                          icon: Icons.upload_outlined,
                          callback: () async {
                            if (!await CIC.checkConnectivity(context)) {
                              changes.updateDialStatus();
                              return;
                            }
                            await selectFile();
                            changes.updateDialStatus();
                            try {
                              await uploadFile();
                            } on FirebaseException catch (e) {
                              if (e.code == 'canceled') {
                                print('[firebase_storage/canceled] is handled');
                              }
                              SB.ssb(context, text: "upload canceled");
                            }
                          },
                          size: 28),
                    ),
                    SpeedDialChild(
                        backgroundColor: Colors.transparent,
                        labelWidget: TU.tSDLabel(
                            context: context, label: 'create folder'),
                        child: IU.ditask(
                            icon: Icons.create_new_folder_outlined,
                            callback: () async {
                              StreamSubscription<ConnectivityResult> ss =
                                  CIC.getSubscription(context, callback: () {});
                              if (!await CIC.checkConnectivity(context)) {
                                ss.cancel();
                                changes.updateDialStatus();
                                return;
                              }
                              fCon.text = '';
                              changes.updateDialStatus();

                              SB.sdb(context, () async {
                                var text = fCon.text.trim().toString();
                                if (text.length == 0) {
                                  SB.ssb(context,
                                      text: 'enter a name for folder');
                                } else {
                                  SB.ssb(context, text: '$text created');

                                  await handlingFS.addFolderToFolderList(
                                      folder: Folder(
                                          docUid: handlingFS
                                              .getHomeCollection()
                                              .doc()
                                              .id,
                                          fName: fCon.text.trim(),
                                          createdAt: DateTime.now().toString(),
                                          folderList: [],
                                          fileList: [],
                                          star: false),
                                      parentDocUid: changes.pathList.last[0]);
                                }

                                fCon.text = '';
                              }, () {}, fCon, dialog: 'New folder');

                              ss.cancel();
                            },
                            size: 28))
                  ],
                )
              : Container();
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
    setState(() => file = File(path!));
    SB.ssb(context, text: '${file!.path.split('/').last} is uploading');
  }

  uploadFile() async {
    if (file == null) return;
    GetChanges changes = Provider.of<GetChanges>(context, listen: false);

    StreamSubscription<ConnectivityResult> ss =
        CIC.getSubscription(context, callback: () {});
    if (!await CIC.checkConnectivity(context)) {
      ss.cancel();
      changes.updateDialStatus();
      return;
    }
    changes.updateHandleUTaskSema(sema: 1);

    final fileName = '${file!.path.split('/').last}';

    String dan = DateTime.now().toString();
    final destination = 'files/${await Utility.getUserContact()}/$fileName';
    UploadTask? uploadTask;
    uploadTask = handlingFS.uploadFile(destination: destination, file: file!);
    changes.updateUploadTask(tsk: uploadTask);
    if (changes.getUploadTask() == null) return;

    final snapshot = await changes.getUploadTask();
    double size = snapshot!.totalBytes / 1000000;
    final url = await snapshot.ref.getDownloadURL();
    handlingFS.addFileToFileList(context,
        file: CFile(
            fileName: fileName,
            dan: dan,
            star: false,
            uploadTime: DateTime.now().toString(),
            dLink: url,
            parentDocID: changes.getPathList().last[0],
            path: changes.getPathList().last[1].toLowerCase(),
            size: size),
        parentDocUid: changes.pathList.last[0], func: () {
      changes.updateHandleUTaskSema(sema: 0);
      _showNotification(
          text: "$fileName is uploaded",
          title: 'Uploaded file',
          payload: 'upload');
      SB.ssb(context, text: "$fileName is uploaded");
    }, recentId: recentId);
    changes.updateUploadTask(tsk: null);
    ss.cancel();
  }

  uploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toString();
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Wrap(
              runAlignment: WrapAlignment.center,
              children: [
                Container(
                  height: 28,
                  width: 28,
                  child: Transform.scale(
                    scale: 0.8,
                    child: CircularProgressIndicator(
                      value: progress,
                      color: Colors.white70,
                      semanticsLabel: "uploaded",
                      semanticsValue: percentage,
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                  ),
                ),
              ],
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
