import 'package:bdrive/utilityF/bottomModals/dModals.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FolderTile extends StatefulWidget {
  final HandlingFS handlingFS;
  final ShortFD folder;
  final bool type;
  const FolderTile(
      {Key? key,
      required this.folder,
      required this.type,
      required this.handlingFS})
      : super(key: key);

  @override
  _FolderTileState createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  @override
  Widget build(BuildContext context) {
    return widget.type == true
        ? InkResponse(
            onTap: () {
              GetChanges changes =
                  Provider.of<GetChanges>(context, listen: false);
              changes.updatePathListA(
                  list: [widget.folder.docUid, widget.folder.fName]);
              if (changes.getNIIndex() != 2) {
                changes.updateNIIndex(2);
              }
            },
            onLongPress: () {
              FolderDModals.smbs(
                  context: context,
                  shortFD: widget.folder,
                  handlingFS: widget.handlingFS,
                  callback: ({required String msg}) {
                    if (msg.length > 0) {
                      SB.ssb(context, text: msg);
                    }
                  });
            },
            child: Card(
              color: Colors.white10,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: Icon(
                          Icons.folder,
                          color: Colors.white54,
                          size: 28,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            text: TextSpan(
                                text: widget.folder.fName,
                                style: TU.teeesmall(context, 60)),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (widget.folder.star == true) ...[
                        Icon(
                          Icons.star,
                          color: Colors.white70,
                          size: 20,
                        )
                      ],
                      IconButton(
                        splashRadius: 20,
                        splashColor: Colors.red,
                        onPressed: () {
                          FolderDModals.smbs(
                              context: context,
                              shortFD: widget.folder,
                              handlingFS: widget.handlingFS,
                              callback: ({required String msg}) {
                                if (msg.length > 0) {
                                  SB.ssb(context, text: msg);
                                }
                              });
                        },
                        icon: Icon(
                          FontAwesomeIcons.ellipsisV,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ),
                    ],
                  )),
            ),
          )
        : InkResponse(
            onTap: () async {
              GetChanges changes =
                  Provider.of<GetChanges>(context, listen: false);
              changes.updatePathListA(
                  list: [widget.folder.docUid, widget.folder.fName]);
              if (changes.getNIIndex() != 2) {
                changes.updateNIIndex(2);
              }
            },
            // onLongPress: () {
            //   Provider.of<GetChanges>(context, listen: false)
            //       .updateSelectColor();
            // },

            onLongPress: () {
              FolderDModals.smbs(
                  context: context,
                  shortFD: widget.folder,
                  handlingFS: widget.handlingFS,
                  callback: ({required String msg}) {
                    if (msg.length > 0) {
                      SB.ssb(context, text: msg);
                    }
                  });
            },
            child: Consumer<GetChanges>(
                builder: (BuildContext context, value, win) {
              return Card(
                color: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white10,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder,
                            color: Colors.white54,
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
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
                      }),
                      if (widget.folder.star == true) ...[
                        Positioned(
                          top: 1,
                          right: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.star,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            }),
          );
  }
}

class FileTile extends StatefulWidget {
  final CFile cFile;
  final bool type;
  final HandlingFS handlingFS;
  const FileTile(
      {Key? key,
      required this.cFile,
      required this.type,
      required this.handlingFS})
      : super(key: key);

  @override
  _FileTileState createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
  Map<String, IconData> map = {
    'txt': FontAwesomeIcons.file,
    'docx': FontAwesomeIcons.fileWord,
    'doc': FontAwesomeIcons.fileWord,
    'csv': FontAwesomeIcons.fileCsv,
    'xls': FontAwesomeIcons.fileExcel,
    'zip': FontAwesomeIcons.fileExport,
    'ppt': FontAwesomeIcons.filePowerpoint,
    'pdf': FontAwesomeIcons.filePdf,
    'mp3': FontAwesomeIcons.fileAudio,
    'mp4': FontAwesomeIcons.fileVideo,
    'apk': FontAwesomeIcons.android,
    'jpeg': FontAwesomeIcons.fileImage,
    'jpg': FontAwesomeIcons.fileImage,
    'png': FontAwesomeIcons.fileImage,
    'webp': FontAwesomeIcons.fileImage,
    'exe': FontAwesomeIcons.windows
  };

