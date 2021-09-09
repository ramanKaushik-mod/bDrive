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
          Navigator.pushNamed(context, '/hp');
        } else {
          Navigator.pushNamed(context, '/pp');
        }
      } else {
        Navigator.pushNamed(context, '/aup');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: Container(
        color: Colors.blue[400],
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
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 20,
                  color: Colors.black,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    margin: EdgeInsets.all(25),
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
