import 'package:flutter/material.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
//import 'package:uuid/uuid.dart';

import 'package:mazilon/util/userInformation.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mazilon/util/Sync/dataEncryption.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/util/Sync/syncFunction.dart';
// import 'package:flutter/foundation.dart';

class QRScanPageRealTime extends StatefulWidget {
  final Function onScan;
  final FirebaseApp dbUsersApp;
  const QRScanPageRealTime(
      {Key? key, required this.onScan, required this.dbUsersApp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanPageRealTimeState();
}

class _QRScanPageRealTimeState extends State<QRScanPageRealTime> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    controller!.pauseCamera();

    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    /*
   DEBUG FUNCTION KEEP 
    void popContext(uniqueId) {
      widget.onScan(uniqueId);
      Navigator.pop(context);
    }*/
    Widget _buildQrView() {
      void _onQRViewCreated(QRViewController controller) {
        var phonePageData = context.read<PhonePageData>();
        var userInfoProvider = context.read<UserInformation>();
        bool hasScanned = false;
        controller.scannedDataStream.listen((scanData) async {
          if (hasScanned) {
            return; // If a QR code has been scanned, ignore further scans
          }
          hasScanned = true; // Set the flag to true to block further scans

          try {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.pop(context); // Safely close the scanner view
              }
            });
            final transactionId = jsonDecode(scanData
                .code!); // Assuming scanData.code contains the transaction ID
            // Step 3: Fetch transaction data from Realtime Database

            final transactionData = await fetchTransactionData(
                transactionId["uniqueKey"], userInfoProvider);

            if (transactionData != null &&
                transactionData['status'] == 'waiting') {
              // Update status or perform any necessary handshake confirmation

              await confirmHandshake(
                  transactionId["uniqueKey"], userInfoProvider);

              // Step 5: Sync data

              await syncData({
                "encryptedData": transactionData["data"],
                "key": transactionId["encryptKey"],
                "iv": transactionId["encryptIv"]
              }, userInfoProvider, phonePageData);

              widget.onScan("Scan successful: Data synced.");
            } else {
              widget.onScan("Scan failed: Transaction not ready.");
            }
          } catch (e) {
            widget.onScan("Scan failed: Error processing data.");
          }
        });
      }

      // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
      var scanArea = (MediaQuery.of(context).size.width < 400 ||
              MediaQuery.of(context).size.height < 400)
          ? 200.0
          : 350.0;
      // To ensure the Scanner view is properly sizes after rotation
      // we need to listen for Flutter SizeChanged notification and update controller
      return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    }

    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView()),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                          appInfoProvider.syncPages['QRScannerText'] ?? "")),
                  ElevatedButton(
                      onPressed: () => {
                            // testingFun("1721751507020-8666")

                            Navigator.pop(context)
                          },
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                            appInfoProvider.syncPages['QRScannerBack'] ?? ""),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void testingFun(transactionId, UserInformation userInfo) async {
    try {
      Navigator.pop(context);
      var phonePageData = context.read<PhonePageData>();
      var userInfoProvider = context.read<UserInformation>();
      final transactionData =
          await fetchTransactionData(transactionId, userInfo);

      if (transactionData != null && transactionData['status'] == 'waiting') {
        // Update status or perform any necessary handshake confirmation

        await confirmHandshake(transactionId, userInfoProvider);

        // Step 5: Sync data
        await syncData(transactionData, userInfoProvider, phonePageData);
        // Close the scanner view after syncing
        widget.onScan("Scan successful: Data synced.");
      } else {
        widget.onScan("Scan failed: Transaction not ready.");
      }
    } catch (e) {
      widget.onScan("Scan failed: Error processing data.");
    }
  }

