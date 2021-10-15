import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static Future<SharedPreferences> gsi() async =>
      await SharedPreferences.getInstance();

  static userSignedIn() async =>
      await gsi().then((value) => value.setBool(Constants.signedIn, true));

  static getUserSignedInStatus() async =>
      await gsi().then((value) => value.getBool(Constants.signedIn) ?? false);

  static onBoardVisited() async => await gsi()
      .then((value) => value.setBool(Constants.onBoardVisited, true));

  static getOnBoardVisitedStatus() async => await gsi()
      .then((value) => value.getBool(Constants.onBoardVisited) ?? false);

  static clearPreferences() async {
    await gsi().then((value) => value.clear());
  }

  //************User Info Saving************/

  static saveUserContact({required String userCon}) async =>
      await gsi().then((value) => value.setString(Constants.userCon, userCon));

  static getUserContact() async =>
      await gsi().then((value) => value.getString(Constants.userCon));

  static setVFyId({required String vid}) async =>
      await gsi().then((value) => value.setString(Constants.vFyId, vid));

  static getVFyId() async =>
      await gsi().then((value) => value.getString(Constants.vFyId));

  //**************Image Preferences */

  static saveImageToPreferences(String image) =>
      gsi().then((value) => value.setString(Constants.imgKey, image));

  static Future<String> getImageFromPreferences() async =>
      await gsi().then((value) => value.getString(Constants.imgKey) ?? '');

  static removeImage() async =>
      await gsi().then((value) => value.remove(Constants.imgKey));

  static String base64String(Uint8List data) => base64Encode(data);

  static Image imageFromBase64String(String base64String) => Image.memory(
        base64Decode(base64String),
        fit: BoxFit.fill,
      );
  static void exitApp(BuildContext context) {
    SystemNavigator.pop();
  }

  static setProfileStatus() =>
      gsi().then((value) => value.setBool(Constants.pStatus, true));

  static getProfileStatus() =>
      gsi().then((value) => value.getBool(Constants.pStatus) ?? false);

  //***************advanced************** */

  static setUserDetails({required Map<String, dynamic> map}) async {
    await gsi().then((value) {
      value.setString(Constants.userName, map['uName']);
      value.setString(Constants.uID, map['uNName']);
      value.setString(Constants.uEmail, map['uEmail']);
      value.setString(Constants.imgKey, map['uimgString']);
      value.setString(Constants.userCon, map['contactId']);
      value.setString(Constants.uJoin, map['uJoin']);
      value.setString(Constants.upasscode, map['upasscode']);
      value.setString(Constants.homeUid, map['homeUid']);
      value.setString(Constants.recentId, map['recentId']);
      value.setString(Constants.starId, map['starId']);
    });
  }

  static Future<Users> getUserDetails() async {
    return await gsi().then((value) {
      return Users(
          uName: value.getString(Constants.userName) ?? '',
          uNName: value.getString(Constants.uID) ?? '',
          uEmail: value.getString(Constants.uEmail) ?? '',
          upasscode: value.getString(Constants.upasscode) ?? '',
          uimgString: value.getString(Constants.imgKey) ?? '',
          contactId: value.getString(Constants.userCon) ?? '',
          uJoin: value.getString(Constants.uJoin) ?? '',
          homeUid: value.getString(Constants.homeUid) ?? '',
          recentId: value.getString(Constants.recentId) ?? '',
          starId: value.getString(Constants.starId) ?? '');
    });
  }

  static Future<String> getHomeUID() async =>
      await gsi().then((value) => value.getString(Constants.homeUid) ?? '');

  static Future<String> getStarDID() async =>
      await gsi().then((value) => value.getString(Constants.starId) ?? '');

  static Future<String> getRecentDID() async =>
      await gsi().then((value) => value.getString(Constants.recentId) ?? '');
}

