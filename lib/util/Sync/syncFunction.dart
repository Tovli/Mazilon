// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mazilon/util/Sync/dataEncryption.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mazilon/pages/Sync/QRDisplayRealTime.dart';

import 'package:mazilon/util/Sync/dataCreation.dart';

bool testing = false;
//TODO: CHANGE TO FALSE BEFORE DEPLOYMENT

String checkUserAuthentication() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print('User is authenticated: ${user.uid}');
    return user.uid;
  } else {
    print('User is not authenticated.');
  }
  return '';
}

Future<void> syncOtherDeviceRealtime(
    UserInformation userInfoProvider,
    PhonePageData phonePageData,
    FirebaseApp dbUsersApp,
    BuildContext context) async {
  final rtdb = FirebaseDatabase.instanceFor(
          app: dbUsersApp,
          databaseURL:
              'https://mezilondb-default-rtdb.europe-west1.firebasedatabase.app/')
      .ref();

  var data = await getData(userInfoProvider, phonePageData);

  var encryptInfo = encrypting(jsonEncode(data));

  // Upload data to Realtime Database under a unique transaction ID
  final FirebaseAuth auth = FirebaseAuth.instanceFor(app: dbUsersApp);
  final User? user = auth.currentUser;

  var id = user!.uid;

  try {
    final newref = rtdb.child('/transactions/${id}').push();
    final uniqueKey = newref.key;

    newref.set({
      'data': encryptInfo["encryptedData"],
      'status': 'waiting', // Initial handshake status
    });
    //create the data for the qr
    String transactionId = jsonEncode({
      "uniqueKey":
          uniqueKey, // Unique key/id in the database for the transaction
      "encryptKey": encryptInfo["key"], // Encryption key
      'encryptIv': encryptInfo['iv'], // Encryption IV
    });

    // Close the loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    // Navigate to the DisplayQRPage with the result
    final transactionRef = rtdb.child('transactions/${id}/$uniqueKey');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayQRPageRealTime(
            transactionId: transactionId,
            callback: transactionRef,
          ),
        ));

//clean up function
    transactionRef.onValue.listen((event) {
      final snapshot = event.snapshot;

      if (snapshot.value == null) {
        return;
      }
      final snapshotData = Map<String, dynamic>.from(snapshot.value as Map);
      if (snapshotData['status'] != 'waiting') {
        // Perform your action once the condition is met
        Navigator.pop(context);

        snapshot.ref.remove().then((_) {
          print("Data deleted successfully.");
        }).catchError((error) {
          print("Failed to delete data: $error");
        });
      }
    });
  } catch (e) {
    print(e);
  }
}

void updateUserInfo(userInfoProvider, json) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('name', json['name'] as String? ?? "");
  prefs.setString('gender', json['gender'] as String);
  prefs.setBool('binary', json['binary'] as bool? ?? false);
  prefs.setString('age', json['age'] as String? ?? "");
  prefs.setBool('disclaimerSigned', json['disclaimerSigned'] as bool? ?? false);
  List<String> difficultEvents =
      List<String>.from(json['difficultEvents'] ?? [])
          .map((item) => item.toString())
          .toList();
  prefs.setStringList(
      'userSelectionPersonalPlan-DifficultEvents', difficultEvents);

  List<String> makeSafer = List<String>.from(json['makeSafer'] ?? [])
      .map((item) => item.toString())
      .toList();
  prefs.setStringList('userSelectionPersonalPlan-MakeSafer', makeSafer);
  List<String> feelBetter = List<String>.from(json['feelBetter'] ?? [])
      .map((item) => item.toString())
      .toList();
  prefs.setStringList('userSelectionPersonalPlan-FeelBetter', feelBetter);
  List<String> distractions = List<String>.from(json['distractions'] ?? [])
      .map((item) => item.toString())
      .toList();
  prefs.setStringList('userSelectionPersonalPlan-Distractions', distractions);
  userInfoProvider.updateGender(json['gender']);
  userInfoProvider.updateName(json['name']);
  userInfoProvider.updateAge(json['age']);
  userInfoProvider.updateBinary(json['binary']);
  userInfoProvider.updateDisclaimerSigned(json['disclaimerSigned']);
  userInfoProvider.updateDifficultEvents(difficultEvents);
  userInfoProvider.updateMakeSafer(makeSafer);
  userInfoProvider.updateFeelBetter(feelBetter);
  userInfoProvider.updateDistractions(distractions);
}
