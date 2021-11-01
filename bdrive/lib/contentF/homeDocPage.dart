import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                if (snapShot.hasError) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
                if (!snapShot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
                Map<String, dynamic> map =
                    snapShot.data!.data() as Map<String, dynamic>;
                List<Widget> list = map['folderList'].length > 0
                    ? Mapping.mapper(
                        list: map['folderList'],
                        flag: flag,
                        handlingFS: widget.handlingFS,
                        callFrom: '')
                    : [];
                List<Widget> flist = map['fileList'].length > 0
                    ? Mapping.mapFiles(
                        list: map['fileList'],
                        flag: flag,
                        handlingFS: widget.handlingFS,
                        callFrom: '')
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
                            FontAwesomeIcons.folder,
                            color: Colors.blue[800],
                            size: 80,
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
                      if (value.pathList.length > 1) ...[
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'this folder is empty',
                            style: TU.tesmall(context, 60),
                          ),
                        ),
                      ],
                      if (value.pathList.length == 1) ...[
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'No files & folders',
                            style: TU.tesmall(context, 60),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'your files and folders will appear here',
                            style: TU.tesmall(context, 70),
                          ),
                        ),
                      ]
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
              });
        },
      ),
    ));
  }
}
