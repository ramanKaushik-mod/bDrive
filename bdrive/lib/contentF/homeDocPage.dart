import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDocPage extends StatefulWidget {
  final HandlingFS handlingFS;
  const HomeDocPage({Key? key, required this.handlingFS}) : super(key: key);

  @override
  _HomeDocPageState createState() => _HomeDocPageState();
}

class _HomeDocPageState extends State<HomeDocPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(10),
      color: Colors.black38,
      child: Consumer<GetChanges>(
        builder: (BuildContext context, value, win) {
          bool flag = value.view == 1 ? true : false;
          return StreamBuilder<DocumentSnapshot>(
              stream: widget.handlingFS
                  .getFilesAndFoldersStream(path: value.pathList.last[0]),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapShot) {
                if (!snapShot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                Map<String, dynamic> map =
                    snapShot.data!.data() as Map<String, dynamic>;

                return value.getView() == 1
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: map['folderList'].length > 0
                              ? Mapping.mapper(
                                  list: map['folderList'], flag: flag)
                              : [],
                        ),
                      )
                    : GridView.count(
                        shrinkWrap: true,
                        crossAxisSpacing: 10,
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        children: map['folderList'].length > 0
                            ? Mapping.mapper(
                                list: map['folderList'], flag: flag)
                            : [],
                      );
              });
        },
      ),
    ));
  }
}
