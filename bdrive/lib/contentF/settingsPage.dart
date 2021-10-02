import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        child: Center(
          child: Container(
            color: Colors.white24,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Utility.clearPreferences();
          Phoenix.rebirth(context);

        },
        backgroundColor: Colors.grey[900],
        child: Icon(Icons.clear_all, color:Colors.red),
      ),
    );
  }
}
