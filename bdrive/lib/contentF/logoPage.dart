import 'dart:async';

import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({Key? key}) : super(key: key);

  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      bool b = await Utility.getUserSignedInStatus();
      bool bb = await Utility.getProfileStatus();
      if (b) {
        if (bb) {
          Navigator.pushReplacementNamed(context, '/hp');
        } else {
          Navigator.pushReplacementNamed(context, '/pp');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/aup');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.white10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets\\bDrive.png',
                        height: 230,
                        width: 230,
                      ),
                      Image.asset(
                        'assets\\bDrive.png',
                        height: 140,
                        width: 140,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
