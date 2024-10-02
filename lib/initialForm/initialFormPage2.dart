// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/Form/myDropdownMenuEntry.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

//second page of the initial form
//this is where the user selects their age,name and gender
class InitialFormPage2 extends StatefulWidget {
  final Function next;
  final Function prev;
  final Function updateName;

  final Map<String, String> titles;
  final Map<String, String> formTitles;

  const InitialFormPage2({
    super.key,
    required this.next,
    required this.prev,
    required this.updateName,
    required this.titles,
    required this.formTitles,
  });
  @override
  State<InitialFormPage2> createState() => _InitialFormPage2State();
}

class _InitialFormPage2State extends State<InitialFormPage2> {
  String? dropdownValueAge = '18-30';
  String? dropdownValueGender = '';
  String? name = '';
  List<String> ages = ['18-', '18-30', '30-40', '40-55', '55+'];
  List<String> genders = ['זכר', 'נקבה', 'לא בינארי', 'לא מעוניין להגיד'];

  void savePage(name, age, gender, appInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    age.isEmpty ? prefs.setString('age', '') : prefs.setString('age', age);
    name.isEmpty ? prefs.setString('name', '') : prefs.setString('name', name);

    gender.isEmpty
        ? prefs.setString('gender', '')
        : prefs.setString('gender', gender);

    widget.next();
  }

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
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInformation>(context);
    final appInfoProvider = Provider.of<AppInformation>(context);

    dropdownValueAge = userInfoProvider.age;
    //add genders here
    //requires CMS(rowy) support for the entire app if added:
    dropdownValueGender = (userInfoProvider.binary)
        ? 'לא בינארי'
        : (userInfoProvider.gender == 'male'
            ? 'זכר'
            : userInfoProvider.gender == 'female'
                ? 'נקבה'
                : 'לא מעוניין להגיד');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      widget.titles['mainTitle-${userInfoProvider.gender}'],
                      TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      null,
                      60),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: myAutoSizedText(
                        widget.titles['subTitle-${userInfoProvider.gender}'],
                        TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: darkGray),
                        TextAlign.center,
                        40),
                  ),
                ),
                SizedBox(
                  height: returnSizedBox(context, 25),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: resizeText(
                          widget.formTitles['name-' + userInfoProvider.gender]),
                    ),
                    Container(
                      width: 300,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          height: 35,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 6.0),
                            ),
                            onChanged: (text) {
                              // Do something with the text
                              name = text;
                            },
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          widget.formTitles['age-' + userInfoProvider.gender],
                          TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          null,
                          24),
                    ),
                    //ages drop down select:
                    Container(
                      width: 300,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownMenu<String>(
                          width: 300,
                          initialSelection: userInfoProvider.age,
                          dropdownMenuEntries: [
                            ...ages
                                .map((age) => buildDropdownMenuEntry(
                                      age,
                                      dropdownValueAge == age
                                          ? Color.fromARGB(255, 68, 0, 255)
                                          : Colors.black,
                                    ))
                                .toList()
                          ],
                          onSelected: (String? newValue) {
                            setState(() {
                              if (newValue != null) {
                                dropdownValueAge = newValue;
                                userInfoProvider.age = newValue;
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
                          widget
                              .formTitles['gender-' + userInfoProvider.gender],
                          TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          null,
                          24),
                    ),
                    //gender drop down select
                    Container(
                      width: 300,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownMenu<String>(
                          width: 300,
                          initialSelection: (userInfoProvider.binary)
                              ? 'לא בינארי'
                              : (userInfoProvider.gender == 'male'
                                  ? 'זכר'
                                  : userInfoProvider.gender == 'female'
                                      ? 'נקבה'
                                      : 'לא מעוניין להגיד'),
                          dropdownMenuEntries: [
                            ...genders
                                .map((gender) => buildDropdownMenuEntry(
                                      gender,
                                      dropdownValueGender == gender
                                          ? Color.fromARGB(255, 68, 0, 255)
                                          : Colors.black,
                                    ))
                                .toList()
                          ],
                          //update user info accordingly:
                          onSelected: (String? newValue) {
                            setState(() {
                              if (newValue != null) {
                                dropdownValueGender = newValue;
                                switch (newValue) {
                                  case 'זכר':
                                    userInfoProvider.updateGender('male');
                                    userInfoProvider.updateBinary(false);
                                    break;
                                  case 'נקבה':
                                    userInfoProvider.updateGender('female');
                                    userInfoProvider.updateBinary(false);
                                    break;
                                  case 'לא בינארי':
                                    userInfoProvider.updateGender('');
                                    userInfoProvider.updateBinary(true);
                                    break;

                                  default:
                                    userInfoProvider.updateGender('');
                                    userInfoProvider.updateBinary(false);
                                }
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
                  height: returnSizedBox(context, 100),
                ),
                ConfirmationButton(context, () {
                  FocusScope.of(context).unfocus();

                  userInfoProvider.updateAge(dropdownValueAge ?? '');
                  userInfoProvider.updateName(name!);
                  userInfoProvider
                      .updateBinary(dropdownValueGender == 'לא בינארי');
                  switch (dropdownValueGender!) {
                    case 'זכר':
                      userInfoProvider.updateGender('male');
                      savePage(
                          name, dropdownValueAge!, 'male', userInfoProvider);
                      break;
                    case 'נקבה':
                      userInfoProvider.updateGender('female');
                      savePage(
                          name, dropdownValueAge!, 'female', userInfoProvider);
                      break;
                    case 'לא בינארי':
                      userInfoProvider.updateGender('');
                      savePage(name, dropdownValueAge!, '', userInfoProvider);
                      break;
                    default:
                      userInfoProvider.updateGender('');
                      savePage(name, dropdownValueAge!, '', userInfoProvider);
                  }
                  //savePage(name, dropdownValueAge!, dropdownValueGender!);
                }, widget.titles['next-${userInfoProvider.gender}'],
                    myTextStyle.copyWith(fontSize: 20.sp)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