class SB {
  static ssb(context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      behavior: SnackBarBehavior.fixed,
      duration: Duration(seconds: 2),
    ));
  }

  static sdb(context, Function yesFunc, Function noFunc, controller,
          {required String dialog}) =>
      showDialog(
          context: context,
          builder: (con) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: controller != null
                  ? Text(dialog, style: TU.tsmall(context))
                  : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Wrap(
                children: [
                  if (controller == null) ...[
                    Container(
                      child: Center(
                        child: Text(dialog, style: TU.tsmall(con)),
                      ),
                    ),
                  ],
                  if (controller != null) ...[
                    TextFormField(
                      controller: controller,
                      textAlign: TextAlign.left,
                      style: TU.tsmall(context),
                      cursorColor: Colors.white,
                      cursorWidth: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                  ]
                ],
              ),
              actions: [
                IconButton(
                    splashColor: Colors.white,
                    splashRadius: 20,
                    onPressed: () {
                      noFunc();
                      Navigator.pop(con);
                    },
                    icon: Icon(Icons.close_rounded, color: Colors.white)),
                IconButton(
                    splashColor: Colors.white,
                    splashRadius: 20,
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 2), () {
                        yesFunc();
                      });
                      Navigator.pop(con);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ))
              ],
            );
          });
}

class TU {
  //text utitlity

  static geth(context) => MediaQuery.of(context).size.height;
  static getw(context) => MediaQuery.of(context).size.width;

  static tsmall(context) =>
      TextStyle(fontSize: geth(context) / 48, color: Colors.white);
  static tlarge(context, factor) => GoogleFonts.montserratAlternates(
      fontSize: geth(context) / factor,
      color: Colors.red,
      fontWeight: FontWeight.w400);
  static tesmall(context, factor) => TextStyle(
      fontSize: geth(context) / factor,
      color: Colors.white70,
      fontWeight: FontWeight.w500);
  static teesmall(context) => TextStyle(
      fontSize: geth(context) / 60,
      color: Colors.white,
      fontWeight: FontWeight.w300);
  static teeesmall(context, factor) => GoogleFonts.mulish(
      fontSize: geth(context) / factor,
      color: Colors.white54,
      fontWeight: FontWeight.w400);
  static tesmallw(context) => TextStyle(
      fontSize: geth(context) / 50,
      color: Colors.white,
      fontWeight: FontWeight.w500);
  static telarge(context) => TextStyle(
      fontSize: geth(context) / 36,
      color: Colors.blue[900],
      fontWeight: FontWeight.w600);

  static tuD(context) => Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: 140),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      );

  static tuDFBM(context, factor) => Container(
        width: getw(context) / factor,
        height: 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      );
  static tuDw() => Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 20,
        width: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      );
  static tTitle(BuildContext context) => TextStyle(
      fontSize: geth(context) / 30,
      color: Colors.grey,
      fontWeight: FontWeight.w700);

  static tSDLabel({required context, required String label}) => Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white24),
            child: Text(
              label,
              style: TU.teesmall(context),
            )),
      );
}

class GetChanges extends ChangeNotifier {
  bool pickedFileExist = false;
  bool tellPickedFileExist() => pickedFileExist;
  File pickedFile = File('assets\\bDrive.png');
  File getPickedFile() => pickedFile;
  bool imageExist = false;
  bool tellImageExist() => imageExist;
  Image image = Image.asset('assets\\bDrive.png');
  Image getUserImage() => image;
  int time = 30;
  int getUpdateTime() => time;
  int view = 0;
  int getView() => view;

  updatePickedFile({required File file}) {
    pickedFile = file;
    notifyListeners();
  }

  updatePickedFileExist() {
    pickedFileExist = true;
    notifyListeners();
  }

  updatePickedFileExistsToFalse() {
    pickedFileExist = false;
    notifyListeners();
  }

  updateImageExists() {
    imageExist = true;
    notifyListeners();
  }

  updateUserImage() async {
    image = await Utility.getImageFromPreferences().then((value) {
      return Utility.imageFromBase64String(value);
    });
    notifyListeners();
  }

  updateView() {
    view = view == 1 ? 0 : 1;
    notifyListeners();
  }