  List<String> imageExtensions = ['jpg', 'jpeg', 'webp', 'png'];
  @override
  Widget build(BuildContext context) {
    return widget.type == true
        ? InkResponse(
            onLongPress: () {
              FileDModals.smbs(
                  context: context,
                  cFile: widget.cFile,
                  handlingFS: widget.handlingFS,
                  callback: ({required String msg}) {
                    SB.ssb(context, text: msg);
                  });
            },
            onTap: () async {
              Provider.of<GetChanges>(context, listen: false)
                  .updateLoadingIndicatorStatus(flag: true);

              await FileOps().openFile(context,
                  url: widget.cFile.dLink, fileName: widget.cFile.fileName);
            },
            child: Wrap(
              children: [
                Card(
                  color: Colors.black87,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          FutureBuilder<bool>(
                              future: CIC.checkConnectivityforModals(context),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasError) {
                                  return getFileListView();
                                }
                                if (snapshot.hasData) {
                                  return snapshot.data == true
                                      ? Stack(
                                          children: [
                                            getFileListView(),
                                            if (snapshot.data == true &&
                                                imageExtensions.contains(widget
                                                    .cFile.fileName
                                                    .split('.')
                                                    .last)) ...[
                                              Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.black,
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        widget.cFile.dLink,
                                                        fit: BoxFit.cover,
                                                        width: double.maxFinite,
                                                      )))
                                            ]
                                          ],
                                        )
                                      : getFileListView();
                                }
                                return getFileListView();
                              }),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: RichText(
                                text: TextSpan(
                                    text: Help.trimExtension(
                                        filename: widget.cFile.fileName),
                                    style: TU.teeesmall(context, 60)),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (widget.cFile.star == true) ...[
                            Icon(
                              Icons.star,
                              color: Colors.white70,
                              size: 20,
                            )
                          ],
                          IconButton(
                            splashRadius: 20,
                            splashColor: Colors.red,
                            onPressed: () {
                              FileDModals.smbs(
                                  context: context,
                                  cFile: widget.cFile,
                                  handlingFS: widget.handlingFS,
                                  callback: ({required String msg}) {
                                    SB.ssb(context, text: msg);
                                  });
                            },
                            icon: Icon(
                              FontAwesomeIcons.ellipsisV,
                              color: Colors.white54,
                              size: 16,
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    color: Colors.white70,
                    height: 2,
                  ),
                )
              ],
            ),
          )
        : InkResponse(
            onTap: () async {
              Provider.of<GetChanges>(context, listen: false)
                  .updateLoadingIndicatorStatus(flag: true);
              await FileOps().openFile(context,
                  url: widget.cFile.dLink, fileName: widget.cFile.fileName);
            },
            onLongPress: () {
              FileDModals.smbs(
                  context: context,
                  cFile: widget.cFile,
                  handlingFS: widget.handlingFS,
                  callback: ({required String msg}) {
                    SB.ssb(context, text: msg);
                  });
            },
            child: Consumer<GetChanges>(
                builder: (BuildContext context, value, win) {
              return Card(
                color: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white12,
                  ),
                  child: FutureBuilder<bool>(
                      future: CIC.checkConnectivityforModals(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == true) {
                            return getStack(0);
                          } else {
                            return getStack(1);
                          }
                        }
                        return getStack(1);
                      }),
                ),
              );
            }),
          );
  }

  getFileListView() => Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white12,
        ),
        child: Icon(
          map[widget.cFile.fileName.split('.').last] ?? FontAwesomeIcons.file,
          color: Colors.white70,
          size: 24,
        ),
      );

  getStack(int i) => Stack(
        children: [
          Container(
            padding: widget.cFile.fileName.split('.').last == "apk"
                ? EdgeInsets.only(right: 10)
                : EdgeInsets.all(0),
            child: Center(
              child: Icon(
                map[widget.cFile.fileName.split('.').last] ??
                    FontAwesomeIcons.file,
                color: Colors.white70,
                size: TU.geth(context) / 14,
              ),
            ),
          ),
          if (i == 0 &&
              imageExtensions
                  .contains(widget.cFile.fileName.split('.').last)) ...[
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.cFile.dLink,
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                      height: double.maxFinite,
                    )))
          ],
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    width: 100,
                    child: RichText(
                        text: TextSpan(
                            text: widget.cFile.fileName,
                            style: TU.teeesmall(context, 66)),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
          Consumer<GetChanges>(builder: (BuildContext context, value, win) {
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
          }),
          if (widget.cFile.star == true) ...[
            Positioned(
              top: 1,
              right: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.star,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            )
          ]
        ],
      );
}

