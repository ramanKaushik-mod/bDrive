import 'dart:async';
import 'dart:io';
import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  CU cu = CU();
  late HandlingFS handlingFirebaseDB;
  int i = 0;
  @override
  void initState() {
    super.initState();
    getDBInstance();
  }

  getDBInstance() async {
    handlingFirebaseDB = HandlingFS(contactID: await Utility.getUserContact());
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (selected != null) {
      Provider.of<GetChanges>(context, listen: false)
          .updatePickedFile(file: File(selected.path));
      Provider.of<GetChanges>(context, listen: false).updatePickedFileExist();
    }
  }

  Future<void> _cropImage({required File file}) async {
    File? cropped = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: file.path,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "edit your profile pic",
          backgroundColor: Colors.white,
          toolbarColor: Colors.blue[50],
          toolbarWidgetColor: Colors.blue,
          activeControlsWidgetColor: Colors.blue,
        ));
    PickedFile pickedFile =
        PickedFile(cropped == null ? file.path : cropped.path);
    Provider.of<GetChanges>(context, listen: false)
        .updatePickedFile(file: File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Provider.of<GetChanges>(context, listen: false)
              .updatePickedFileExistsToFalse();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: cu.bnbc,
            leading: IU.iwc(
                icon: Icons.arrow_back_ios_new_outlined,
                callback: () {
                  Navigator.pop(context);
                },
                size: 24),
            elevation: 0,
            actions: [
              IconButton(
                  tooltip: "crop",
                  onPressed: () {
                    GetChanges changes =
                        Provider.of<GetChanges>(context, listen: false);
                    if (changes.tellPickedFileExist()) {
                      _cropImage(
                          file: Provider.of<GetChanges>(context, listen: false)
                              .getPickedFile());
                    } else {
                      SB.ssb2(
                        context,
                        text: 'no image is selected',
                      );
                    }
                  },
                  icon: IU.dBIcon(icon: Icons.crop, size: 22)),
              IconButton(
                  color: cu.orange,
                  tooltip: "save",
                  onPressed: () async {
                    GetChanges changes =
                        Provider.of<GetChanges>(context, listen: false);
                    bool flag = changes.tellPickedFileExist();

                    if (flag) {
                      String base64String = Utility.base64String(
                          changes.getPickedFile().readAsBytesSync());
                      if (changes.getPickedFile().readAsBytesSync().length >=
                          800000) {
                        SB.ssb2(
                          context,
                          text: 'Image size is too big',
                        );
                        return;
                      }
                      await Utility.saveImageToPreferences(base64String);
                      changes.updateImageExists();
                      changes.updateUserImage();
                      changes.updatePickedFileExistsToFalse();
                      Navigator.pop(context);
                    } else {
                      SB.ssb2(
                        context,
                        text: 'no image is selected',
                      );
                    }
                  },
                  icon: IU.dBIcon(
                    icon: Icons.upload_outlined,
                    size: 24,
                  )),
              IconButton(
                  tooltip: "clear",
                  onPressed: () {
                    if (Provider.of<GetChanges>(context, listen: false)
                        .tellPickedFileExist()) {
                      _clear();
                    } else {
                      SB.ssb2(
                        context,
                        text: 'no image is selected',
                      );
                    }
                  },
                  icon: IU.dBIcon(icon: Icons.refresh, size: 25)),
              SizedBox(width: 10),
            ],
          ),
          backgroundColor: Colors.black,
          body: Container(
            color: Colors.white10,
            child: Consumer<GetChanges>(
              builder: (BuildContext context, value, win) {
                return value.tellPickedFileExist() == false
                    ? getBodyWhenFileNotPresent()
                    : getBodyWhenFilePresent();
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: cu.twhite,
            selectedFontSize: 16,
            unselectedFontSize: 12,
            selectedItemColor: cu.w,
            backgroundColor: cu.bnbc,
            onTap: (index) {
              setState(() {
                i = index;
              });
              if (i == 0) {
                _pickImage(ImageSource.camera);
              } else if (i == 1) {
                _pickImage(ImageSource.gallery);
              }
            },
            currentIndex: i,
            items: [
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  label: 'camera',
                  activeIcon:
                      BU.btDialogDUI(icon: Icons.camera_outlined, size: 30),
                  icon: IU.dNIcon(icon: Icons.camera_outlined, size: 28)),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  label: 'photos',
                  activeIcon:
                      BU.btDialogDUI(icon: Icons.photo_outlined, size: 30),
                  icon: IU.dNIcon(icon: Icons.photo_outlined, size: 28)),
            ],
          ),
        ));
  }

  Widget getBodyWhenFilePresent() {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Container(
              child: Wrap(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Consumer<GetChanges>(
                          builder: (BuildContext context, value, win) {
                        return Center(
                          child: Container(
                              color: Colors.transparent,
                              margin: EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  value.pickedFile,
                                  fit: BoxFit.cover,
                                  height: TU.geth(context) / 1.5,
                                  width: TU.getw(context),
                                ),
                              )),
                        );
                      })
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getBodyWhenFileNotPresent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_drive_file,
            color: Colors.white10,
            size: TU.getw(context) / 3,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              "Grab your Profile Pic",
              style: TU.teesmall(context),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "and adjust accordingly",
              style: TextStyle(color: Colors.grey[700]),
            ),
          )
        ],
      ),
    );
  }

  void _clear() {
    Provider.of<GetChanges>(context, listen: false)
        .updatePickedFileExistsToFalse();
  }
}