  updateSmsWaitingTime({required Function cancelTimer}) {
    if (time == 1) {
      time--;
      notifyListeners();
      cancelTimer();
    } else {
      time--;
      notifyListeners();
    }
  }

  turnTimeTo30() {
    time = 30;
    notifyListeners();
  }

  //*****************Authentication Page *************** */
  bool codeSentSemaphore = false;

  bool getCodeSentSemaphore() => codeSentSemaphore;
  updateCodeSentSemaphore({required bool flag}) {
    codeSentSemaphore = flag;
    notifyListeners();
  }

  //*******************HomePage******************** */

  Color selectColor = Colors.black;
  Color getSelectColor() => selectColor;

  updateSelectColor() {
    selectColor = Colors.black12;
    notifyListeners();
  }

  //****************** HIERARCHY LIST ***************** */

  List<List<String>> pathList = [];
  List<List<String>> getPathList() => pathList;

  //call this method when you need to add a path element (when you click on folder)
  updatePathListA({required List<String> list}) {
    pathList.add(list);
    notifyListeners();
  }

  //call this method when you need to remove a path element (when you press back)
  updatePathListD() {
    pathList.removeLast();
    notifyListeners();
  }

  emptyPathList() {
    pathList.clear();
    notifyListeners();
  }

  //********************  Initializing Database hold variable  */

  int readyDB = 0;
  int getReadyDBStatus() => readyDB;

  updateReadyDBStatus({required int status}) {
    //   'status' is holding only values either 1 or 0
    // 0 for notReady and 1 for Ready

    readyDB = status;
    notifyListeners();
  }

  //*****************  Updating Upload task */
  bool isUploadCancelled = false;
  bool getUploadCancellationStatus() => isUploadCancelled;

  updateUploadCancellationStatus({required bool flag}) {
    isUploadCancelled = flag;
    notifyListeners();
  }

  int handleUTaskSema = 0;
  int getHandleUTaskSema() => handleUTaskSema;
  updateHandleUTaskSema({required int sema}) {
    handleUTaskSema = sema;
    notifyListeners();
  }

  UploadTask? task;
  UploadTask? getUploadTask() => task;

  updateUploadTask({required UploadTask? tsk}) {
    task = tsk;
    notifyListeners();
  }

  cancelUploadTask(context) async {
    updateHandleUTaskSema(sema: 0);
    await task!.cancel().then((value) {
      SB.ssb(context, text: "Upload Cancelled");
    });
    task = null;
    notifyListeners();
  }

  ValueNotifier<bool> dial = ValueNotifier(false);

  getDialStatus() => dial;

  updateDialStatus() {
    dial.value = false;
    notifyListeners();
  }

  int niindex = 2;

  int getNIIndex() => niindex;

  updateNIIndex(int index) {
    niindex = index;
    notifyListeners();
  }

  Users user = Users(
      uName: '',
      uNName: '',
      uEmail: '',
      upasscode: '',
      uimgString: '',
      uJoin: '',
      contactId: '',
      homeUid: '',
      recentId: '',
      starId: '');
  Users getUser() => user;

  updateUser() async {
    user = await Utility.getUserDetails();
    notifyListeners();
  }

  /// **********HANDLING NOTIFICATION *********** */

  bool isVisible = false;

  bool getIsVisible() => isVisible;
  updateIsVisible({required bool flag}) {
    isVisible = flag;
    notifyListeners();
  }

  bool loadingIndicator = false;
  bool getLoadingIndicatorStatus() => loadingIndicator;

  updateLoadingIndicatorStatus({required bool flag}) {
    loadingIndicator = flag;
    notifyListeners();
  }
}

