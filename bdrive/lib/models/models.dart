import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FolderTile extends StatefulWidget {
  final ShortFD folder;
  final bool type;
  const FolderTile({Key? key, required this.folder, required this.type})
      : super(key: key);

  @override
  _FolderTileState createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  @override
  Widget build(BuildContext context) {
    return widget.type == true
        ? InkResponse(
            onTap: () async {
              await Provider.of<GetChanges>(context, listen: false)
                  .updatePathListA(list: [widget.folder.docUid,widget.folder.fName]);
            },
            // onLongPress: () {
            //   Provider.of<GetChanges>(context, listen: false)
            //       .updateSelectColor();
            // },
          child: Card(
            color: Colors.white12,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_rounded,
                      color: Colors.white38,
                      size: 36,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          text: TextSpan(
                                    text: widget.folder.fName,
                                    style: TU.teeesmall(context, 60)
                          ),
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.ellipsisV,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ],
                )),
          ),
        )
        : InkResponse(
            onTap: () async {
              await Provider.of<GetChanges>(context, listen: false)
                  .updatePathListA(list:[widget.folder.docUid, widget.folder.fName]);
            },
            // onLongPress: () {
            //   Provider.of<GetChanges>(context, listen: false)
            //       .updateSelectColor();
            // },
            child: Consumer<GetChanges>(
                builder: (BuildContext context, value, win) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: value.selectColor,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder,
                          color: Colors.white24,
                          size: TU.geth(context) / 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: RichText(
                                text: TextSpan(
                                    text: widget.folder.fName,
                                    style: TU.teeesmall(context, 66)),
                                textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.clip
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Consumer<GetChanges>(
                        builder: (BuildContext context, value, win) {
                      return value.selectColor == Colors.black12
                          ? Positioned(
                              right: 1,
                              bottom: 1,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.circle_outlined,
                                  size: 20,
                                ),
                                color: Colors.white,
                              ),
                            )
                          : Text('');
                    })
                  ],
                ),
              );
            }),
          );
  }
}

class Folder {
  final String docUid;
  final String fName;
  final String createdAt;
  final List folderList;
  final List fileList;

  Folder(
      {required this.docUid,
      required this.fName,
      required this.createdAt,
      required this.folderList,
      required this.fileList});

  factory Folder.fromJson({required Map<String, dynamic> json}) => Folder(
      docUid: 'docUid',
      fName: json['fName'],
      createdAt: json['createdAt'],
      folderList: json['folderList'],
      fileList: json['fileList']);

  Map<String, dynamic> toJson() => {
        'docUid': this.docUid,
        'fName': this.fName,
        'createdAt': this.createdAt,
        'folderList': this.folderList,
        'fileList': this.fileList
      };
}

class ShortFD {
  final String docUid;
  final String fName;
  final String createdAt;

  ShortFD({required this.docUid, required this.fName, required this.createdAt});

  factory ShortFD.fromJson({required Map<String, dynamic> map}) => ShortFD(
      docUid: map['docUid'], fName: map['fName'], createdAt: map['createdAt']);

  Map<String, dynamic> toJson() =>
      {'docUid': this.docUid, 'fName': this.fName, 'createdAt': this.createdAt};
}

//***********************   FILE MODEL  ***********************/

class CFile {
  final String fileName;
  final String uploadTime;
  final String dLink;

  CFile(
      {required this.fileName,
      required this.uploadTime,
      required this.dLink,});

  factory CFile.fromJson({required Map<String, dynamic> json}) => CFile(
      fileName: json['fileName'],
      uploadTime: json['uploadTime'],
      dLink: json['dLink']);

  Map<String, dynamic> toJson() => {
        'fileName': this.fileName,
        'uploadTime': this.uploadTime,
        'dLink': this.dLink
      };
}

//***********************   USER MODEL  ***********************/

class Users {
  String uName;
  String uNName;
  String uEmail;
  String upasscode;
  String uimgString;
  String uJoin;
  String contactId;
  String homeUid;

  Users(
      {required this.uName,
      required this.uNName,
      required this.uEmail,
      required this.upasscode,
      required this.uimgString,
      required this.uJoin,
      required this.contactId,
      required this.homeUid});

  Map<String, dynamic> toJson() => {
        'uName': this.uName,
        'uNName': this.uNName,
        'uEmail': this.uEmail,
        'upasscode': this.upasscode,
        'uimgString': this.uimgString,
        'uJoin': this.uJoin,
        'contactId': this.contactId,
        'homeUid': this.homeUid
      };

  factory Users.fromJson({required Map<String, dynamic> map}) {
    return Users(
        uName: map['uName'],
        uNName: map['uNName'],
        uEmail: map['uEmail'],
        upasscode: map['upasscode'],
        uimgString: map['uimgString'],
        uJoin: map['uJoin'],
        contactId: map['contactId'],
        homeUid: map['homeUid']);
  }
}
