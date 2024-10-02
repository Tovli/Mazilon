import 'package:flutter/material.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:mazilon/util/Sync/syncData.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
//import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/userSyncFirebaseProvider.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:mazilon/depricated/Sync/QRCodeScanner.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/util/Sync/syncFunction.dart';
import 'package:mazilon/util/styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mazilon/pages/Sync/QRCodeScannerRealTime.dart';
import 'package:mazilon/util/Sync/dataEncryption.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/pages/SignIn_Pages/login.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:mazilon/util/Sync/dataCreation.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

bool testing = false;
//TODO: REMOVE BEFORE DEPLOYMENT

class syncDevicesRealTime extends StatefulWidget {
  final String gender;
  final PhonePageData phonePageData;
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;

  syncDevicesRealTime({
    super.key,
    required this.gender,
    required this.phonePageData,
    required this.collections,
    required this.collectionNames,
    required this.checkboxModels,
  });

  @override
  _syncDevicesState createState() => _syncDevicesState();
}

class _syncDevicesState extends State<syncDevicesRealTime> {
  final FirebaseFirestore dbUsers = FirebaseFirestore.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  var googleauthorized = '';
  var loading = false;
  var uploading = false;
  // TODO: this is a testing function?
  void fetchDataAndSyncRealTime(
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

  void setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      googleauthorized = prefs.getString('googleAccessToken') ?? '';
    });
  }

  @override
  initState() {
    setData();
    super.initState();
  }

  Future<String> getDriveAccess() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/drive.file', // Add Google Drive scope
      ],
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      prefs.setString('googleAccessToken', googleAuth.accessToken!);
      setState(() {
        googleauthorized = googleAuth.accessToken!;
      });
      return googleAuth.accessToken!;
    }
    // Save the access token for future use with Google Drive API

    return ""; // User cancelled the Google sign-in process
  }

  @override
  Widget build(BuildContext context) {
    var userInfoProvider = context.read<UserInformation>();
    var phonePageData = context.read<PhonePageData>();

    Future<http.Client> getAuthenticatedClient() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('googleAccessToken');
      final String? expirationTimeString =
          prefs.getString('googleAccessTokenExpiration');
      DateTime expirationTime = DateTime.parse(
          expirationTimeString ?? DateTime.now().toUtc().toString());
      print(expirationTime);
      print(DateTime.now().toUtc().toString());
      if (accessToken == null ||
          DateTime.now().toUtc().isAfter(expirationTime)) {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: [
            'email',
            'https://www.googleapis.com/auth/drive.file', // Add Google Drive scope
          ],
        );
        GoogleSignInAccount? googleUser =
            await googleSignIn.signInSilently(); // silent login
        if (googleUser == null) {
          googleUser = await googleSignIn.signIn();
          if (googleUser == null) {
            throw Exception('No access token found');
          }
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        accessToken = googleAuth.accessToken!;
        expirationTime = DateTime.now().add(Duration(hours: 1)).toUtc();
        prefs.setString('googleAccessToken', googleAuth.accessToken ?? '');
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('User silently signed in with Google.');
      }

      prefs.setString('googleAccessTokenExpiration', expirationTime.toString());
      final AuthClient client = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken('Bearer', accessToken, expirationTime),
          '', // No refresh token available
          ['https://www.googleapis.com/auth/drive.file'],
        ),
      );

      return client;
    }

    Future<void> uploadFileToGoogleDrive() async {
      try {
        setState(() {
          uploading = true;
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = await getData(userInfoProvider, phonePageData);
        var enc = jsonEncode(temp);
        var fileData = utf8.encode(enc);
        // Write the JSON string to a file

        final http.Client client = await getAuthenticatedClient();
        final drive.DriveApi driveApi = drive.DriveApi(client);

        final drive.File file = drive.File();
        DateTime now = DateTime.now();

        file.name = "MatzilonBackup-${now}".substring(0, 34) + ".txt";

        final drive.Media media =
            drive.Media(Stream.value(fileData), fileData.length);
        final drive.File result =
            await driveApi.files.create(file, uploadMedia: media);

        showToast(message: "data uploaded to drive");
      } catch (e) {
        print('An error occurred: $e');
        showToast(message: "An error occurred while trying to upload the data");
      } finally {
        setState(() {
          uploading = false;
        });
      }
    }

    Future<void> pickFileFromGoogleDrive(BuildContext context) async {
      try {
        // Get the authenticated client
        final http.Client client = await getAuthenticatedClient();
        final drive.DriveApi driveApi = drive.DriveApi(client);

        // List files from Google Drive
        final drive.FileList fileList = await driveApi.files.list();
        if (fileList.files == null || fileList.files!.isEmpty) {
          showToast(message: 'No Backups found');
          return;
        }
        List<drive.File> reversedFiles =
            fileList.files?.reversed.toList() ?? [];
        // Show a dialog to let the user pick a file
        String? selectedFileId = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            bool inLoad = false;
            int deleteIndex = -1;
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Select a file'),
                content: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: reversedFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      final drive.File file = reversedFiles[index];
                      return ListTile(
                        title: Text(file.name ?? 'Unnamed file'),
                        trailing: inLoad && deleteIndex == index
                            ? Container(
                                width: 45,
                                height: 45,
                                child: CircularProgressIndicator())
                            : IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  // Delete the file from Google Drive
                                  await driveApi.files.delete(file.id!);
                                  setState(() {
                                    inLoad = true;
                                    deleteIndex = index;
                                  });
                                  final updatedFiles =
                                      await driveApi.files.list();
                                  setState(() {
                                    reversedFiles =
                                        updatedFiles.files!.reversed.toList();
                                    inLoad = false;
                                    deleteIndex = -1;
                                  });
                                  showToast(
                                      message: "File deleted successfully");
                                },
                              ),
                        onTap: () {
                          Navigator.pop(context, file.id);
                        },
                      );
                    },
                  ),
                ),
              );
            });
          },
        );
        setState(() {
          loading = true;
        });
        if (selectedFileId != null) {
          // Download the selected file
          final drive.Media fileMedia = await driveApi.files.get(
            selectedFileId,
            downloadOptions: drive.DownloadOptions.fullMedia,
          ) as drive.Media;

          // Read the file content
          final List<int> dataBytes = [];
          fileMedia.stream.listen((data) {
            dataBytes.addAll(data);
          }, onDone: () async {
            // Convert the bytes to a string
            final String fileContent = utf8.decode(dataBytes);

            await syncData(fileContent, userInfoProvider, phonePageData);
            setState(() {
              loading = false;
            });
            showToast(message: "data synced successfully");
          }, onError: (error) {
            print('Error reading file: $error');
          });
        } else {
          print('No file selected');
        }
      } catch (e) {
        print('An error occurred: $e');
        showToast(message: "An error occurred while trying to sync the data");
      } finally {
        setState(() {
          loading = false;
        });
      }
    }

    FirebaseApp dbUsersApp =
        Provider.of<FirebaseAppProvider>(context, listen: false).dbUsersApp;
    //realtimeDB:
    // FirebaseDatabase database = FirebaseDatabase.instanceFor(app: dbUsersApp);
    // TODO: this is a testing function?
    void wrapperFetchDataAndSyncRealTime(Map<String, dynamic> data) {
      // Assuming `data['transactionId']` contains the JSON-encoded string
      String transactionIdJson = data['transactionId'];

      // Decode the JSON string to extract fields
      Map<String, dynamic> transactionIdData = jsonDecode(transactionIdJson);

      String uniqueId = transactionIdData['uniqueKey'];
      String encryptKeys = transactionIdData['encryptKey'];
      String encryptIvs = transactionIdData['encryptIv'];

      // If `testing` is a condition in your context, adjust `uniqueId` accordingly
      if (testing) uniqueId = "1";
      fetchDataAndSyncRealTime(
        uniqueId,
        encryptIvs,
        encryptKeys,
        userInfoProvider,
        phonePageData,
        dbUsersApp,
      );
    }

    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);

    if (userInfoProvider.userId == "") {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: SafeArea(
            child: Container(
              height: 130.0,
              child: Image.asset(
                'assets/images/Logo.png',
                width: MediaQuery.of(context).size.width * 0.8 > 1000
                    ? 500
                    : MediaQuery.of(context).size.width *
                        0.8, // Adjust as needed
                height: MediaQuery.of(context).size.height *
                    0.4, // Adjust as needed
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: myAutoSizedText(
                    appInfoProvider.syncPages['QRNoSigned'] ?? '',
                    const TextStyle(
                      fontSize: 20,
                    ),
                    TextAlign.center,
                    60.0),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  checkboxModels: widget.checkboxModels,
                                  collections: widget.collections,
                                  collectionNames: widget.collectionNames,
                                  phonePageData: widget.phonePageData,
                                  dbUsersApp: dbUsersApp,
                                )),
                        (Route<dynamic> route) => false);
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      appInfoProvider.syncPages['QRToSign'] ?? '',
                    ),
                  )),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: SafeArea(
          child: Container(
            height: 130.0,
            child: Image.asset(
              'assets/images/Logo.png',
              width: MediaQuery.of(context).size.width * 0.8 > 1000
                  ? 500
                  : MediaQuery.of(context).size.width * 0.8, // Adjust as needed
              height:
                  MediaQuery.of(context).size.height * 0.4, // Adjust as needed
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      appInfoProvider.syncPages['QRTitle'] ?? "",
                      const TextStyle(
                        fontSize: 30,
                      ),
                      TextAlign.center,
                      60.0),
                ),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      appInfoProvider.syncPages['QRScanDevice'] ?? '',
                      const TextStyle(
                        fontSize: 20,
                      ),
                      TextAlign.center,
                      60.0),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    // Show loading dialog

                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevents the dialog from closing before completion
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(appInfoProvider
                                          .syncPages['QRPreparing'] ??
                                      ''),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    // Call the async function and wait for the result
                    syncOtherDeviceRealtime(
                        userInfoProvider, phonePageData, dbUsersApp, context);
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: myAutoSizedText(
                        appInfoProvider.syncPages['QRSyncOther'] ?? '',
                        const TextStyle(
                          fontSize: 20,
                        ),
                        TextAlign.center,
                        60.0),
                  ),
                ),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      appInfoProvider.syncPages['QRSyncOtherText'] ?? '',
                      const TextStyle(
                        fontSize: 20,
                      ),
                      TextAlign.right,
                      60.0),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRScanPageRealTime(
                              dbUsersApp: dbUsersApp,
                              onScan: (message) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              })),
                    );
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: myAutoSizedText(
                        appInfoProvider.syncPages['QRSyncCurrent'] ?? '',
                        const TextStyle(
                          fontSize: 20,
                        ),
                        TextAlign.center,
                        60.0),
                  ),
                ),
                googleauthorized != ""
                    ? Column(
                        children: [
                          const SizedBox(height: 30),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: myAutoSizedText(
                                'סנכרון באמצעות google drive:',
                                const TextStyle(
                                  fontSize: 20,
                                ),
                                TextAlign.center,
                                60.0),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (!uploading) {
                                uploadFileToGoogleDrive();
                              }
                            },
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: uploading
                                    ? CircularProgressIndicator()
                                    : myAutoSizedText(
                                        'העלה של קובץ backup',
                                        const TextStyle(
                                          fontSize: 20,
                                        ),
                                        TextAlign.center,
                                        60.0)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              pickFileFromGoogleDrive(context);
                            },
                            child: myAutoSizedText(
                                'בחירת קובץ מהגוגל דרייב',
                                const TextStyle(
                                  fontSize: 20,
                                ),
                                TextAlign.center,
                                60.0),
                          ),
                          const SizedBox(height: 50),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                              getDriveAccess();
                            },
                            child: myAutoSizedText(
                                "אם ברצונכם להשתמש בדרייב אנא היכנסו עם גוגל",
                                const TextStyle(
                                  fontSize: 25,
                                ),
                                TextAlign.center,
                                40.0),
                          )
                        ],
                      )
              ],
            ),
          ),
          loading
              ? const Opacity(
                  opacity: 0.8, // Set opacity to 0.5 for a grayed-out effect
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                )
              : Container(),
          loading
              ? Center(
                  child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Column(
                        children: [
                          myAutoSizedText(
                              "טוען",
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                              ),
                              TextAlign.center,
                              40.0),
                          const SizedBox(
                            height: 80,
                            width: 80,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 255, 255, 255))),
                          ),
                        ],
                      )),
                )
              : Container(),
        ],
      ),
    );
  }
}
