import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FolderTile extends StatefulWidget {
  final Folder folder;
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
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black87,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: widget.folder.fName,
                          ),
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        RichText(
                          text: TextSpan(
                              text: widget.folder.createdAt,
                              style: TU.teeesmall(context, 70.0)),
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  FontAwesomeIcons.ellipsisV,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ))
        : InkResponse(
            onTap: () {},
            onLongPress: () {
              Provider.of<GetChanges>(context, listen: false)
                  .updateSelectColor();
            },
            child: Consumer<GetChanges>(
                builder: (BuildContext context, value, win) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.all(0),
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
                          color: Colors.black,
                          size: TU.geth(context) / 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text: widget.folder.fName,
                                    style: TU.teeesmall(context, 66)),
                                textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Consumer<GetChanges>(
                        builder: (BuildContext context, value, win) {
                      return value.selectColor == Colors.black12? Positioned(
                    right: 1,
                    bottom: 1,
                        child: IconButton(
                          onPressed: () {

                            
                          },
                          icon: Icon(
                            Icons.circle_outlined,
                            size: 20,
                          ),
                          color: Colors.white,
                        ),
                      ):Text('');
                    })
                  ],
                ),
              );
            }),
          );
  }
}

class Folder {
  final String fName;
  final String createdAt;
  final List folderList;
  final List fileList;

  Folder(
      {required this.fName,
      required this.createdAt,
      required this.folderList,
      required this.fileList});

  Folder fromJson(Map<String, dynamic> json) => Folder(
      fName: json['fName'],
      createdAt: json['createdAt'],
      folderList: json['folderList'],
      fileList: json['fileList']);

  Map<String, dynamic> toJson() => {
        'fName': this.fName,
        'createdAt': this.createdAt,
        'folderList': this.folderList,
        'fileList': this.fileList
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

  Users(
      {required this.uName,
      required this.uNName,
      required this.uEmail,
      required this.upasscode,
      required this.uimgString,
      required this.uJoin,
      required this.contactId});

  Map<String, dynamic> toJson() => {
        'uName': this.uName,
        'uNName': this.uNName,
        'uEmail': this.uEmail,
        'upasscode': this.upasscode,
        'uimgString': this.uimgString,
        'uJoin': this.uJoin,
        'contactId': this.contactId
      };

  factory Users.fromJson(Map<String, dynamic> map) {
    return Users(
        uName: map['uName'],
        uNName: map['uNName'],
        uEmail: map['uEmail'],
        upasscode: map['upasscode'],
        uimgString: map['uimgString'],
        uJoin: map['uJoin'],
        contactId: map['contactId']);
  }
}
