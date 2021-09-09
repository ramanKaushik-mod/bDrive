import 'dart:async';
import 'dart:io';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  late HandlingFS handlingFirebaseDB;

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
          backgroundColor: Colors.blue[600],
          body: Container(
            color: Colors.black38,
            child: Consumer<GetChanges>(
              builder: (BuildContext context, value, win) {
                return value.tellPickedFileExist() == false
                    ? getBodyWhenFileNotPresent()
                    : getBodyWhenFilePresent();
              },
            ),
          ),
          bottomNavigationBar: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black,
              child: Consumer<GetChanges>(
                builder: (BuildContext context, value, win) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: value.tellPickedFileExist() == true
                        ? [
                            IU.dicon(
                                icon: Icons.camera,
                                callback: () {
                                  _pickImage(ImageSource.camera);
                                },
                                size: 25,
                                cSize: 26),
                            IU.dicon(
                                icon: Icons.photo_library,
                                callback: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                size: 25,
                                cSize: 26),
                            IU.dicon(
                                icon: Icons.crop,
                                callback: () {
                                  _cropImage(
                                      file: Provider.of<GetChanges>(context,
                                              listen: false)
                                          .getPickedFile());
                                },
                                size: 25,
                                cSize: 26),
                            IU.dicon(
                                icon: Icons.save,
                                callback: () async {
                                  GetChanges changes = Provider.of<GetChanges>(
                                      context,
                                      listen: false);
                                  bool flag = changes.tellPickedFileExist();

                                  if (flag) {
                                    String base64String = Utility.base64String(
                                        changes
                                            .getPickedFile()
                                            .readAsBytesSync());
                                    if (changes
                                            .getPickedFile()
                                            .readAsBytesSync()
                                            .length >=
                                        800000) {
                                      SB.ssb(
                                        context,
                                        text: 'Image size is too big',
                                      );
                                      return;
                                    }
                                    await Utility.saveImageToPreferences(
                                        base64String);
                                    changes.updateImageExists();
                                    changes.updateUserImage();
                                    changes.updatePickedFileExistsToFalse();
                                    Navigator.pop(context);
                                  } else {
                                    SB.ssb(
                                      context,
                                      text: 'no image is selected',
                                    );
                                  }
                                },
                                size: 25,
                                cSize: 26),
                            IU.dicon(
                                icon: Icons.refresh,
                                callback: () {
                                  _clear();
                                },
                                size: 25,
                                cSize: 26),
                          ]
                        : [
                            IU.dicon(
                                icon: Icons.camera,
                                callback: () {
                                  _pickImage(ImageSource.camera);
                                },
                                size: 25,
                                cSize: 26),
                            IU.dicon(
                                icon: Icons.photo_library,
                                callback: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                size: 25,
                                cSize: 26),
                          ],
                  );
                },
              )),
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
            color: Colors.blue[50],
            size: MediaQuery.of(context).size.width * 0.5,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Grab your Profile Pic",
              style: TextStyle(color: Colors.grey[500]),
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