class RecentDocTile extends StatefulWidget {
  final CFile cFile;
  final bool type;
  final HandlingFS handlingFS;
  const RecentDocTile(
      {Key? key,
      required this.cFile,
      required this.type,
      required this.handlingFS})
      : super(key: key);

  @override
  _RecentDocTileState createState() => _RecentDocTileState();
}

class _RecentDocTileState extends State<RecentDocTile> {
  Map<String, IconData> map = {
    'txt': FontAwesomeIcons.file,
    'docx': FontAwesomeIcons.fileWord,
    'doc': FontAwesomeIcons.fileWord,
    'csv': FontAwesomeIcons.fileCsv,
    'xls': FontAwesomeIcons.fileExcel,
    'zip': FontAwesomeIcons.fileExport,
    'ppt': FontAwesomeIcons.filePowerpoint,
    'pdf': FontAwesomeIcons.filePdf,
    'mp3': FontAwesomeIcons.fileAudio,
    'mp4': FontAwesomeIcons.fileVideo,
    'apk': FontAwesomeIcons.android,
    'jpeg': FontAwesomeIcons.fileImage,
    'jpg': FontAwesomeIcons.fileImage,
    'png': FontAwesomeIcons.fileImage,
    'webp': FontAwesomeIcons.fileImage,
    'exe': FontAwesomeIcons.windows
  };

  List<String> imageExtensions = ['jpg', 'jpeg', 'webp', 'png'];

