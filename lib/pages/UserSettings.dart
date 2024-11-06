import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/pages/SignIn_Pages/firstPage.dart';
import 'package:mazilon/pages/SignIn_Pages/login.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/myDropdownMenuEntry.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/userSyncFirebaseProvider.dart';
import 'package:firebase_core/firebase_core.dart';

class UserSettings extends StatefulWidget {
  final String username;
  final String age;
  final String gender;
  final Function updateData;
  final Map<String, String> titles;
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;
  PhonePageData phonePageData;

  UserSettings({
    super.key,
    required this.username,
    required this.age,
    required this.gender,
    required this.updateData,
    required this.titles,
    required this.collections,
    required this.collectionNames,
    required this.checkboxModels,
    required this.phonePageData,
  });
  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  String? dropdownValueAge = '18-30';
  TextEditingController _namecontroller = TextEditingController();
  bool firsttime = true;
  bool hasFilled = false;
  String? dropdownValueGender = '';
  String? name = '';
  List<String> ages = ['18-', '18-30', '30-40', '40-55', '55+'];
  List<String> genders = ['זכר', 'נקבה', 'לא בינארי', 'לא מעוניין להגיד'];

  //remove log-in data and reset all data that user has filled in the app:
  Future<void> resetData(UserInformation userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    widget.phonePageData.reset();
    setState(() {
      firsttime = prefs.getBool('firstTime') ?? true;
      hasFilled = prefs.getBool('hasFilled') ?? false;
    });
    widget.checkboxModels.forEach((key, value) {
      value.reset();
    });
    userInfo.reset();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => FirstPage(
                checkboxModels: widget.checkboxModels,
                collections: widget.collections,
                collectionNames: widget.collectionNames,
                phonePageData: widget.phonePageData,
                firsttime: firsttime,
                hasFilled: hasFilled)),
        (Route<dynamic> route) => false);
  }

  // save the changes the user made
  void savePage(age, gender) {
    widget.updateData(_namecontroller.text, gender, age);
    Navigator.pop(context);
  }

  // create the "what's your name?" title
  Column resizeText(text) {
    List<String> sep = text.split("(");

    sep[1] = "(${sep[1]}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: myAutoSizedText(
              sep[0],
              TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
              TextAlign.right,
              24),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: myAutoSizedText(
              sep[1],
              TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
              TextAlign.right,
              22),
        ),
      ],
    );
  }

  @override
  void initState() {
    dropdownValueAge = widget.age;
    dropdownValueGender = widget.gender == 'male'
        ? 'זכר'
        : (widget.gender == 'female' ? 'נקבה' : '');
    super.initState();
    _namecontroller = TextEditingController(text: widget.username);
  }

  @override
  void dispose() {
    super.dispose();
    _namecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: myAutoSizedText(
                widget.titles["header-" + userInfoProvider.gender],
                TextStyle(fontSize: 20.sp),
                null,
                40),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      widget.titles["Title-" + userInfoProvider.gender],
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.sp,
                      ),
                      null,
                      60),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: resizeText(
                            widget.titles["name-" + userInfoProvider.gender])),
                    Container(
                      width: 300,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          height: 35,
                          child: TextField(
                            controller: _namecontroller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 6.0),
                            ),
                            onChanged: (text) {
                              // Do something with the text
                              name = text;
                              userInfoProvider.updateName(text);
                            },
                          ),
                        ),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          widget.titles["age-" + userInfoProvider.gender],
                          TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          null,
                          30),
                    ),
                    //AGE:
                    Container(
                      width: 300,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownMenu<String>(
                          width: 300,
                          initialSelection: dropdownValueAge,
                          dropdownMenuEntries: [
                            ...ages
                                .map((age) => buildDropdownMenuEntry(
                                      age,
                                      dropdownValueAge == age
                                          ? const Color.fromARGB(
                                              255, 68, 0, 255)
                                          : Colors.black,
                                    ))
                                .toList()
                          ],
                          onSelected: (String? newValue) {
                            setState(() {
                              if (newValue != null) {
                                dropdownValueAge = newValue;
                              }
                            });
                            // Do something with the selected value
                          },
                        ),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          widget.titles["gender-" + userInfoProvider.gender],
                          TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          null,
                          30),
                    ),
                    //GENDER:
                    Container(
                      width: 300,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownMenu<String>(
                          initialSelection: userInfoProvider.binary
                              ? 'לא בינארי'
                              : userInfoProvider.gender == 'male'
                                  ? 'זכר'
                                  : userInfoProvider.gender == 'female'
                                      ? 'נקבה'
                                      : 'לא מעוניין להגיד'
                          //userInfoProvider.gender == 'nonbinary'
                          // ? 'לא בינארי'
                          // : 'לא מעוניין להגיד'
                          ,
                          width: 300,
                          dropdownMenuEntries: [
                            ...genders
                                .map((gender) => buildDropdownMenuEntry(
                                      gender,
                                      dropdownValueGender == gender
                                          ? const Color.fromARGB(
                                              255, 68, 0, 255)
                                          : Colors.black,
                                    ))
                                .toList()
                          ],
                          onSelected: (String? newValue) {
                            setState(() {
                              if (newValue != null) {
                                dropdownValueGender = newValue;
                              }
                            });
                            // Do something with the selected value
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                ConfirmationButton(context, () {
                  FocusScope.of(context).unfocus();

                  userInfoProvider.updateName(_namecontroller.text);
                  userInfoProvider
                      .updateBinary(dropdownValueGender! == 'לא בינארי');
                  userInfoProvider.updateAge(dropdownValueAge!);
                  switch (dropdownValueGender!) {
                    case 'זכר':
                      userInfoProvider.updateGender('male');
                      savePage(dropdownValueAge!, 'male');
                      break;
                    case 'נקבה':
                      userInfoProvider.updateGender('female');
                      savePage(dropdownValueAge!, 'female');
                      break;
                    case 'לא בינארי':
                      userInfoProvider.updateGender('');
                      savePage(dropdownValueAge!, '');
                      break;
                    default:
                      userInfoProvider.updateGender('');
                      savePage(dropdownValueAge!, '');
                  }
                  //savePage(dropdownValueAge!, dropdownValueGender!);
                }, widget.titles["Confirm-" + userInfoProvider.gender],
                    myTextStyle.copyWith(fontSize: 20.sp)),
                const SizedBox(height: 20),
                CancelButton(context, () {
                  resetData(userInfoProvider);
                }, widget.titles["Reset-" + userInfoProvider.gender],
                    myTextStyle.copyWith(fontSize: 20.sp)),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
