

import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:flutter/material.dart';

class RecentDocPage extends StatefulWidget {
  final HandlingFS handlingFS;
  const RecentDocPage({ Key? key,required this.handlingFS }) : super(key: key);

  @override
  _RecentDocPageState createState() => _RecentDocPageState();
}

class _RecentDocPageState extends State<RecentDocPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Recent Documnet Page"),
      ),
    );
  }
}