import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

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
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black38,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.folder,
                  color: Colors.black,
                  size: TU.geth(context) / 7,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(text: widget.folder.fName),
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
                ),
              ],
            ),
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

class User {
  final String uName;
  final String uNName;
  final String uEmail;
  final String upasscode;
  final String uimgString;
  final String uJoin;
  final String contactId;

  User(
      {required this.uName,
      required this.uNName,
      required this.uEmail,
      required this.upasscode,
      required this.uimgString,
      required this.uJoin,
      required this.contactId});

  Map<String, dynamic> toJson() => {
        'uName': this.uNName,
        'uNName': this.uNName,
        'uEmail': this.uEmail,
        'upasscode': this.upasscode,
        'uimgString': this.uimgString,
        'uJoin': this.uJoin,
        'contactId': this.contactId
      };

  User fromJson(Map<String, dynamic> map) => User(
      uName: map[uName],
      uNName: map[uNName],
      uEmail: map[uEmail],
      upasscode: map[upasscode],
      uimgString: map[uimgString],
      uJoin: map['uJoin'],
      contactId: map['contactId']);
}
