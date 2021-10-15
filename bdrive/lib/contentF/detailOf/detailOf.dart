import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailOfFolder extends StatefulWidget {
  final String docID;
  final HandlingFS handlingFS;
  const DetailOfFolder(
      {Key? key, required this.docID, required this.handlingFS})
      : super(key: key);

  @override
  _DetailOfFolderState createState() => _DetailOfFolderState();
}

class _DetailOfFolderState extends State<DetailOfFolder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: FutureBuilder(
          future: widget.handlingFS.getFolderDetails(docID: widget.docID),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> map = snapshot.data as Map<String, dynamic>;
              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) => [
                            SliverAppBar(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              backgroundColor: Colors.white12,
                              leading: IU.diconl(
                                  icon: Icons.arrow_back_ios_new_outlined,
                                  callback: () {
                                    Navigator.pop(context);
                                  },
                                  size: 28),
                              title: Text(
                                map['fName'],
                                style: TU.teeesmall(context, 42),
                              ),
                            )
                          ],
                  body: Container(
                    color: Colors.black87,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Stack(
                          children: [
                            Container(
                              height: TU.getw(context) / 1.5,
                              width: TU.getw(context),
                              child: Icon(
                                FontAwesomeIcons.solidFolder,
                                color: Colors.white38,
                                size: TU.getw(context) / 4,
                              ),
                            ),
                            if (map['star'] == true) ...[
                              Container(
                                height: TU.getw(context) / 1.5,
                                width: TU.getw(context),
                                child: Icon(
                                  FontAwesomeIcons.star,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ]
                          ],
                        ),
                        Card(
                          elevation: 0,
                          color: Colors.white54,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19.8),
                                color: Colors.black),
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.5, vertical: 0.7),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                detailOfFolder(
                                    label: 'created at  :  ',
                                    detail: map['createdAt'].split(' ')[0]),
                                detailOfFolder(
                                    label: 'last modified  :  ',
                                    detail: map['createdAt'].split(' ')[0]),
                                detailOfFolder(
                                    label: 'sub folders  :  ',
                                    detail:
                                        map['folderList'].length.toString()),
                                detailOfFolder(
                                    label: 'files  :  ',
                                    detail: map['fileList'].length.toString()),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ));
            }
            return Container();
          }),
    );
  }

  detailOfFolder({required String label, required String detail}) => Column(
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  width: TU.getw(context) / 2.5,
                  child: Text(
                    label,
                    style: TU.teeesmall(context, 40),
                  )),
              Text(
                detail,
                style: TU.teeesmall(context, 40),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
}

class DetailOfFile extends StatefulWidget {
  final String parentDocID;
  final String dan;
  final HandlingFS handlingFS;
  const DetailOfFile(
      {Key? key,
      required this.parentDocID,
      required this.handlingFS,
      required this.dan})
      : super(key: key);

  @override
  _DetailOfFileState createState() => _DetailOfFileState();
}

class _DetailOfFileState extends State<DetailOfFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: FutureBuilder(
          future: widget.handlingFS.getFileDetails(dan: widget.dan, parentDocID: widget.parentDocID,),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> map = snapshot.data as Map<String, dynamic>;
              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) => [
                            SliverAppBar(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              backgroundColor: Colors.white12,
                              leading: IU.diconl(
                                  icon: Icons.arrow_back_ios_new_outlined,
                                  callback: () {
                                    Navigator.pop(context);
                                  },
                                  size: 28),
                              title: Text(
                                map['fileName'],
                                style: TU.teeesmall(context, 42),
                              ),
                            )
                          ],
                  body: Container(
                    color: Colors.black87,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Stack(
                          children: [
                            Container(
                              height: TU.getw(context) / 1.5,
                              width: TU.getw(context),
                              child: Icon(
                                FontAwesomeIcons.file,
                                color: Colors.white38,
                                size: TU.getw(context) / 4,
                              ),
                            ),
                            if (map['star'] == true) ...[
                              Container(
                                height: TU.getw(context) / 1.5,
                                width: TU.getw(context),
                                child: Icon(
                                  FontAwesomeIcons.star,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              ),
                            ]
                          ],
                        ),
                        Card(
                          elevation: 0,
                          color: Colors.white54,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19.8),
                                color: Colors.black),
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.5, vertical: 0.7),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                detailOfile(
                                    label: 'uploaded at  :  ',
                                    detail: map['uploadTime'].split(' ')[0]),
                                detailOfile(
                                    label: 'location : ',
                                    detail: map['path']),
                                detailOfile(
                                    label: 'size : ',
                                    detail: map['size'].toStringAsFixed(2) + ' mb'),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ));
            }
            return Container();
          }),
    );
  }

  detailOfile({required String label, required String detail}) => Column(
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  width: TU.getw(context) / 2.5,
                  child: Text(
                    label,
                    style: TU.teeesmall(context, 40),
                  )),
              Text(
                detail,
                style: TU.teeesmall(context, 40),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
}
