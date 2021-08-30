import 'package:bdrive/utilityF/constants.dart';
import 'package:flutter/material.dart';
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
}

class SB {
  static ssb(context, {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 2000),
    ));
  }

  static sdb(context, yesFunc, noFunc, {required String dialog}) => showDialog(
      context: context,
      builder: (con) => AlertDialog(
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Wrap(
              children: [
                Container(
                  child: Center(
                    child: Text(dialog, style: TU.tsmall(con)),
                  ),
                )
              ],
            ),
            actions: [
              if (noFunc != null) ...[
                IconButton(
                    onPressed: () {
                      // noFunc();
                      Navigator.pop(con);
                    },
                    icon: Icon(Icons.close_rounded, color: Colors.white))
              ],
              if (yesFunc != null) ...[
                IconButton(
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 2), () {
                        yesFunc();
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ))
              ]
            ],
          ));

  static cpi(context) => showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 150),
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              height: 90,
              width: 90,
              child: Center(
                child: Container(
                  height: 90,
                  width: 90,
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ));
}

class TU {
  static geth(context) => MediaQuery.of(context).size.height;
  static getw(context) => MediaQuery.of(context).size.width;

  static tsmall(context) =>
      TextStyle(fontSize: geth(context) / 48, color: Colors.white);
  static tlarge(context) => TextStyle(
      fontSize: geth(context) / 38,
      color: Colors.white,
      fontWeight: FontWeight.w400);
  static tesmall(context) => TextStyle(
      fontSize: geth(context) / 50,
      color: Colors.black,
      fontWeight: FontWeight.w500);
  static tesmallw(context) => TextStyle(
      fontSize: geth(context) / 50,
      color: Colors.white,
      fontWeight: FontWeight.w500);
  static telarge(context) => TextStyle(
      fontSize: geth(context) / 36,
      color: Colors.blue[900],
      fontWeight: FontWeight.w600);

  static tuD() => Container(
        height: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      );

  static tTitle(BuildContext context) =>
      TextStyle(fontSize: geth(context) / 30,
      color: Colors.grey,
      fontWeight: FontWeight.w700 );
}

class GetChanges extends ChangeNotifier {
  int time = 30;
  int getUpdateTime() => time;

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
}

class IU {
  static dicon(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey[300],
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFF2F2F2),
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
      );

  static diconl(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      IconButton(
        icon: Icon(
          icon,
          size: size,
          color: Colors.grey,
        ),
        onPressed: () => callback(),
      );

  static ditask(
          {required IconData icon,
          required Function callback,
          required double size}) =>
      CircleAvatar(
        radius: 29,
        backgroundColor: Colors.grey,
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              size: size,
              color: Colors.grey,
            ),
            onPressed: () => callback(),
          ),
        ),
      );
}
