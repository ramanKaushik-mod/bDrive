import 'dart:async';
import 'dart:io';

import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FirebaseFunctions {
  static verifyNumber(context, String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    phoneNumber = '+91$phoneNumber';
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              await Utility.userSignedIn();
              await Utility.saveUserContact(userCon: phoneNumber);
              await HandlingFS(contactID: phoneNumber)
                  .getUserDetails()
                  .then((value) async {
                if (value.isNotEmpty) {
                  await Utility.setUserDetails(map: value);
                }
              });
              await Provider.of<GetChanges>(context, listen: false)
                  .updateLoadingIndicatorStatus(flag: false);
              Phoenix.rebirth(context);
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              SB.ssb(context, text: 'Invalid phone number');
            } else {
              SB.ssb(context, text: 'Check your Internet Connection');
            }
            // Handle other errors
          },
          codeSent: (String verificationId, int? resendToken) async {
            SB.ssb(context, text: 'Code Sent Successfully');
            await Utility.saveUserContact(userCon: phoneNumber);
            await Utility.setVFyId(vid: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      SB.ssb(context, text: 'Check your Internect Connecton');
    }
  }

  static signInUser(
    context, {
    required String smsCode,
    required String phoneNumber,
    required String vefyId,
  }) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: vefyId, smsCode: smsCode);
      phoneNumber = '+91$phoneNumber';
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser != null) {
        await Utility.saveUserContact(userCon: phoneNumber);
        await Utility.userSignedIn();
        await HandlingFS(contactID: phoneNumber)
            .getUserDetails()
            .then((value) async {
          if (value.isNotEmpty) {
            await Utility.setUserDetails(map: value);
          }
        });
        GetChanges changes = Provider.of<GetChanges>(context, listen: false);

        await changes.updateCodeSentSemaphore(flag: false);
        await changes.turnTimeTo30();
        await changes.updateLoadingIndicatorStatus(flag: false);
        Phoenix.rebirth(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        SB.ssb(context, text: "invalid code");
      } else {
        SB.ssb(context, text: 'something went wrong');
      }
    }
  }

  static signOut() async {
    await FirebaseAuth.instance.signOut();
    await Utility.clearPreferences();
  }
}

class HandlingFS {
  final String contactID;

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Users');

  HandlingFS({required this.contactID});

  DocumentReference getUserDoc() => _userCollection.doc(contactID);

  CollectionReference getHomeCollection() => //Home collection
      _userCollection.doc(contactID).collection('Files');
  CollectionReference getStarCollection() =>
      _userCollection.doc(contactID).collection('starFiles');
  CollectionReference getRecentCollection() =>
      _userCollection.doc(contactID).collection('recentFiles');

  Future<DocumentReference> getHomeDoc() async =>
      getHomeCollection().doc(await Utility.getHomeUID());

  setUserDetails({required Users user}) async =>
      await getUserDoc().set(user.toJson());

  setUserHomeFolder({required Folder home}) async =>
      await getHomeCollection().doc(home.docUid).set(home.toJson());

