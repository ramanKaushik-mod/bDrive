import 'dart:async';

import 'package:bdrive/utilityF/localUtility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class FirebaseFunctions {
  static verifyNumber(context, String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              await Utility.userSignedIn();
              await Utility.saveUserContact(userCon: phoneNumber);
              Timer(Duration(seconds: 3), () {
                Phoenix.rebirth(context);
              });
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
            } else {}
            // Handle other errors
          },
          codeSent: (String verificationId, int? resendToken) {
            Utility.saveUserContact(userCon: phoneNumber);
            Utility.setVFyId(vid: verificationId);
            Navigator.pushNamed(context, '/svp');
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      SB.ssb(context, text: '$e');
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
      // showBottomModal(context, dialogCode: "Loading...");
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser != null) {
        await Utility.saveUserContact(userCon: phoneNumber);
        await Utility.userSignedIn();
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
          FirebaseFirestore.instance.collection('Users'),
      chatCollection = FirebaseFirestore.instance.collection('Chats');
  HandlingFS({required this.contactID});

  DocumentReference getUserDoc() => _userCollection.doc(contactID);

  updateUserImage() async => await _userCollection
      .doc(this.contactID)
      .update({'imageStr': await Utility.getImageFromPreferences()});
}