// Fetch transaction data from the database
  Future<Map<String, dynamic>?> fetchTransactionData(
      String transactionId, UserInformation userInfo) async {
    // Initialize the database reference
    final databaseReference = FirebaseDatabase.instanceFor(
            app: widget.dbUsersApp,
            databaseURL:
                'https://mezilondb-default-rtdb.europe-west1.firebasedatabase.app/')
        .ref();

    // Create a path to the transaction data
    final transactionRef = databaseReference
        .child('transactions/${userInfo.userId}/$transactionId');

    // Fetch the transaction data
    final snapshot = await transactionRef.get();

    // Check if data exists
    if (snapshot.exists) {
      // Convert the snapshot to a Map and return it

      return Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      // Return null if the transaction does not exist
      return null;
    }
  }

  Future<void> confirmHandshake(
      String transactionId, UserInformation userInfo) async {
    // Initialize the database reference
    final databaseReference = FirebaseDatabase.instanceFor(
            app: widget.dbUsersApp,
            databaseURL:
                'https://mezilondb-default-rtdb.europe-west1.firebasedatabase.app/')
        .ref();

    // Path to the specific transaction

    final transactionRef = databaseReference
        .child('transactions/${userInfo.userId}/$transactionId');

    // Update the transaction status to 'confirmed'
    await transactionRef.update({
      'status': 'confirmed',
    });
  }

  Future<void> syncData(
      transactionData, userInfoProvider, phonePageData) async {
    // Decrypt the data
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final preDecryptedData = decrypting(
      transactionData['key'],
      transactionData['iv'],
      transactionData['encryptedData'],
    );

    // Convert the decrypted data to a Map
    final decryptedData = jsonDecode(preDecryptedData) as Map<String, dynamic>;
    updateUserInfo(userInfoProvider, decryptedData['dataUser']);
    prefs.setStringList(
      'selectedItemsPersonalPlan-DifficultEvents',
      List<String>.from(Set.from(
              decryptedData['selectedItemsPersonalPlan-DifficultEvents'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );

    prefs.setStringList(
      'selectedItemsPersonalPlan-MakeSafer',
      List<String>.from(Set.from(
              decryptedData['selectedItemsPersonalPlan-MakeSafer'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'selectedItemsPersonalPlan-FeelBetter',
      List<String>.from(Set.from(
              decryptedData['selectedItemsPersonalPlan-FeelBetter'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'selectedItemsPersonalPlan-Distractions',
      List<String>.from(Set.from(
              decryptedData['selectedItemsPersonalPlan-Distractions'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );

    prefs.setStringList(
      'addedStringsPersonalPlan-DifficultEvents',
      List<String>.from(Set.from(
              decryptedData['addedStringsPersonalPlan-DifficultEvents'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'addedStringsPersonalPlan-MakeSafer',
      List<String>.from(Set.from(
              decryptedData['addedStringsPersonalPlan-MakeSafer'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'addedStringsPersonalPlan-FeelBetter',
      List<String>.from(Set.from(
              decryptedData['addedStringsPersonalPlan-FeelBetter'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'addedStringsPersonalPlan-Distractions',
      List<String>.from(Set.from(
              decryptedData['addedStringsPersonalPlan-Distractions'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'userSelectionPersonalPlan-DifficultEvents',
      List<String>.from(Set.from(
              decryptedData['userSelectionPersonalPlan-DifficultEvents'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'userSelectionPersonalPlan-MakeSafer',
      List<String>.from(Set.from(
              decryptedData['userSelectionPersonalPlan-MakeSafer'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'userSelectionPersonalPlan-FeelBetter',
      List<String>.from(Set.from(
              decryptedData['userSelectionPersonalPlan-FeelBetter'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'userSelectionPersonalPlan-Distractions',
      List<String>.from(Set.from(
              decryptedData['userSelectionPersonalPlan-Distractions'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'databaseItemsPersonalPlan-DifficultEvents',
      List<String>.from(Set.from(
              decryptedData['databaseItemsPersonalPlan-DifficultEvents'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'databaseItemsPersonalPlan-MakeSafer',
      List<String>.from(Set.from(
              decryptedData['databaseItemsPersonalPlan-MakeSafer'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'databaseItemsPersonalPlan-FeelBetter',
      List<String>.from(Set.from(
              decryptedData['databaseItemsPersonalPlan-FeelBetter'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );
    prefs.setStringList(
      'databaseItemsPersonalPlan-Distractions',
      List<String>.from(Set.from(
              decryptedData['databaseItemsPersonalPlan-Distractions'] ?? []))
          .map((item) => item.toString())
          .toList(),
    );

    phonePageData
        .updateFromJson(decryptedData['dataPhones'] as Map<String, dynamic>);

    // Perform the data sync
    // Use Provider or another state management solution to access userInfoProvider and phonePageData
    // Use the data to update the local state
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
