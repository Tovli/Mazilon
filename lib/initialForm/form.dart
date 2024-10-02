import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/styles.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/initialForm/toFormPage.dart';
import 'package:mazilon/initialForm/initialFormPage2.dart';
import 'package:mazilon/initialForm/initialFormPage1.dart';
import 'package:mazilon/menu.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/disclaimerPage.dart';

class InitialFormProgressIndicator extends StatefulWidget {
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;
  PhonePageData phonePageData;

  InitialFormProgressIndicator({
    super.key,
    required this.collections,
    required this.collectionNames,
    required this.checkboxModels,
    required this.phonePageData,
  });

  @override
  InitialFormProgressIndicatorState createState() =>
      InitialFormProgressIndicatorState();
}

class InitialFormProgressIndicatorState
    extends State<InitialFormProgressIndicator> {
  int currentStep = 0;
  String name = '';
  bool disclaimerApproved = false;

  bool hasFilled = false;
  List<Widget> steps = [];
  void getHasFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      hasFilled = prefs.getBool('hasFilled') ?? false;
    });
  }

  void next() {
    setState(() {
      //currentStep = steps.length - 1;
      if (currentStep < steps.length - 1) currentStep++;
      //## this is the part that skips the initial form.##//
    });
  }

  void skip() {
    setState(() {
      currentStep = steps.length - 1;
      //if (currentStep < steps.length - 1) currentStep++;
      //## this is the part that skips the initial form.##//
    });
  }

  void prev() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
  }

  void updateName(name) {
    setState(() {
      this.name = name;
    });
  }

  void submitForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (name.isNotEmpty) {
      prefs.setString('name', name);
    }
    navigateToMenu();
  }

  void navigateToMenu() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Menu(
                collections: widget.collections,
                collectionNames: widget.collectionNames,
                checkboxModels: widget.checkboxModels,
                phonePageData: widget.phonePageData,
                hasFilled: hasFilled,
              )),
      (Route<dynamic> route) => false,
    );
  }

  //List<Widget> steps = [];
  @override
  void initState() {
    super.initState();
    getHasFilled();
  }

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    if (!userInfoProvider.disclaimerSigned) {
      return const DisclaimerPage();
    }
    steps = [
      //<<<<<<<<<<<INITIALFORM PAGES START HERE
      //IF YOU WANT TO ADD PAGES TO INITAL FORM DO IT HERE:
      InitialFormPage1(
          next: next,
          prev: prev,
          skip: skip,
          updateName: updateName,
          titles: appInfoProvider.introductionFormFirstPage),
      InitialFormPage2(
        next: next,
        prev: prev,
        updateName: updateName,
        titles: appInfoProvider.introductionFormSecondPage,
        formTitles: appInfoProvider.personalInformationForm,
      ),
      ToFormPage(
          collections: widget.collections,
          collectionNames: widget.collectionNames,
          checkboxModels: widget.checkboxModels,
          phonePageData: widget.phonePageData),

      //<<<<<<<<<<<PAGES END HERE
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (didpop) {
          return;
        } else {
          prev();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: lightGray,
            automaticallyImplyLeading: currentStep != (steps.length - 1),
            leading: currentStep != (steps.length - 1)
                ? IconButton(
                    icon: Directionality(
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          'דלג/י',
                          TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.sp),
                          null,
                          25),
                    ),
                    onPressed: () {
                      //## this is the part that skips BOTH forms from the initial screen.##//
                      next();
                    },
                  )
                : null,
            actions: [
              if (currentStep == (steps.length - 1))
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    prev();
                  },
                ),
            ],
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(
              milliseconds: 300), // Specify the duration of the animation
          transitionBuilder: (Widget child, Animation<double> animation) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end);

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: steps[currentStep],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //visual representation of the progress of the form:
            children: List.generate(
              steps.length, // Adjust the number of stages here
              //Animated Container for a non-instant color change, otherwise can be container
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 15.0,
                height: 15.0,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: index <= currentStep ? appGreen : lightGray,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ).reversed.toList(),
          ),
        ),
      ),
    );
  }
}