  Future<Map<String, dynamic>> getUserDetails() async {
    return await getUserDoc().get().then((value) {
      if (value.exists) {
        return value.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    });
  }

  updatteSubSetInfo({required Map<String, dynamic> map}) async =>
      await getUserDoc().update(map);

  Future<bool> cue() async => //checks user exist or not
      await getUserDoc().get().then((value) => value.exists ? true : false);

  Future<bool> crle({required String docId}) async => await getUserDoc()
      .collection('recentFiles')
      .doc(docId)
      .get()
      .then((value) => value.exists ? true : false);
  Future<bool> csle({required String docId}) async => await getUserDoc()
      .collection('starFiles')
      .doc(docId)
      .get()
      .then((value) => value.exists ? true : false);

  Future<bool> csels({required String docId}) async => await getHomeCollection()
      .doc(docId)
      .get()
      .then((value) => value.exists ? true : false);

  takeCareOfStarDoc({required String docId}) async => await getStarCollection()
      .doc(docId)
      .set({'fileList': [], 'folderList': []});

  takeCareOfRecentDoc({required String docId}) async =>
      await getRecentCollection().doc(docId).set({'fileList': []});

  takeCareOfSearchDoc({required String docId}) async =>
      await getHomeCollection().doc(docId).set({'fileList': []});

  //******************Uploading the file ******************** */

  UploadTask? uploadFile({required String destination, required File file}) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      if (e.code == 'canceled') {
        print('The task has been canceled 0000');
      }
      print('The task has been canceled');
    }
  }

  addFolderToFolderList(
      {required Folder folder, required String parentDocUid}) async {
    Map<String, dynamic> sfd = ShortFD.fromJson(map: folder.toJson()).toJson();
    await getHomeCollection().doc(parentDocUid).update({
      'folderList': FieldValue.arrayUnion([sfd])
    });
    await getHomeCollection()
        .doc(folder.docUid)
        .set(folder.toJson())
        .then((value) async {
      await updateNFoldersFo(n: 1, flag: true);
    });
  }

  addFileToFileList(context,
          {required CFile file,
          required String parentDocUid,
          required String recentId,
          required Function func}) async =>
      await getHomeCollection().doc(parentDocUid).update({
        'fileList': FieldValue.arrayUnion([file.toJson()])
      }).then((value) async {
        await func();

        await manageSpace(size: file.size, flag: true);
        await syncSearchList(context, docId: await Utility.getSearchDID());
        if (await crle(docId: recentId)) {
          await getRecentCollection().doc(recentId).update({
            'fileList': FieldValue.arrayUnion([file.toJson()])
          });
        } else {
          await getRecentCollection().doc(recentId).set({
            'fileList': [file.toJson()]
          });
        }
        await getHomeCollection().doc(await Utility.getSearchDID()).update({
          'fileList': FieldValue.arrayUnion(
              [SFile.fromJson(map: file.toJson()).toJson()])
        });
      });

  updateNFilesFI({required int n, required bool flag}) async {
    await getUserDoc().get().then((value) async {
      Map<String, dynamic> map = value.data() as Map<String, dynamic>;
      if (flag) {
        await getUserDoc().update({'nFiles': map['nFiles'] + n});
        await Utility.setNFiles(nf: map['nFiles'] + n);
      } else {
        await getUserDoc().update({'nFiles': map['nFiles'] - n});
        await Utility.setNFiles(nf: map['nFiles'] - n);
      }
    });
  }

  updateNFoldersFo({required int n, required bool flag}) async {
    await getUserDoc().get().then((value) async {
      Map<String, dynamic> map = value.data() as Map<String, dynamic>;
      if (flag) {
        await getUserDoc().update({'nFolders': map['nFolders'] + n});
        await Utility.setNFolders(nf: map['nFolders'] + n);
      } else {
        await getUserDoc().update({'nFolders': map['nFolders'] - n});
        await Utility.setNFolders(nf: map['nFolders'] - n);
      }
    });
  }

  Future<List<String>> getFolderList({required String parentDocID}) async =>
      await getHomeCollection().doc(parentDocID).get().then((value) async {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        List<String> docs = [];
        if (map['star'] == true) {
          await dffStarDoc(starfolder: ShortFD.fromJson(map: map).toJson());
        }
        map['folderList'].forEach((element) async {
          docs.add(element['docUid']);
        });
        if (docs.length > 0) {
          await updateNFoldersFo(n: docs.length, flag: false);
        }
        return docs;
      });

  Future<List<String>> getFileList({required String parentDocID}) async =>
      await getHomeCollection().doc(parentDocID).get().then((value) async {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        double space = 0.0;
        List<String> docs = [];
        List<Map<String, dynamic>> sFiles = [];
        List<String> freshNames = [];
        map['fileList'].forEach((element) {
          Map<String, dynamic> tempMap = element as Map<String, dynamic>;
          docs.add(tempMap['oldName']);
          freshNames.add(tempMap['fileName']);
          space += tempMap['size'];
          sFiles.add(SFile.fromJson(map: tempMap).toJson());
        });

        if (docs.length > 0) {
          await updateNFilesFI(n: docs.length, flag: false);
          await manageSpace(size: space, flag: false);
          await dffSd(list: sFiles);
        }
        if (freshNames.length > 0) {
          String recentId = await Utility.getRecentDID();
          String starId = await Utility.getStarDID();
          freshNames.forEach((element) async {
            await deleteFileFromRecentDoc(element: element, recentId: recentId);
            await deleteFileFromStarDoc(starId: starId, element: element);
          });
        }
        return docs;
      });

  //dffSd -> delete file from Search doc
  dffSd({required List<Map<String, dynamic>> list}) async =>
      await getHomeCollection()
          .doc(await Utility.getSearchDID())
          .update({'fileList': FieldValue.arrayRemove(list)});

  dffStarDoc({required Map<String, dynamic> starfolder}) async =>
      await getStarCollection().doc(await Utility.getStarDID()).update({
        'folderList': FieldValue.arrayRemove([starfolder])
      });

  //******************  STREAMS ******************* */

  Stream<DocumentSnapshot> getFilesAndFoldersStream({required String path}) =>
      getHomeCollection().doc(path).snapshots();

  Stream<DocumentSnapshot> getRecentDocAsStream({required String docId}) =>
      getRecentCollection().doc(docId).snapshots();

  Stream<DocumentSnapshot> getStarDocAsStream({required String docId}) =>
      getStarCollection().doc(docId).snapshots();

  Stream<DocumentSnapshot> getSearchDocAsStream({required String docId}) =>
      getHomeCollection().doc(docId).snapshots();

  //***************** DModals ************ */

  deleteFolder({required String parentDocID, required ShortFD fd}) async {
    getHomeCollection().doc(parentDocID).update({
      'folderList': FieldValue.arrayRemove([fd.toJson()])
    });
    parentDocID = fd.docUid;
    await updateNFoldersFo(n: 1, flag: false);
    await traverseAndDelete(parentDocID: parentDocID);
  }

  traverseAndDelete({required String parentDocID}) async {
    List<String> list = await getFolderList(parentDocID: parentDocID);
    //delete the files before preceding in the current folder
    List<String> fileList = await getFileList(parentDocID: parentDocID);
    if (fileList.length > 0) {
      await deleteFilesWithinFolders(fileList: fileList);
    }
    //than delete the document itself
    await getHomeCollection().doc(parentDocID).delete();
    list.forEach((element) async {
      await traverseAndDelete(parentDocID: element);
    });
  }

  deleteFilesWithinFolders({required List<String> fileList}) async {
    fileList.forEach((element) async {
      await FirebaseStorage.instance
          .ref('/files/${this.contactID}/$element')
          .delete();
    });
  }

  deleteFiles({required String parentDocID, required CFile cFile}) async =>
      await getHomeCollection().doc(parentDocID).update({
        'fileList': FieldValue.arrayRemove([cFile.toJson()])
      }).whenComplete(() async {
        await getHomeCollection().doc(await Utility.getSearchDID()).update({
          'fileList': FieldValue.arrayRemove(
              [SFile.fromJson(map: cFile.toJson()).toJson()])
        });
        await deleteFileFromRecentDoc(
            recentId: await Utility.getRecentDID(), element: cFile.fileName);
        if (cFile.star == true) {
          await getStarCollection().doc(await Utility.getStarDID()).update({
            'fileList': FieldValue.arrayRemove([cFile.toJson()])
          });
        }
        await FirebaseStorage.instance
            .ref('/files/${this.contactID}/${cFile.oldName}')
            .delete();
      });

  deleteFileFromRecentDoc(
          {required String recentId, required String element}) async =>
      await getRecentCollection().doc(recentId).get().then((value) {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        map['fileList'].forEach((file) async {
          Map<String, dynamic> tempMap = file as Map<String, dynamic>;
          if (tempMap['fileName'] == element) {
            await getRecentCollection().doc(recentId).update({
              'fileList': FieldValue.arrayRemove([tempMap])
            });
          }
        });
      });

  deleteFileFromStarDoc(
          {required String starId, required String element}) async =>
      await getStarCollection().doc(starId).get().then((value) {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        map['fileList'].forEach((file) async {
          Map<String, dynamic> tempMap = file as Map<String, dynamic>;
          if (tempMap['fileName'] == element) {
            await getStarCollection().doc(starId).update({
              'fileList': FieldValue.arrayRemove([tempMap])
            });
            return;
          }
        });
      });

  makeStar(
      {required String parentDocId,
      required ShortFD sfd,
      required String starId,
      required bool flag}) async {
    await getHomeCollection().doc(parentDocId).get().then((value) async {
      Map<String, dynamic> map = value.data() as Map<String, dynamic>;
      map['folderList'].forEach((element) {
        Map<String, dynamic> tempMap = element as Map<String, dynamic>;
        if ("${tempMap['docUid']}" == sfd.docUid) {
          element['star'] = flag;
        }
      });

      await getHomeCollection()
          .doc(parentDocId)
          .update({'folderList': map['folderList']});
      await getHomeCollection().doc(sfd.docUid).update({'star': flag});
    }).then((value) async {
      Map<String, dynamic> map = sfd.toJson();
      map['star'] = flag;
      if (await csle(docId: starId)) {
        if (flag == true) {
          getStarCollection().doc(starId).update({
            'folderList': FieldValue.arrayUnion([map])
          });
        } else {
          getStarCollection().doc(starId).update({
            'folderList': FieldValue.arrayRemove([sfd.toJson()])
          });
        }
      } else {
        map['star'] = flag;
        getStarCollection().doc(starId).set({
          'folderList': [map]
        });
      }
    });
  }

  makeStarAFile(
          {required String parentDocID,
          required CFile cFile,
          required String starId,
          required bool flag}) async =>
      await getHomeCollection().doc(parentDocID).get().then((value) async {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        map['fileList'].forEach((element) {
          Map<String, dynamic> tempMap = element as Map<String, dynamic>;
          if ("${tempMap['dan']}" == cFile.dan) {
            element['star'] = flag;
          }
        });

        await getHomeCollection()
            .doc(parentDocID)
            .update({'fileList': map['fileList']});
      }).then((value) async {
        Map<String, dynamic> map = cFile.toJson();
        map['star'] = flag;
        if (await csle(docId: starId)) {
          if (flag == true) {
            getStarCollection().doc(starId).update({
              'fileList': FieldValue.arrayUnion([map])
            });
          } else {
            getStarCollection().doc(starId).update({
              'fileList': FieldValue.arrayRemove([cFile.toJson()])
            });
          }
        } else {
          map['star'] = flag;
          getStarCollection().doc(starId).set({
            'fileList': [map]
          });
        }
      });

  renameFolder(
          {required String parentDocID,
          required ShortFD sfd,
          required String name}) async =>
      getHomeCollection().doc(parentDocID).get().then((value) async {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        map['folderList'].forEach((element) {
          Map<String, dynamic> tempMap = element as Map<String, dynamic>;
          if ("${tempMap['docUid']}" == sfd.docUid) {
            element['fName'] = name;
          }
        });

        await getHomeCollection()
            .doc(parentDocID)
            .update({'folderList': map['folderList']});
        await getHomeCollection().doc(sfd.docUid).update({'fName': name});
      }).then((value) async {
        await getStarCollection()
            .doc(await Utility.getStarDID())
            .get()
            .then((value) async {
          Map<String, dynamic> map = value.data() as Map<String, dynamic>;
          map['folderList'].forEach((element) {
            Map<String, dynamic> tempMap = element as Map<String, dynamic>;
            if ("${tempMap['docUid']}" == sfd.docUid) {
              element['fName'] = name;
            }
          });
          await getStarCollection()
              .doc(await Utility.getStarDID())
              .update({'folderList': map['folderList']});
        });
      });

  renameFile(
          {required String parentDocID,
          required String dan,
          required String name}) async =>
      getHomeCollection().doc(parentDocID).get().then((value) async {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        map['fileList'].forEach((element) async {
          Map<String, dynamic> tempMap = element as Map<String, dynamic>;
          if ("${tempMap['dan']}" == dan) {
            List<String> list = tempMap['fileName'].split('.');
            String oldName = tempMap['fileName'],
                newName = '$name.${list.last}';
            element['fileName'] = newName;
            await renameInSearchDoc(oldName: oldName, newName: newName);
          }
        });

        await getHomeCollection()
            .doc(parentDocID)
            .update({'fileList': map['fileList']});
      }).then((value) async {
        await getRecentCollection()
            .doc(await Utility.getRecentDID())
            .get()
            .then((value) async {
          Map<String, dynamic> map = value.data() as Map<String, dynamic>;
          map['fileList'].forEach((element) {
            Map<String, dynamic> tempMap = element as Map<String, dynamic>;
            if ("${tempMap['dan']}" == dan) {
              List<String> list = tempMap['fileName'].split('.');
              element['fileName'] = '$name.${list.last}';
            }
          });
          await getRecentCollection()
              .doc(await Utility.getRecentDID())
              .update({'fileList': map['fileList']});
        });

        await getStarCollection()
            .doc(await Utility.getStarDID())
            .get()
            .then((value) async {
          Map<String, dynamic> map = value.data() as Map<String, dynamic>;
          map['fileList'].forEach((element) {
            Map<String, dynamic> tempMap = element as Map<String, dynamic>;
            if ("${tempMap['dan']}" == dan) {
              List<String> list = tempMap['fileName'].split('.');
              element['fileName'] = '$name.${list.last}';
            }
          });
          await getStarCollection()
              .doc(await Utility.getStarDID())
              .update({'fileList': map['fileList']});
        });
      });

  renameInSearchDoc({required String oldName, required String newName}) async =>
      await getHomeCollection()
          .doc(await Utility.getSearchDID())
          .get()
          .then((value) async {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        map['fileList'].forEach((element) {
          Map<String, dynamic> tempMap = element as Map<String, dynamic>;
          if ('${tempMap['fileName']}' == oldName) {
            element['fileName'] = newName;
          }
        });
        await getHomeCollection()
            .doc(await Utility.getSearchDID())
            .update({'fileList': map['fileList']});
      });

  Future<Map<String, dynamic>> getFolderDetails({required docID}) async =>
      await getHomeCollection()
          .doc(docID)
          .get()
          .then((value) => value.data() as Map<String, dynamic>);

  Future<Map<String, dynamic>> getFileDetails(
          {required String parentDocID, required String dan}) async =>
      await getHomeCollection().doc(parentDocID).get().then((value) {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        map['fileList'].forEach((element) {
          Map<String, dynamic> tempMap = element as Map<String, dynamic>;
          if ('${tempMap['dan']}' == dan) {
            map = tempMap;
          }
        });
        return map;
      });

  removeFileFromRecent(
          {required String recentId, required CFile cFile}) async =>
      getRecentCollection().doc(recentId).update({
        'fileList': FieldValue.arrayRemove([cFile.toJson()])
      });

  checkConcurrencyOfFile({required String destination}) async {
    final list = await FirebaseStorage.instance
        .ref('files/${await Utility.getUserContact()}/')
        .listAll();
    final list1 = list.items;
    bool check = false;
    list1.forEach((element) {
      if (element.fullPath == destination) {
        check = true;
        return;
      }
    });
    return check;
  }

  manageSpace({required double size, required bool flag}) async {
    await getUserDoc().get().then((value) async {
      Map<String, dynamic> map = value.data() as Map<String, dynamic>;
      if (flag) {
        await getUserDoc().update({'space': map['space'] + size});
        await Utility.setSpace(space: map['space'] + size);
      } else {
        await getUserDoc().update({'space': map['space'] - size});
        await Utility.setSpace(space: map['space'] - size);
      }
    });
  }

  syncSearchList(context, {required String docId}) async =>
      await getHomeCollection().doc(docId).get().then((value) async {
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        List<SFile> list = [];
        map['fileList'].forEach((element) {
          Map<String, dynamic> tempMap = element as Map<String, dynamic>;
          list.add(SFile.fromJson(map: tempMap));
        });
        await Provider.of<GetChanges>(context, listen: false)
            .updateSList(list: list);
      });
  //*****************
  //
  //
  //
  //
  //
  //
  //
  //***** TESTING PURPOSE *****
  //
  //
  //
  //
  //
  //
  //
  //**************** */

  writePath() async => print(
      ' ********************  Use the path :::: {${getHomeCollection().doc(await Utility.getHomeUID()).path}}');
}

