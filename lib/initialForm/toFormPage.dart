import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/menu.dart';
import 'package:mazilon/form/form.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

//the page before the personal plan questionnaire that allows the user to fill the questionnaire or skip it.
class ToFormPage extends StatefulWidget {
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;
  final PhonePageData phonePageData;

  const ToFormPage(
      {Key? key,
      required this.collections,
      required this.collectionNames,
      required this.checkboxModels,
      required this.phonePageData})
      : super(key: key);

  @override
  State<ToFormPage> createState() => _ToFormPageState();
}

class _ToFormPageState extends State<ToFormPage> {
  bool hasFilled = false;
  void getHasFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      hasFilled = prefs.getBool('hasFilled') ?? false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHasFilled();
  }

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context);
    final userInfoProvider = Provider.of<UserInformation>(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: myAutoSizedText(
              appInfoProvider.introductionFormLastPage['mainTitle'],
              TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              TextAlign.center,
              60),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: myAutoSizedText(
                appInfoProvider.introductionFormLastPage[
                    'subTitle1-' + userInfoProvider.gender],
                TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: darkGray),
                TextAlign.center,
                35),
          ),
        ),
        SizedBox(
          height: returnSizedBox(context, 20),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: myAutoSizedText(
                appInfoProvider.introductionFormLastPage[
                    'subTitle2-' + userInfoProvider.gender],
                TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: appGreen),
                TextAlign.center,
                35),
          ),
        ),
        SizedBox(
          height: returnSizedBox(context, 20),
        ),
        myImage('assets/images/initialFormPage3.png', context, 0.8, 0.4),
        //navigate to personal plan form button:
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FormProgressIndicator(
                    collections: widget.collections,
                    collectionNames: widget.collectionNames,
                    checkboxModels: widget.checkboxModels,
                    phonePageData: widget.phonePageData,
                  ), //place collections here
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = Offset(-1.0, 0.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);
                    var offsetAnimation = animation.drive(tween);

                    var fadeTween = Tween(begin: 0.0, end: 1.0);
                    var fadeAnimation = animation.drive(fadeTween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            style: myButtonStyle,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: myAutoSizedText(
                  appInfoProvider.introductionFormLastPage[
                      'Next-' + userInfoProvider.gender],
                  myTextStyle.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20.sp),
                  null,
                  50),
            )),
        SizedBox(height: returnSizedBox(context, 15)),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Menu(
                        collections: widget.collections,
                        collectionNames: widget.collectionNames,
                        checkboxModels: widget.checkboxModels,
                        phonePageData: widget.phonePageData,
                        hasFilled: hasFilled)),
                (Route<dynamic> route) => false,
              );
            },
            style: myButtonStyle.copyWith(
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                    horizontal: returnSizedBox(context, 20),
                    vertical: returnSizedBox(context, 10)))),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: myAutoSizedText(
                  appInfoProvider.introductionFormLastPage[
                      'Skip-' + userInfoProvider.gender],
                  myTextStyle.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20.sp),
                  null,
                  50),
            ))
      ]),
    ));
  }
}
