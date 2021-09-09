import 'dart:async';

import 'package:bdrive/models/models.dart';
import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

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
            await Utility.saveUserContact(userCon: phoneNumber);
            await Utility.setVFyId(vid: verificationId);
            SB.ssb(context, text: 'Code Sent Successfully');
            await Provider.of<GetChanges>(context, listen: false)
                .updateCodeSentSemaphore(flag: true);
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
        await Provider.of<GetChanges>(context, listen: false)
            .updateCodeSentSemaphore(flag: false);
        await Provider.of<GetChanges>(context, listen: false).turnTimeTo30();
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

  setUserDetails({required Users user}) async =>
      await getUserDoc().set(user.toJson());

  Future<Map<String, dynamic>> getUserDetails() async {
    return await getUserDoc().get().then((value) {
      if (value.exists) {
        return value.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    });
  }

  setSubSetInfo({required Map<String, dynamic> map}) async =>
      await getUserDoc().set(map);

  Future<bool> cue() async =>
      await getUserDoc().get().then((value) => value.exists ? true : false);
}
