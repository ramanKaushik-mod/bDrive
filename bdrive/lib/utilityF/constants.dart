import 'package:flutter/material.dart';

class Constants {
  static String signedIn = 'SIGNED_IN';
  static String onBoardVisited = 'ONBOARD_VISITED';
  static String vFyId = 'V_FY_ID';

  static String userName = 'USER_NAME';
  static String uID = 'USER_ID';
  static String uEmail = 'USER_EMAIL_ID';
  static String imgKey = 'IMAGE_KEY';
  static String userCon = 'USER_CONTACT';
  static String upasscode = 'USER_PASSCODE';
  static String uJoin = 'USER_JOIN_TIME';
  static String homeUid = 'HOME_UID';
  static String recentId = 'RECENT_ID';
  static String starId = 'STAR_ID';
  static String searchId = 'SEARCH_ID';
  static String nFolders = 'N_FOLDERS';
  static String nFiles = 'N_FILES';
  static String space = 'SPACE';

  static String pStatus = 'PROFILE_STATUS';
}

class TS {
  static String svp =
      'If somehow the app could not be able to auto retrieve the SMS-CODE, You need to Enter it manually.';
  static String svp2 = 'Enter your number to proceed.';
  static String svp3 = "We'll wait for ";
  static String seconds = " seconds";

  static String nvp = 'Welcome to bCLOUD';
  static String nvp1 =
      'Here, \n\n             we will be verifying your number and A 6-digit SMS-Code will be sent to your number.';
  static String pyourName = 'your name';
  static String puserName = '@nickname (at least 3 characters)';
  static String pemailId = 'your email id';
  static String ppcode = 'your passcode (at least 8 characters with no space)';

  static String firstTime =
      "If it's your first time with bCLOUD you need to enter the required information";
  static String inst1 =
      "If it's not the first time, then we will automatically fetch your details, and in case you want to change any of your information, you can now";
  static String inst2 =
      "We need above information, So that you can access your account on WEB as well";
  static String inst3 = "www.bCLOUD.com";

  //*******Authentication Page**** */
  static String numHint = 'Enter your Number';
  static String smsCodeHint = 'SMS Code';
}

// class CU {

// }

class CU extends StatefulWidget {
  final Color accent = Colors.black;
  final Color offwhite = Color(0xFFF2F2F2);
  final Color orange = Colors.orange;
  final Color ac = Colors.black38;
  final Color tfc = Colors.black87;
  final Color cwhite = Colors.white10;
  final Color c2white = Colors.white24;

  final Color bnbc = Colors.white12;
  final Color cblack = Colors.black38;
  final Color c4black = Colors.black45;
  final Color twhite = Colors.white70;
  final Color w = Colors.white;
  final Color be = Colors.black87;
  final Color b = Colors.black;
  final Color t = Colors.transparent;
  CU({Key? key}) : super(key: key);

  @override
  _CUState createState() => _CUState();
}

class _CUState extends State<CU> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
