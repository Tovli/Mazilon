import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/pages/SignIn_Pages/firstPage.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mazilon/pages/FeelGood/image_picker_service_impl.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/myDropdownMenuEntry.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettings extends StatefulWidget {
  final String username;
  final String age;
  final String gender;
  final Function updateData;
  final Map<String, String> titles;

  final Function changeLocale;
  PhonePageData phonePageData;

  UserSettings({
    super.key,
    required this.username,
    required this.age,
    required this.gender,
    required this.updateData,
    required this.titles,
    required this.phonePageData,
    required this.changeLocale,
  });
  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late ImagePickerService pickerService;
  String? dropdownValueAge = '18-30';
  TextEditingController _namecontroller = TextEditingController();
  bool firsttime = true;
  bool hasFilled = false;
  String? dropdownValueGender = '';
  String? name = '';
  List<String> ages = ['18-', '18-30', '30-40', '40-55', '55+'];
  List<String> genders = [];
  List<String> locales =
      AppLocalizations.supportedLocales.map((e) => e.languageCode).toList();
  Future<void> updateLocale(
      String locale, UserInformation userInfoProvider) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('localeName', locale);
    setState(() {
      widget.changeLocale(locale);
      userInfoProvider.updateLocaleName(locale);
    });
  }

  //remove log-in data and reset all data that user has filled in the app:
  Future<void> resetData(UserInformation userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    widget.phonePageData.reset();
    setState(() {
      firsttime = prefs.getBool('firstTime') ?? true;
      hasFilled = prefs.getBool('hasFilled') ?? false;
    });

    userInfo.reset();
    await pickerService.deleteImages();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => FirstPage(
                phonePageData: widget.phonePageData,
                firsttime: firsttime,
                changeLocale: widget.changeLocale,
                hasFilled: hasFilled)),
        (Route<dynamic> route) => false);
  }

  // save the changes the user made
  void savePage(age, gender, isNonBinary) {
    widget.updateData(_namecontroller.text, gender, age, isNonBinary);
    Navigator.pop(context);
  }

  // create the "what's your name?" title
  Column resizeText(text) {
    if (text == '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myAutoSizedText(
              text,
              TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
              AppLocalizations.of(context)!.textDirection == "rtl"
                  ? TextAlign.right
                  : TextAlign.left,
              24),
        ],
      );
    }
    List<String> sep = text.split("(");

    sep[1] = "(${sep[1]}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myAutoSizedText(
            sep[0],
            TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black),
            AppLocalizations.of(context)!.textDirection == "rtl"
                ? TextAlign.right
                : TextAlign.left,
            24),
        myAutoSizedText(
            sep[1],
            TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black),
            AppLocalizations.of(context)!.textDirection == "rtl"
                ? TextAlign.right
                : TextAlign.left,
            22),
      ],
    );
  }

  @override
  void initState() {
    dropdownValueAge = widget.age;

    super.initState();
    _namecontroller = TextEditingController(text: widget.username);
    pickerService = GetIt.instance<ImagePickerService>();
  }

  @override
  void dispose() {
    super.dispose();
    _namecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applocal = AppLocalizations.of(context);
    genders = [
      applocal!.male,
      applocal.female,
      applocal.nonBinary,
      applocal.notWillingToSay
    ];
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    dropdownValueGender = widget.gender == 'male'
        ? applocal.male
        : (widget.gender == 'female' ? applocal.female : '');
    final gender = userInfoProvider.gender;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          title: myAutoSizedText(
              AppLocalizations.of(context)!.userSettingsTitle(gender),
              TextStyle(fontSize: 20.sp),
              null,
              40),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                myAutoSizedText(
                    AppLocalizations.of(context)!.userSettingsTitle(gender),
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.sp,
                    ),
                    null,
                    60),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resizeText(
                      AppLocalizations.of(context)!.userSettingsName(gender),
                    ),
                    Container(
                      width: 300,
                      child: Container(
                        height: 35,
                        child: TextField(
                          controller: _namecontroller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                          ),
                          onChanged: (text) {
                            // Do something with the text
                            name = text;
                            userInfoProvider.updateName(text);
                          },
                        ),
                      ),
                    ),
                    myAutoSizedText(
                        AppLocalizations.of(context)!.userSettingsAge(gender),
                        TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        null,
                        30),
                    //AGE:
                    Container(
                      width: 300,
                      child: DropdownMenu<String>(
                        width: 300,
                        initialSelection: dropdownValueAge,
                        dropdownMenuEntries: [
                          ...ages
                              .map((age) => buildDropdownMenuEntry(
                                    age,
                                    dropdownValueAge == age
                                        ? const Color.fromARGB(255, 68, 0, 255)
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
                    myAutoSizedText(
                        AppLocalizations.of(context)!
                            .userSettingsGender(gender),
                        TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        null,
                        30),
                    //GENDER:
                    Container(
                      width: 300,
                      child: DropdownMenu<String>(
                        initialSelection: (userInfoProvider.binary)
                            ? applocal!.nonBinary
                            : (userInfoProvider.gender == 'male'
                                ? applocal.male
                                : userInfoProvider.gender == 'female'
                                    ? applocal.female
                                    : applocal.notWillingToSay),
                        width: 300,
                        dropdownMenuEntries: [
                          ...genders
                              .map((gender) => buildDropdownMenuEntry(
                                    gender,
                                    dropdownValueGender == gender
                                        ? const Color.fromARGB(255, 68, 0, 255)
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    myAutoSizedText(
                        AppLocalizations.of(context)!.selectLanguage(gender),
                        TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        null,
                        30),
                    Container(
                      width: 300,
                      child: DropdownMenu<String>(
                        initialSelection: locales[
                            locales.indexOf(userInfoProvider.localeName)],
                        width: 300,
                        dropdownMenuEntries: [
                          ...locales
                              .map((locale) => buildDropdownMenuEntry(
                                    locale,
                                    locale == 'en'
                                        ? const Color.fromARGB(255, 68, 0, 255)
                                        : Colors.black,
                                  ))
                              .toList()
                        ],
                        onSelected: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              updateLocale(newValue, userInfoProvider);
                            }
                          });
                          // Do something with the selected value
                        },
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
                      .updateBinary(dropdownValueGender! == applocal.nonBinary);
                  userInfoProvider.updateAge(dropdownValueAge!);

                  if (dropdownValueGender != null) {
                    if (dropdownValueGender == applocal.male) {
                      userInfoProvider.updateGender('male');
                      savePage(dropdownValueAge!, 'male', false);
                    } else if (dropdownValueGender == applocal.female) {
                      userInfoProvider.updateGender('female');
                      savePage(dropdownValueAge!, 'female', false);
                    } else if (dropdownValueGender == applocal.nonBinary) {
                      userInfoProvider.updateGender('');
                      savePage(dropdownValueAge!, '', false);
                    } else {
                      userInfoProvider.updateGender('');
                      savePage(dropdownValueAge!, '', true);
                    }
                  }

                  //savePage(dropdownValueAge!, dropdownValueGender!);
                }, AppLocalizations.of(context)!.confirmButton(gender),
                    myTextStyle.copyWith(fontSize: 20.sp)),
                const SizedBox(height: 20),
                CancelButton(context, () {
                  resetData(userInfoProvider);
                }, AppLocalizations.of(context)!.userSettingsReset(gender),
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
