import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/userSyncFirebaseProvider.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mazilon/depricated/Sync/QRCodeScanner.dart';
import 'package:mazilon/util/Sync/dataEncryption.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/util/Sync/syncFunction.dart';
import 'package:mazilon/util/styles.dart';
import 'package:firebase_database/firebase_database.dart';

bool testing = false;
//TODO: REMOVE BEFORE DEPLOYMENT

class syncDevices extends StatefulWidget {
  final String gender;
  PhonePageData phonePageData;

  syncDevices({super.key, required this.gender, required this.phonePageData});

  @override
  _syncDevicesState createState() => _syncDevicesState();
}

class _syncDevicesState extends State<syncDevices> {
  final FirebaseFirestore dbUsers = FirebaseFirestore.instance;

  void fetchDataAndSync(
    String uniqueKey,
    String encryptIv,
    String encryptKey,
    UserInformation userInfoProvider,
    PhonePageData phonePageData,
    FirebaseApp dbUsersApp,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore dbUsersFirestore =
        FirebaseFirestore.instanceFor(app: dbUsersApp);
    // Fetch data from dbUsers using uniqueKey
    // Use Provider or another state management solution to access userInfoProvider and phonePageData

    var doc =
        await dbUsersFirestore.collection('syncData').doc(uniqueKey).get();
    if (doc.exists) {
      // Check if the widget is still mounted before updating the UI
      if (!context.mounted) return;
      //print(doc.data()!['data']);

      var decryptedData =
          jsonDecode(decrypting(encryptKey, encryptIv, doc.data()!['data']));

      // Update local state with fetched data

      updateUserInfo(userInfoProvider, decryptedData['dataUser']);
      prefs.setStringList(
        'selectedItemsPersonalPlan-DifficultEvents',
        List<String>.from(Set.from(
                decryptedData['selectedItemsPersonalPlan-DifficultEvents'] ??
                    []))
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
                decryptedData['addedStringsPersonalPlan-DifficultEvents'] ??
                    []))
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
                decryptedData['userSelectionPersonalPlan-DifficultEvents'] ??
                    []))
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
                decryptedData['databaseItemsPersonalPlan-DifficultEvents'] ??
                    []))
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Synced Information Successfully")),
      );
    } else {
      // Check if the widget is still mounted before showing the snackbar
      if (!context.mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No such data in database")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var userInfoProvider = context.read<UserInformation>();
    var phonePageData = context.read<PhonePageData>();

    FirebaseApp dbUsersApp =
        Provider.of<FirebaseAppProvider>(context, listen: false).dbUsersApp;
    //realtimeDB:
    FirebaseDatabase database = FirebaseDatabase.instanceFor(app: dbUsersApp);
    void wrapperFetchDataAndSync(Map<String, dynamic> data) {
      String uniqueId = data['uniqueKey'];
      if (testing) uniqueId = "1";
      String encryptKeys = data['encryptKey'];
      String encryptIvs = data['encryptIv'];
      fetchDataAndSync(
        uniqueId,
        encryptIvs,
        encryptKeys,
        userInfoProvider,
        phonePageData,
        dbUsersApp,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: Container(
          color: Colors.white,
          height: 200.0,
          child: Image.asset(
            'assets/images/Logo.jpeg',
            width: MediaQuery.of(context).size.width * 0.8 > 1000
                ? 500
                : MediaQuery.of(context).size.width * 0.8, // Adjust as needed
            height:
                MediaQuery.of(context).size.height * 0.4, // Adjust as needed
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            myAutoSizedText(
                "סנכרון מכשירים",
                const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
                TextAlign.center,
                60.0),
            const SizedBox(height: 8),
            myAutoSizedText(
                "לסנכרון והעברת המידע מהמכשיר הנוכחי יש ללחוץ על הכפתור הבא ולסרוק במכשיר שאליו מעבירים את המידע",
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                TextAlign.center,
                60.0),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevents the dialog from closing before completion
                  builder: (BuildContext context) {
                    return const Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Text("מסכנרן..."),
                          ],
                        ),
                      ),
                    );
                  },
                );

                // Call the async function and wait for the result
                // syncOtherDevice(
                //  userInfoProvider, phonePageData, dbUsersApp, context);
              },
              child: myAutoSizedText(
                  "סנכרון מכשיר אחר",
                  const TextStyle(
                    fontSize: 20,
                  ),
                  TextAlign.center,
                  60.0),
            ),
            const SizedBox(height: 8),
            myAutoSizedText(
                "לסריקת הקוד במכשיר שאליו המידע מועבר:",
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                TextAlign.center,
                60.0),
            ElevatedButton(
              onPressed: () async {
                if (testing) {
                  wrapperFetchDataAndSync({
                    "uniqueKey": "1",
                    "encryptKey": "key",
                    "encryptIv": "iv"
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QRScanPage(onScan: wrapperFetchDataAndSync)),
                  );
                }

                /* if (scannedKey != null) {
                  fetchDataAndSync(scannedKey, userInfoProvider,
                      phonePageData, dbUsersApp);
                }*/
              },
              child: myAutoSizedText(
                  "סנכרון מכשיר נוכחי",
                  const TextStyle(
                    fontSize: 20,
                  ),
                  TextAlign.center,
                  60.0),
            ),
          ],
        ),
      ),
    );
  }
}
