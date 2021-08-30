

import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(child: Container(
    color: Color(0xFFF2F2F2),
      child: Center(
        child: TextButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          child: Text('clear preferences', style: TU.tsmall(context)),
          onPressed: () async {
            await Utility.clearPreferences();
            Phoenix.rebirth(context);
          },
        ),
      ),
    ),),
        ),
      ),
    );
  }
}