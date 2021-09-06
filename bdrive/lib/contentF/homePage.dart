import 'dart:io';

import 'package:bdrive/contentF/drawerPage.dart';
import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  @override
  void initState() {
    super.initState();
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = IOSInitializationSettings();

    var initializeSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    localNotification = FlutterLocalNotificationsPlugin();
    localNotification?.initialize(initializeSettings);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        backgroundColor: Colors.black38,
        elevation: 0,
        leadingWidth: 90,
        leading: Builder(
            builder: (context) => GestureDetector(
                  excludeFromSemantics: false,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets\\bDrive.png',
                          height: 60,
                          width: 60,
                        ),
                        Image.asset(
                          'assets\\bDrive.png',
                          height: 30,
                          width: 30,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Scaffold.of(context).openDrawer(),
                )),
      ),
      drawer: DrawerPage(),
      bottomSheet: BottomSheet(
        elevation: 20,
        onClosing: () {},
        enableDrag: false,
        builder: (BuildContext con) => Container(
          color: Colors.black,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IU.ditask(
                  icon: Icons.create_new_folder_outlined,
                  // callback: () => _showNotification(),
                  callback: () {
                    fCon.text = 'Untitled folder';
                    SB.sdb(context, () {
                      var text = fCon.text.trim().toString();
                      if (text.length == 0) {
                        SB.ssb(context, text: 'enter a name for folder');
                      } else {
                        SB.ssb(context, text: '$text created');
                      }
                      //call to firestore to add new folder to folderlist
                      fCon.text = '';
                    }, () {}, fCon, dialog: 'New folder');
                  },
                  size: 28),
              IU.ditask(
                  icon: Icons.upload_outlined,
                  callback: () => selectFile(),
                  size: 28),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black38,
            padding: EdgeInsets.all(5),
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(5),
                    color: Colors.black26,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        // child: TextEdit,
                        ),
                  ),
                ),
                IU.diconl(icon: Icons.search, callback: () {}, size: 28),
                Consumer<GetChanges>(
                    builder: (BuildContext builder, value, wi) {
                  return value.getView() == 0
                      ? IU.diconl(
                          icon: Icons.grid_view,
                          callback: () {
                            Provider.of<GetChanges>(context, listen: false)
                                .updateView();
                          },
                          size: 28)
                      : IU.diconl(
                          icon: Icons.list,
                          callback: () {
                            Provider.of<GetChanges>(context, listen: false)
                                .updateView();
                          },
                          size: 28);
                }),
              ],
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.black38,
            child: Consumer<GetChanges>(
              builder: (BuildContext context, value, win) {
                bool flag = value.view == 1 ? true : false;
                return value.getView() == 1
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            FolderTile(
                                folder: Folder(
                                    createdAt: 'time',
                                    fName: 'Folder Name',
                                    folderList: [],
                                    fileList: []),
                                type: flag),
                            FolderTile(
                                folder: Folder(
                                    createdAt: 'time',
                                    fName: 'Folder Name',
                                    folderList: [],
                                    fileList: []),
                                type: flag),
                            FolderTile(
                                folder: Folder(
                                    createdAt: 'time',
                                    fName: 'Folder Name',
                                    folderList: [],
                                    fileList: []),
                                type: flag),
                          ],
                        ),
                      )
                    : GridView.count(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        children: [
                          FolderTile(
                              folder: Folder(
                                  createdAt: 'time',
                                  fName: 'Folder Name',
                                  folderList: [],
                                  fileList: []),
                              type: flag),
                          FolderTile(
                              folder: Folder(
                                  createdAt: 'time',
                                  fName: 'Folder Name',
                                  folderList: [],
                                  fileList: []),
                              type: flag),
                          FolderTile(
                              folder: Folder(
                                  createdAt: 'time',
                                  fName: 'Folder Name',
                                  folderList: [],
                                  fileList: []),
                              type: flag),
                        ],
                      );
              },
            ),
          )),
        ],
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

  @override
  void dispose() {
    super.dispose();
    fCon.dispose();
  }
}
 