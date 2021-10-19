import 'dart:async';

import 'package:bdrive/contentF/detailOf/detailOf.dart';
import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/firebaseUtility.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FolderDModals {
  static smbs(
          {required context,
          required ShortFD shortFD,
          required HandlingFS handlingFS,
          required Function callback}) =>
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          backgroundColor: Colors.grey[900],
          builder: (BuildContext context) {
            return Container(
                child: SingleChildScrollView(
                    child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: shortFD.fName.toUpperCase(),
                      icon: Icons.folder_outlined, func: () async {
                    await Provider.of<GetChanges>(context, listen: false)
                        .updatePathListA(list: [shortFD.docUid, shortFD.fName]);
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  TU.tuDFBM(context, 1.1),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: 'Details & Activity'.toLowerCase(),
                      icon: Icons.error_outline, func: () {
                    Future.delayed(Duration(milliseconds: 10), () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailOfFolder(
                                docID: shortFD.docUid,
                                handlingFS: handlingFS,
                              )));
                    });
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: !shortFD.star
                          ? 'Add to Starred'.toLowerCase()
                          : 'Remove from starred'.toLowerCase(),
                      icon: !shortFD.star ? Icons.star_outline : Icons.star,
                      func: () async {
                    handlingFS.makeStar(
                        flag: !shortFD.star,
                        parentDocId:
                            Provider.of<GetChanges>(context, listen: false)
                                .pathList
                                .last[0],
                        sfd: shortFD,
                        starId: await Utility.getStarDID());
                    callback(
                        msg: shortFD.star == false
                            ? 'added to starred'
                            : 'removed from starred');
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: 'Rename'.toLowerCase(),
                      icon: Icons.drive_file_rename_outline, func: () {
                    Timer(Duration(milliseconds: 10), () {
                      String parentDocID =
                          Provider.of<GetChanges>(context, listen: false)
                              .pathList
                              .last[0];
                      TextEditingController controller =
                          TextEditingController();
                      SB.sdb(context, () {
                        if (controller.text.trim().length > 0) {
                          handlingFS.renameFolder(
                              parentDocID: parentDocID,
                              sfd: shortFD,
                              name: controller.text.trim());
                        } else {
                          callback(msg: 'not a valid name');
                        }
                      }, () {}, controller, dialog: 'Rename');
                    });
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  TU.tuDFBM(context, 1.1),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: 'Remove'.toLowerCase(),
                      icon: Icons.delete_outline_outlined, func: () {
                    handlingFS.deleteFolder(
                        parentDocID:
                            Provider.of<GetChanges>(context, listen: false)
                                .pathList
                                .last[0],
                        fd: shortFD);
                    Future.delayed(Duration(milliseconds: 10), () {
                      callback(msg: 'folder deleted');
                    });
                    Navigator.of(context).pop();
                  }),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )));
          },
          context: context);

  static getRow(context,
          {required String label,
          required IconData icon,
          required Function func}) =>
      InkResponse(
        onTap: () => func(),
        child: Row(
          children: [
            IU.ditask(icon: icon, callback: () {}, size: 22),
            Expanded(
              child: RichText(
                text: TextSpan(text: label, style: TU.teeesmall(context, 60)),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            )
          ],
        ),
      );
}

class FileDModals {
  static smbs(
          {required ctx,
          required CFile cFile,
          required HandlingFS handlingFS,
          required Function callback}) =>
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          backgroundColor: Colors.grey[900],
          builder: (BuildContext context) {
            return Container(
                child: SingleChildScrollView(
                    child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: cFile.fileName.toUpperCase(),
                      icon: FontAwesomeIcons.file,
                      func: () {}),
                  SizedBox(
                    height: 10,
                  ),
                  TU.tuDFBM(context, 1.1),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: 'details & activity', icon: Icons.error, func: () {
                    Future.delayed(Duration(milliseconds: 10), () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailOfFile(
                                parentDocID: Provider.of<GetChanges>(context,
                                        listen: false)
                                    .pathList
                                    .last[0],
                                handlingFS: handlingFS,
                                dan: cFile.dan,
                              )));
                    });
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: cFile.star == false
                          ? 'add to star'
                          : 'remove from star',
                      icon: cFile.star == false
                          ? Icons.star_border
                          : Icons.star, func: () async {
                    handlingFS.makeStarAFile(
                        flag: !cFile.star,
                        parentDocID:
                            Provider.of<GetChanges>(context, listen: false)
                                .pathList
                                .last[0],
                        starId: await Utility.getStarDID(),
                        cFile: cFile);
                    callback(
                        msg: cFile.star == false
                            ? 'added to starred'
                            : 'removed from starred');
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context, label: 'share', icon: Icons.share_outlined,
                      func: () async {
                    Future.delayed(Duration(milliseconds: 10), () async {
                      if (await CIC.checkConnectivity(ctx)) {
                        Provider.of<GetChanges>(context, listen: false)
                            .updateLoadingIndicatorStatus(flag: true);
                        await FileOps().shareFile(ctx,
                            url: cFile.dLink, fileName: cFile.fileName);
                      }
                    });
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: 'download',
                      icon: Icons.download_outlined, func: () async {
                    Future.delayed(Duration(milliseconds: 10), () async {
                      if (await CIC.checkConnectivity(ctx)) {
                        var status = await Permission.storage.status;
                        if (!status.isGranted) {
                          await Permission.storage.request();
                        } else {
                          await FileOps().dftdDirectory(
                              url: cFile.dLink, fileName: cFile.fileName);
                          callback(msg: 'file downloaded');
                        }
                      }
                    });
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context,
                      label: 'rename',
                      icon: Icons.drive_file_rename_outline, func: () {
                    Timer(Duration(milliseconds: 10), () {
                      String parentDocID =
                          Provider.of<GetChanges>(context, listen: false)
                              .pathList
                              .last[0];
                      TextEditingController controller =
                          TextEditingController();
                      SB.sdb(context, () {
                        if (controller.text.trim().length > 0) {
                          handlingFS.renameFile(
                              parentDocID: parentDocID,
                              name: controller.text.trim(),
                              dan: cFile.dan);
                        } else {
                          callback(msg: 'not a valid name');
                        }
                      }, () {}, controller, dialog: 'Rename');
                    });
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  TU.tuDFBM(context, 1.1),
                  SizedBox(
                    height: 10,
                  ),
                  getRow(context, label: 'remove', icon: Icons.delete_outline,
                      func: () {
                    handlingFS.deleteFiles(
                        cFile: cFile,
                        parentDocID:
                            Provider.of<GetChanges>(context, listen: false)
                                .pathList
                                .last[0]);
                    Future.delayed(Duration(milliseconds: 10), () async {
                      callback(msg: 'file deleted');
                      await handlingFS.updateNFilesFI(n: 1, flag: false);
                      await handlingFS.manageSpace(
                          size: cFile.size, flag: false);
                    });
                    Navigator.of(context).pop();
                  }),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )));
          },
          context: ctx);

  static getRow(context,
          {required String label,
          required IconData icon,
          required Function func}) =>
      InkResponse(
        onTap: () => func(),
        child: Row(
          children: [
            IU.ditask(icon: icon, callback: () {}, size: 22),
            Expanded(
              child: RichText(
                text: TextSpan(text: label, style: TU.teeesmall(context, 60)),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            )
          ],
        ),
      );
}
