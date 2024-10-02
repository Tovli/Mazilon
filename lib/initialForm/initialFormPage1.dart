// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

//The first page of the initial form
//all text is in the CMS and is fetched from there
class InitialFormPage1 extends StatefulWidget {
  final Function next;
  final Function skip;
  final Function prev;
  final Function updateName;
  final Map<String, String> titles;
  const InitialFormPage1({
    super.key,
    required this.next,
    required this.skip,
    required this.prev,
    required this.updateName,
    required this.titles,
  });
  @override
  State<InitialFormPage1> createState() => _InitialFormPage1State();
}

class _InitialFormPage1State extends State<InitialFormPage1> {
  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: myAutoSizedText(
                    widget.titles['mainTitle-' + userInfoProvider.gender],
                    TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    TextAlign.center,
                    60.0),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 5,
                    0,
                    MediaQuery.of(context).size.width / 5,
                    0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      widget.titles['subTitle1-' + userInfoProvider.gender],
                      TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: darkGray),
                      TextAlign.center,
                      35),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 6,
                    0,
                    MediaQuery.of(context).size.width / 6,
                    0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      widget.titles['subTitle2-' + userInfoProvider.gender],
                      TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: appGreen),
                      TextAlign.center,
                      35),
                ),
              ),
              SizedBox(
                height: returnSizedBox(context, 20),
              ),
              Image.asset(
                'assets/images/initialFormPage1.png',
                width: MediaQuery.sizeOf(context).width * 0.8 > 1000
                    ? 500
                    : MediaQuery.sizeOf(context).width *
                        0.8, // Adjust as needed
                height:
                    MediaQuery.sizeOf(context).height * 0.4, // Adjust as needed
              ),
              SizedBox(
                height: returnSizedBox(context, 50),
              ),
              ConfirmationButton(context, () {
                widget.next();
              },
                  widget.titles['next-' + userInfoProvider.gender],
                  myTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  )),
              SizedBox(
                height: returnSizedBox(context, 20),
              ),
              ConfirmationButton(context, () {
                widget.skip();
              },
                  widget.titles['skip-' + userInfoProvider.gender],
                  myTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
