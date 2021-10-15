import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                      .getRecentDocAsStream(docId: widget.docId),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                          child: Wrap(
                        children: [
                          Container(
                              child: CircularProgressIndicator(
                            color: Colors.red,
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
                            children: [
                              Container(
                                  child: CircularProgressIndicator(
                                color: Colors.red,
                              ))
                            ],
                          ),
                        );
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
                          color: Colors.red,
                        ))
                      ],
                    ));
                  });
            },
          )),
    );
  }
}