class IU {
  static dicon(
          {required IconData icon,
          required Function callback,
          required double size,
          required double cSize}) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: cSize,
          backgroundColor: Colors.red,
          child: CircleAvatar(
            radius: cSize - 1,
            backgroundColor: Colors.black,
            child: Center(
              child: IconButton(
                splashRadius: 20,
                icon: Icon(
                  icon,
                  size: size,
                  color: Colors.grey,
                ),
                onPressed: () => callback(),
              ),
            ),
          ),
        ),
      );

  static diconl(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      IconButton(
        splashRadius: 20,
        icon: Icon(
          icon,
          size: size,
          color: Colors.red,
        ),
        onPressed: () => callback(),
      );

  static ditask(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      IconButton(
        splashColor: Colors.red,
        splashRadius: 20,
        icon: Icon(
          icon,
          size: size,
          color: Colors.white54,
        ),
        onPressed: () => callback(),
      );

  static dNIcon({required IconData icon, required double size}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Icon(
          icon,
          size: size,
        ),
      );
}

class TF {
  static getTField(context,
          {required TextEditingController con, required String htext}) =>
      Row(children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black26),
            child: TextFormField(
              controller: con,
              style: TU.tesmall(context, 44),
              cursorColor: Colors.white,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: htext,
                  hintStyle: TU.tesmall(context, 54)),
            ),
          ),
        )
      ]);

  static getTField2(context,
          {required TextEditingController con, required String htext}) =>
      Row(children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white12, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: con,
              style: TU.tesmall(context, 44),
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: htext,
                  hintStyle: TU.tesmall(context, 54)),
            ),
          ),
        )
      ]);

  static inst(context, {required text}) => Text(
        text,
        style: TU.teeesmall(context, 50),
      );
  static instl(context, {required text, required double fSize}) => Text(
        text,
        style: TU.teeesmall(context, fSize),
      );
}

class Mapping {
  static List<Widget> mapper(
      {required List<dynamic> list,
      required bool flag,
      required HandlingFS handlingFS}) {
    List<Widget> fList = [];
    List<ShortFD> folderList = [];
    list.forEach((element) {
      folderList.add(ShortFD.fromJson(map: element));
    });
    folderList
        .sort((a, b) => a.fName.toLowerCase().compareTo(b.fName.toLowerCase()));
    folderList.forEach((element) {
      fList.add(FolderTile(
        folder: element,
        type: flag,
        handlingFS: handlingFS,
      ));
    });
    return fList;
  }

  static List<Widget> mapFiles(
      {required List<dynamic> list,
      required bool flag,
      required HandlingFS handlingFS}) {
    List<Widget> fList = [];
    List<CFile> fileList = [];
    list.forEach((element) {
      fileList.add(CFile.fromJson(json: element));
    });
    fileList.sort(
        (a, b) => a.fileName.toLowerCase().compareTo(b.fileName.toLowerCase()));
    fileList.forEach((element) {
      fList.add(FileTile(
        cFile: element,
        type: flag,
        handlingFS: handlingFS,
      ));
    });
    return fList;
  }

  static List<Widget> mapRecents(
      {required List<dynamic> list,
      required bool flag,
      required HandlingFS handlingFS}) {
    List<Widget> fList = [];
    list.forEach((element) {
      fList.add(RecentDocTile(
          cFile: CFile.fromJson(json: element),
          type: flag,
          handlingFS: handlingFS));
    });

    return fList;
  }
}

class Help {
  static String trimExtension({required String filename}) {
    List<String> list = filename.split('.');
    String name = '';
    if (list.length == 1 || list.length == 0) {
      return filename;
    }
    for (int i = 0; i < list.length - 1; i++) {
      if (i == list.length - 2) {
        name += list[i];
      } else {
        name += '${list[i]}.';
      }
    }
    return name;
  }
}

class CIC {
  static Future<bool> checkConnectivity(context) async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      SB.ssb(context, text: 'no internet connection found');
      return false;
    }
  }

  static Future<bool> checkConnectivityforModals(context) async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      return false;
    }
  }
  static StreamSubscription<ConnectivityResult> getSubscription(context,
          {required Function callback}) =>
      Connectivity().onConnectivityChanged.listen((event) {
        if (event == ConnectivityResult.none) {
          GetChanges changes = Provider.of<GetChanges>(context, listen: false);
          changes.updateDialStatus();
          SB.ssb(context, text: 'no internet connection found');
        } else {
          callback();
        }
      });
}
