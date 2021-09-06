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
  File _imageFile = File('assets\\bDrive.png');
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
    Provider.of<GetChanges>(context, listen: false)
        .updatePickedFile(file: File(selected!.path));
  }

  Future<void> _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: _imageFile.path,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "edit your profile pic",
          backgroundColor: Colors.white,
          toolbarColor: Colors.blue[50],
          toolbarWidgetColor: Colors.blue,
          activeControlsWidgetColor: Colors.blue,
        ));
    PickedFile pickedFile =
        PickedFile(cropped == null ? _imageFile.path : cropped.path);
    setState(() {
      _imageFile = pickedFile as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<GetChanges>(context, listen: false).updatePickedFileExist();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: appBar(),
        backgroundColor: Colors.white,
        body: Consumer<GetChanges>(
          builder: (BuildContext context, value, win) {
            return value.tellPickedFileExist() == false
                ? getBodyWhenFileNotPresent()
                : getBodyWhenFilePresent();
          },
        ),
        bottomNavigationBar: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  heroTag: "btn4",
                  elevation: 0,
                  backgroundColor: Colors.blue[50],
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                FloatingActionButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    heroTag: "btn5",
                    elevation: 0,
                    backgroundColor: Colors.blue[50],
                    child: Icon(
                      Icons.photo_library,
                      color: Colors.blue,
                      size: 30,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getBodyWhenFilePresent() {
    return Container(
      color: Colors.white,
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
                              color: Colors.grey[100],
                              padding: EdgeInsets.all(4),
                              child: Image.file(
                                value.pickedFile,
                                height: TU.getw(context),
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
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              margin: EdgeInsets.all(10),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                        onPressed: _cropImage,
                        heroTag: "btn1",
                        backgroundColor: Colors.blue[50],
                        elevation: 0,
                        child: Icon(
                          Icons.crop,
                          color: Colors.blue,
                        )),
                    FloatingActionButton(
                        onPressed: () async {
                          GetChanges changes =
                              Provider.of<GetChanges>(context, listen: false);
                          bool flag = changes.tellPickedFileExist();

                          if (flag) {
                            String base64String = Utility.base64String(
                                changes.getPickedFile().readAsBytesSync());
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
                            await Utility.saveImageToPreferences(base64String);

                            Future.delayed(Duration(milliseconds: 20),
                                () async {
                              await handlingFirebaseDB
                                  .getUserDoc()
                                  .get()
                                  .then((value) async {
                                if (value.exists) {
                                  await handlingFirebaseDB.updateUserImage();
                                }
                              });
                            });
                            Navigator.of(context).pop();
                          } else {
                            SB.ssb(
                              context,
                              text: 'no image is selected',
                            );
                          }
                        },
                        heroTag: "btn2",
                        backgroundColor: Colors.blue[50],
                        elevation: 0,
                        child: Icon(
                          Icons.save,
                          color: Colors.blue,
                        )),
                    FloatingActionButton(
                        onPressed: () {},
                        heroTag: "btn3",
                        backgroundColor: Colors.blue[50],
                        elevation: 0,
                        child: Icon(
                          Icons.refresh,
                          color: Colors.blue,
                        )),
                  ],
                ),
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

  appBar() {
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Container(
        padding: EdgeInsets.all(10),
        // height: 40,
        width: width / 2,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "grab your profile pic",
            style: GoogleFonts.mulish(
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Colors.blue,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
