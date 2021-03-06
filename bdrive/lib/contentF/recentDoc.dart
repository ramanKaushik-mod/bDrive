import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RecentDocPage extends StatefulWidget {
  final HandlingFS handlingFS;
  final String docId;
  const RecentDocPage({Key? key, required this.handlingFS, required this.docId})
      : super(key: key);

  @override
  _RecentDocPageState createState() => _RecentDocPageState();
}

class _RecentDocPageState extends State<RecentDocPage> {
  CU cu = CU();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
      color: Colors.white10,
          padding: EdgeInsets.all(10),
          child: Consumer<GetChanges>(
            builder: (BuildContext context, value, win) {
              bool flag = value.view == 1 ? true : false;
              return StreamBuilder<DocumentSnapshot>(
                  stream: widget.handlingFS
                      .getRecentDocAsStream(docId: widget.docId),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                          child: Wrap(
                        children: [
                          Container(
                              child: CircularProgressIndicator(
                            color: cu.w,
                          ))
                        ],
                      ));
                    }
                    if (snapShot.hasData) {
                      Map<String, dynamic> map =
                          snapShot.data!.data() as Map<String, dynamic>;
                      List<Widget> list = map['fileList'].length > 0
                          ? Mapping.mapRecents(
                              list: map['fileList'],
                              flag: flag,
                              handlingFS: widget.handlingFS)
                          : [];

                      if (list.isEmpty) {
                  return Center(
                      child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.change_history,
                            color: cu.cwhite,
                            size: 90,
                          ),
                          Positioned(
                              bottom: 1,
                              right: 1,
                              child: Icon(
                                FontAwesomeIcons.fileUpload,
                                color: Colors.white54,
                                size: 40,
                              ))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'No recents uploads',
                          style: TU.tesmall(context, 60),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'your recent uploads will appear here',
                          style: TU.tesmall(context, 70),
                        ),
                      ),
                    ],
                  ));
                }
                      list = list.reversed.toList();
                      return value.getView() == 1
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: list,
                              ),
                            )
                          : SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: list,
                              ),
                            );
                    }

                    return Center(
                        child: Wrap(
                      children: [
                        Container(
                            child: CircularProgressIndicator(
                          color: cu.w,
                        ))
                      ],
                    ));
                  });
            },
          )),
    );
  }
}
