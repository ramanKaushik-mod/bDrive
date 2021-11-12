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
        fit: BoxFit.cover,
        height: double.maxFinite,
        width: double.maxFinite,
      );
  static void exitApp(BuildContext context) {
    SystemNavigator.pop();
  }

  static setProfileStatus(bool flag) =>
      gsi().then((value) => value.setBool(Constants.pStatus, flag));

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
      value.setString(Constants.searchId, map['searchId']);
      value.setInt(Constants.nFiles, map['nFiles']);
      value.setInt(Constants.nFolders, map['nFolders']);
      value.setDouble(Constants.space, map['space']);
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
          starId: value.getString(Constants.starId) ?? '',
          nFiles: value.getInt(Constants.nFiles) ?? 0,
          nFolders: value.getInt(Constants.nFolders) ?? 0,
          searchId: value.getString(Constants.searchId) ?? '',
          space: value.getDouble(Constants.space) ?? 0);
    });
  }

  static setSubSetInfo(
          {required String uName,
          required String uNName,
          required String email,
          required String passcode}) async =>
      await gsi().then((value) {
        value.setString(Constants.uEmail, email);
        value.setString(Constants.upasscode, passcode);
        value.setString(Constants.userName, uName);
        value.setString(Constants.uID, uNName);
      });

  static Future<String> getHomeUID() async =>
      await gsi().then((value) => value.getString(Constants.homeUid) ?? '');

  static Future<String> getStarDID() async =>
      await gsi().then((value) => value.getString(Constants.starId) ?? '');

  static Future<String> getRecentDID() async =>
      await gsi().then((value) => value.getString(Constants.recentId) ?? '');

  static Future<String> getSearchDID() async =>
      await gsi().then((value) => value.getString(Constants.searchId) ?? '');

  static Future<int> getNFolders() async =>
      await gsi().then((value) => value.getInt(Constants.nFolders) ?? 0);

  static setNFolders({required int nf}) async =>
      await gsi().then((value) => value.setInt(Constants.nFolders, nf));

  static Future<int> getNFiles() async =>
      await gsi().then((value) => value.getInt(Constants.nFiles) ?? 0);

  static setNFiles({required int nf}) async =>
      await gsi().then((value) => value.setInt(Constants.nFiles, nf));

  static Future<double> getSpace() async =>
      await gsi().then((value) => value.getDouble(Constants.space) ?? 0.0);

  static setSpace({required double space}) async =>
      await gsi().then((value) => value.setDouble(Constants.space, space));

  static getUPasscode() async =>
      await gsi().then((value) => value.getString(Constants.upasscode));
}

class SB {
  static CU cu = CU();
  static ssb(context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
            foreground: Paint()..shader = TU.linearGradient, fontSize: 14),
      ),
      backgroundColor: cu.cwhite,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(milliseconds: 1500),
    ));
  }

  static ssb2(context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
            foreground: Paint()..shader = TU.linearGradient, fontSize: 14),
      ),
      backgroundColor: cu.b,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(milliseconds: 1500),
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
                  ? Text(dialog, style: TU.teeesmall(context, 50))
                  : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Wrap(
                children: [
                  if (controller == null) ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: Center(
                        child: Text(dialog, style: TU.teeesmall(con, 50)),
                      ),
                    ),
                  ],
                  if (controller != null) ...[
                    TextFormField(
                      controller: controller,
                      textAlign: TextAlign.left,
                      style: TU.teeesmall(context, 48),
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
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                InkResponse(
                    onTap: () {
                      noFunc();
                      Navigator.pop(con);
                    },
                    child:
                        BU.btDialogDUIB(icon: Icons.close_rounded, size: 20)),
                InkResponse(
                    onTap: () async {
                      if (dialog == 'your passcode') {
                        String pcode = await Utility.getUPasscode();
                        if (pcode == controller.text.trim()) {
                          yesFunc();
                        } else if( controller.text.trim().length == 0){
                          ssb(context, text: 'passcode is necessary');
                        } else {
                           ssb(context, text: 'passcode do not match');
                        }
                        Navigator.pop(con);
                      } else {
                        yesFunc();
                        Navigator.pop(con);
                      }
                    },
                    child: BU.btDialogDUIB(
                        icon: Icons.arrow_forward_ios, size: 20))
              ],
            );
          });
}

class TU {
  static CU cu = CU();
  //text utitlity
  static Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static geth(context) => MediaQuery.of(context).size.height;
  static getw(context) => MediaQuery.of(context).size.width;

  static tlarge(context, factor) => GoogleFonts.montserratAlternates(
      fontSize: geth(context) / factor,
      color: Colors.blue[800],
      fontWeight: FontWeight.w400);
  static tesmall(context, factor) => GoogleFonts.mulish(
      fontSize: geth(context) / factor,
      color: Colors.white70,
      fontWeight: FontWeight.w500);
  static teesmall(context) => TextStyle(
        fontSize: geth(context) / 60,
        fontWeight: FontWeight.w500,
      );
  static teeesmall(context, factor) => GoogleFonts.mulish(
      fontSize: geth(context) / factor,
      fontWeight: FontWeight.w600,
      foreground: Paint()..shader = linearGradient);

  static cAppText(context, factor) => GoogleFonts.mulish(
      fontSize: geth(context) / factor,
      fontWeight: FontWeight.w600,
      color: cu.twhite);

