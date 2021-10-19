import 'dart:async';
import 'dart:io';
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
            backgroundColor: Colors.white12,
            elevation: 0,
            actions: [
              Consumer<GetChanges>(builder: (BuildContext context, changes, win){
                return changes.tellPickedFileExist() == true?Row(
                  children :[
              IconButton(
                splashRadius: 0,
                  onPressed: () {
                    _cropImage(
                        file: Provider.of<GetChanges>(context, listen: false)
                            .getPickedFile());
                  },
                  icon: IU.dNIcon(icon: Icons.crop, size: 26)),
              IconButton(
                splashRadius: 0,
                  onPressed: () async {
                    GetChanges changes =
                        Provider.of<GetChanges>(context, listen: false);
                    bool flag = changes.tellPickedFileExist();

                    if (flag) {
                      String base64String = Utility.base64String(
                          changes.getPickedFile().readAsBytesSync());
                      if (changes.getPickedFile().readAsBytesSync().length >=
                          800000) {
                        SB.ssb(
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
                      SB.ssb(
                        context,
                        text: 'no image is selected',
                      );
                    }
                  },
                  icon: IU.dNIcon(icon: Icons.save, size: 26,)),
              IconButton(
                splashRadius: 0,
                  onPressed: () {
                    _clear();
                  },
                  icon: IU.dNIcon(icon: Icons.refresh, size: 26))]):Container();
              }),
            ],
          ),
          backgroundColor: Colors.black87,
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
          bottomNavigationBar: Container(
            color: Colors.black87,
            child: BottomNavigationBar(
              unselectedItemColor: Colors.white70,
              selectedFontSize: 18,
              unselectedFontSize: 15,
              selectedItemColor: Colors.red,
              backgroundColor: Colors.white12,
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
                    icon: IU.dNIcon(icon: Icons.camera_outlined, size: 29)),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    label: 'photos',
                    icon: IU.dNIcon(icon: Icons.photo_outlined, size: 28)),
              ],
            ),
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
            color: Colors.grey[700],
            size: TU.getw(context)/3,
          ),
          Padding(
            padding: EdgeInsets.only(top:16),
            child: Text(
              "Grab your Profile Pic",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "and adjust accordingly",
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

// Container(
//               padding: const EdgeInsets.all(10),
//               height: 80,
//               color: Colors.white12,
//               child: Consumer<GetChanges>(
//                 builder: (BuildContext context, value, win) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: value.tellPickedFileExist() == true
//                         ? [
//                             IU.ditask(
//                                 icon: Icons.camera,
//                                 callback: () {
//                                   _pickImage(ImageSource.camera);
//                                 },
//                                 size: 28,),
//                             IU.ditask(
//                                 icon: Icons.photo_library,
//                                 callback: () {
//                                   _pickImage(ImageSource.gallery);
//                                 },
//                                 size: 28,),
//                             IU.ditask(
//                                 icon: Icons.crop,
//                                 callback: () {
//                                   _cropImage(
//                                       file: Provider.of<GetChanges>(context,
//                                               listen: false)
//                                           .getPickedFile());
//                                 },
//                                 size: 28,),
//                             IU.ditask(
//                                 icon: Icons.save,
//                                 callback: () async {
//                                  
//                                 },
//                                 size: 28),
//                             IU.ditask(
//                                 icon: Icons.refresh,
//                                 callback: () {
//                                   _clear();
//                                 },
//                                 size: 28),
//                           ]
//                         : [
//                             IU.ditask(
//                                 icon: Icons.camera,
//                                 callback: () {
//                                   _pickImage(ImageSource.camera);
//                                 },
//                                 size: 28),
//                             IU.ditask(
//                                 icon: Icons.photo_library,
//                                 callback: () {
//                                   _pickImage(ImageSource.gallery);
//                                 },
//                                 size: 28,),
//                           ],
//                   );
//                 },
//               ))
