import 'package:bdrive/utilityF/constants.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class StarDocPage extends StatefulWidget {
  final HandlingFS handlingFS;
  final String docId;
  const StarDocPage({
    Key? key,
    required this.handlingFS,
    required this.docId,
  }) : super(key: key);

  @override
  _StarDocPageState createState() => _StarDocPageState();
}

class _StarDocPageState extends State<StarDocPage> {
  CU cu = CU();

  @override
  void initState() {
    super.initState();
    updateDirectory();
  }

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
                  stream:
                      widget.handlingFS.getStarDocAsStream(docId: widget.docId),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                          child: Wrap(
                        children: [
                          Container(
                              child: CircularProgressIndicator(
                            color: Colors.blue,
                          ))
                        ],
                      ));
                    }
                    if (snapShot.hasData) {
                      Map<String, dynamic> map =
                          snapShot.data!.data() as Map<String, dynamic>;
                      List<Widget> list = map['folderList'].length > 0
                          ? Mapping.mapper(
                              list: map['folderList'],
                              flag: flag,
                              handlingFS: widget.handlingFS,
                              callFrom: 'star')
                          : [];
                      List<Widget> flist = map['fileList'].length > 0
                          ? Mapping.mapFiles(
                              list: map['fileList'],
                              flag: flag,
                              handlingFS: widget.handlingFS,
                              callFrom: 'star')
                          : [];
                      flist.forEach((element) {
                        list.add(element);
                      });
                      if (list.isEmpty) {
                        return Center(
                            child: Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Icon(
                                  Icons.star_border_outlined,
                                  color: cu.cwhite,
                                  size: 90,
                                ),
                                Positioned(
                                    bottom: 1,
                                    right: 1,
                                    child: Icon(
                                      FontAwesomeIcons.file,
                                      color: Colors.white54,
                                      size: 40,
                                    ))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'No starred files',
                                style: TU.tesmall(context, 60),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Add stars to files & folders you want to easily find later',
                                style: TU.tesmall(context, 70),
                              ),
                            ),
                          ],
                        ));
                      }

                      return value.getView() == 1
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: list,
                              ),
                            )
                          : GridView.count(
                              shrinkWrap: true,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 10,
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              children: list,
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

  void updateDirectory() async{
    GetChanges changes = await Provider.of<GetChanges>(context, listen: false);
    while (changes.pathList.length != 1) {
      changes.updatePathListD();
    }
  }
}
