

import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:flutter/material.dart';

class StarDocPage extends StatefulWidget {
  final HandlingFS handlingFS;
  const StarDocPage({ Key? key,required this.handlingFS }) : super(key: key);

  @override
  _StarDocPageState createState() => _StarDocPageState();
}

class _StarDocPageState extends State<StarDocPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Star Documents appear here'),
      ),
    );
  }
}