class FileOps {
  //*******download and show file methods*********
  //
  //

  openFile(context, {required String url, required String fileName}) async {
    final file = await dFile(context, fileName: fileName, url: url);
    if (file == null) return;
    Provider.of<GetChanges>(context, listen: false)
        .updateLoadingIndicatorStatus(flag: false);
    await OpenFile.open(file.path);
  }

  dFile(context, {required String url, required String fileName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$fileName');
    if (await file.exists()) {
      return file;
    }

    if (!await CIC.checkConnectivity(context)) {
      return null;
    }
    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));

      final wtf = file.openSync(mode: FileMode.write);
      wtf.writeFromSync(response.data);
      await wtf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  //
  /*****************{download and show file} methods******* */

  /// ************{download} methods********** */
  /// dftdDirectory => download file to download directory

  dftdDirectory({required String url, required String fileName}) async {
    File file = File('/storage/emulated/0/Download/$fileName');

    Directory dir = Directory('/storage/emulated/0/Download/');
    if (await dir.exists()) {}
    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));
      final wtf = file.openSync(mode: FileMode.write);
      wtf.writeFromSync(response.data);
      await wtf.close();
    } catch (e) {
      print(e);
    }
  }

  /// ************{share} methods********** */

  shareFile(context, {required String url, required String fileName}) async {
    final file = await dFile(context, fileName: fileName, url: url);
    if (file == null) return;
    Provider.of<GetChanges>(context, listen: false)
        .updateLoadingIndicatorStatus(flag: false);
    await Share.shareFiles([file.path]);
  }

  /// ************{making files available offline} methods********** */
  mAO({required String url, required String fileName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$fileName');
    if (await file.exists()) {
      return;
    }

    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));

      final wtf = file.openSync(mode: FileMode.write);
      wtf.writeFromSync(response.data);
      await wtf.close();
    } catch (e) {
      return null;
    }
  }
}