  @override
  Widget build(BuildContext context) {
    return widget.type == true
        ? InkResponse(
            onLongPress: () {
              FileDModals.smbs(
                  context: context,
                  cFile: widget.cFile,
                  handlingFS: widget.handlingFS,
                  callback: ({required String msg}) {
                    SB.ssb(context, text: msg);
                  });
            },
            onTap: () async {
              Provider.of<GetChanges>(context, listen: false)
                  .updateLoadingIndicatorStatus(flag: true);
              await FileOps().openFile(context,
                  url: widget.cFile.dLink, fileName: widget.cFile.fileName);
            },
            child: Wrap(
              children: [
                Card(
                  color: Colors.black,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          FutureBuilder<bool>(
                              future: CIC.checkConnectivityforModals(context),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return getFileListView();
                                }
                                if (snapshot.hasData) {
                                  if (snapshot.data == true) {
                                    return Stack(
                                      children: [
                                        getFileListView(),
                                        if (imageExtensions.contains(widget
                                            .cFile.fileName
                                            .split('.')
                                            .last)) ...[
                                          Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black,
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    widget.cFile.dLink,
                                                    fit: BoxFit.cover,
                                                    width: double.maxFinite,
                                                  )))
                                        ]
                                      ],
                                    );
                                  } else {
                                    return getFileListView();
                                  }
                                }
                                return CircularProgressIndicator();
                              }),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: RichText(
                                text: TextSpan(
                                    text: Help.trimExtension(
                                        filename: widget.cFile.fileName),
                                    style: TU.teeesmall(context, 60)),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            splashRadius: 20,
                            splashColor: Colors.red,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.getPocket,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                          IconButton(
                            splashRadius: 20,
                            splashColor: Colors.red,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.ghost,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                          IconButton(
                            splashRadius: 20,
                            splashColor: Colors.red,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.share,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    color: Colors.white70,
                    height: 2,
                  ),
                )
              ],
            ),
          )
        : InkWell(
            onTap: () async {
              Provider.of<GetChanges>(context, listen: false)
                  .updateLoadingIndicatorStatus(flag: true);
              await FileOps().openFile(context,
                  url: widget.cFile.dLink, fileName: widget.cFile.fileName);
            },
            child: Card(
                elevation: 0,
                color: Colors.black87,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: FutureBuilder<bool>(
                    future: CIC.checkConnectivityforModals(context),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == true) {
                          return getStack(0);
                        } else {
                          return getStack(1);
                        }
                      }
                      return getStack(1);
                    })),
          );
  }

  getFileListView() => Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Icon(
          map[widget.cFile.fileName.split('.').last] ?? FontAwesomeIcons.file,
          color: Colors.white70,
          size: 24,
        ),
      );

  getStack(int i) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white12),
            height: 150,
            child: Center(
              child: Icon(
                  map[widget.cFile.fileName.split('.').last] ??
                      FontAwesomeIcons.file,
                  color: Colors.white24,
                  size: TU.getw(context) / 5),
            ),
          ),
          if (i == 0 &&
              imageExtensions
                  .contains(widget.cFile.fileName.split('.').last)) ...[
            Container(
                alignment: Alignment.centerLeft,
                height: 150,
                // width: TU.getw(context)/2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.cFile.dLink,
                      fit: BoxFit.fitWidth,
                      width: double.maxFinite,
                    ))),
          ],
          Container(
            color: Colors.black26,
            height: 150,
            width: TU.getw(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: 'file location',
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          FontAwesomeIcons.folder,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: widget.cFile.path,
                              style: TU.teeesmall(context, 66)),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RichText(
                        text: TextSpan(
                            text: widget.cFile.uploadTime.split(' ')[0],
                            style: TU.teeesmall(context, 66)),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'make available offline',
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.getPocket,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ),
                      IconButton(
                        tooltip: 'remove from recent',
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.ghost,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text: TextSpan(
                              text: widget.cFile.fileName,
                              style: TU.teeesmall(context, 66)),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'share',
                      onPressed: () {
                        FileDModals.smbs(
                            context: context,
                            cFile: widget.cFile,
                            handlingFS: widget.handlingFS,
                            callback: ({required String msg}) {
                              SB.ssb(context, text: msg);
                            });
                      },
                      icon: Icon(
                        FontAwesomeIcons.share,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      );
}

class Folder {
  final String docUid;
  final String fName;
  final String createdAt;
  final List folderList;
  final List fileList;
  final bool star;

  Folder(
      {required this.docUid,
      required this.fName,
      required this.createdAt,
      required this.folderList,
      required this.fileList,
      required this.star});

  factory Folder.fromJson({required Map<String, dynamic> json}) => Folder(
      docUid: 'docUid',
      fName: json['fName'],
      createdAt: json['createdAt'],
      folderList: json['folderList'],
      fileList: json['fileList'],
      star: json['star']);

  Map<String, dynamic> toJson() => {
        'docUid': this.docUid,
        'fName': this.fName,
        'createdAt': this.createdAt,
        'folderList': this.folderList,
        'fileList': this.fileList,
        'star': this.star
      };
}

class ShortFD {
  final String docUid;
  final String fName;
  final String createdAt;
  final bool star;

  ShortFD(
      {required this.docUid,
      required this.fName,
      required this.createdAt,
      required this.star});

  factory ShortFD.fromJson({required Map<String, dynamic> map}) => ShortFD(
      docUid: map['docUid'],
      fName: map['fName'],
      createdAt: map['createdAt'],
      star: map['star']);

  Map<String, dynamic> toJson() => {
        'docUid': this.docUid,
        'fName': this.fName,
        'createdAt': this.createdAt,
        'star': this.star
      };
}

//***********************   FILE MODEL  ***********************/

class CFile {
  final String fileName;
  final String uploadTime;
  final String dLink;
  final String dan; //short for date as name
  final bool star;
  final String path;
  final String parentDocID;
  final double size;

  CFile({
    required this.size,
    required this.path,
    required this.parentDocID,
    required this.dan,
    required this.star,
    required this.fileName,
    required this.uploadTime,
    required this.dLink,
  });

  factory CFile.fromJson({required Map<String, dynamic> json}) => CFile(
      fileName: json['fileName'],
      uploadTime: json['uploadTime'],
      dLink: json['dLink'],
      dan: json['dan'],
      star: json['star'],
      parentDocID: json['parentDocID'],
      path: json['path'],
      size: json['size']);

  Map<String, dynamic> toJson() => {
        'fileName': this.fileName,
        'uploadTime': this.uploadTime,
        'dLink': this.dLink,
        'dan': this.dan,
        'star': this.star,
        'path': this.path,
        'parentDocID': this.parentDocID,
        'size': this.size
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
  String recentId;
  String starId;

  Users(
      {required this.recentId,
      required this.starId,
      required this.uName,
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
        'homeUid': this.homeUid,
        'starId': this.starId,
        'recentId': this.recentId
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
        homeUid: map['homeUid'],
        recentId: map['recentId'],
        starId: map['starId']);
  }
}