  static tuD(context) => Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: 140),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cu.c2white,
        ),
      );

  static tuDFBM(context, factor) => Container(
        width: getw(context) / factor,
        height: 4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: cu.c2white),
      );
  static tuDw() => Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 20,
        width: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cu.twhite,
        ),
      );
  static tTitle(BuildContext context) => TextStyle(
      fontSize: geth(context) / 30,
      color: Colors.grey,
      fontWeight: FontWeight.w700);

  static tSDLabel({required context, required String label}) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: cu.accent),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: cu.cwhite),
            child: TU.cat(context, text: label, factor: 60)),
      );

  static cat(context, {required text, required factor}) => RichText(
      text: TextSpan(
          text: text,
          style: GoogleFonts.mulish(
            color: cu.twhite,
            fontSize: geth(context) / factor,
            fontWeight: FontWeight.w600,
          )),
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis);
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
      starId: '',
      nFiles: 0,
      nFolders: 0,
      searchId: '',
      space: 0);
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

  //**************SEARCH LIST************ */
  List<SFile> sList = [];
  List<SFile> getSList() => sList;

  updateSList({required List<SFile> list}) {
    sList = list;
    notifyListeners();
  }

  List<Widget> wList = [];
  List<Widget> getWList() => wList;

  updateWList({required List<Widget> list}) {
    wList = list;
    notifyListeners();
  }
}

class IU {
  static CU cu = CU();
  static dicon(
          {required IconData icon,
          required Function callback,
          required double size,
          required double cSize}) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: cSize,
          backgroundColor: Colors.white10,
          child: CircleAvatar(
            radius: cSize - 2,
            backgroundColor: Colors.black,
            child: Center(
              child: IconButton(
                splashRadius: 20,
                icon: dFIcon(
                  icon: icon,
                  size: size,
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
        color: Colors.white,
        splashRadius: 20,
        icon: IU.dBIcon(icon: icon, size: size),
        onPressed: () => callback(),
      );

  static dstask(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      IconButton(
        icon: Icon(
          icon,
          size: size,
          color: Colors.blue[800],
        ),
        onPressed: () => callback(),
      );

  static ditask(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      IconButton(
        splashRadius: 20,
        icon: Icon(
          icon,
          size: size,
          color: Colors.white70,
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

  static dCIcon({required IconData icon, required double size}) => Icon(
        icon,
        size: size,
      );

  static dGIcon({required IconData icon, required double size}) => ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 0.7,
          colors: <Color>[
            Colors.blue,
            Colors.deepPurple,
            Colors.deepPurpleAccent,
            Colors.red
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
      ));

  static dBIcon({required IconData icon, required double size}) => ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 0.9,
          colors: <Color>[
            Colors.orange,
            Colors.purple,
            Colors.purple,
            Colors.red
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: size,
        ),
      ));

  static dFIcon({required IconData icon, required double size}) => ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 0.9,
          colors: <Color>[
            Colors.orange,
            Colors.purple,
            Colors.purple,
            Colors.red
          ],
          tileMode: TileMode.mirror,
        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0));
      },
      child: Icon(
        icon,
        size: size,
      ));

  static dFAIcon({required IconData icon, required double size}) => ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 0.9,
          colors: <Color>[
            Colors.orange,
            Colors.purple,
            Colors.purple,
            Colors.red
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: size,
        ),
      ));

  static iwoc({required IconData icon, required double size}) => Icon(
        icon,
        size: size,
        color: cu.twhite,
      );
  static iwc(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      IconButton(
        splashRadius:20,
        icon: Icon(
          icon,
          size: size,
          color: cu.twhite,
        ),
        onPressed: () {
          callback();
        },
      );

  static iwcow(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      IconButton(
        icon: Icon(icon, size: size, color: cu.twhite),
        onPressed: () {
          callback();
        },
      );
}

class TF {
  static CU cu = CU();
  static getTField(context,
          {required TextEditingController con, required String htext}) =>
      Row(children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white10),
            child: TextFormField(
              controller: con,
              style: TU.tesmall(context, 55),
              cursorColor: Colors.white,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: htext,
                  hintStyle: TU.tesmall(context, 60)),
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
                color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: con,
              style: TU.tesmall(context, 44),
              showCursor: false,
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
        style: TU.tlarge(context, 56),
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
      required HandlingFS handlingFS,
      required String callFrom}) {
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
          callFrom: callFrom));
    });
    return fList;
  }

  static List<Widget> mapFiles(
      {required List<dynamic> list,
      required bool flag,
      required HandlingFS handlingFS,
      required String callFrom}) {
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
        callFrom: callFrom,
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

  static List<Widget> mapSFiles(
      {required List<SFile> list, required HandlingFS handlingFS}) {
    List<Widget> wlist = [];
    list.forEach((element) {
      wlist.add(SFileTile(sFile: element, handlingFS: handlingFS));
    });
    return wlist;
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
          SB.ssb2(context, text: 'no internet connection found');
        } else {
          callback();
        }
      });
}

class BU {
  static CU cu = CU();
  static btDialogDUIB({required IconData icon, required double size}) =>
      Container(
        margin: EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient:
                RadialGradient(colors: [Color(0xffDA44bb), Color(0xff8921aa)])),
        child: Card(
          margin: EdgeInsets.all(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: cu.b,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: cu.cwhite),
            child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(colors: [Colors.red, Colors.purple])
                      .createShader(bounds);
                },
                child: CircleAvatar(
                    radius: 10,
                    backgroundColor: cu.t,
                    child: Icon(icon, size: size))),
          ),
        ),
      );

  static btDialogDUI({required IconData icon, required double size}) => Card(
        color: cu.accent,
        margin: EdgeInsets.only(bottom: 4),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: cu.cwhite),
            child: Icon(icon, size: size, color: Colors.white70)),
      );
}
