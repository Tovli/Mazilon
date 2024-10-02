// ignore_for_file: annotate_overrides
import 'package:flutter/material.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/form/phonePageform.dart';
import 'package:mazilon/form/shareform.dart';
import 'package:mazilon/form/formpagetemplate.dart';
import 'package:mazilon/menu.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/styles.dart';
import 'package:provider/provider.dart';

import 'package:mazilon/util/userInformation.dart';

class FormProgressIndicator extends StatefulWidget {
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;
  PhonePageData phonePageData;

  FormProgressIndicator({
    super.key,
    required this.collections,
    required this.collectionNames,
    required this.checkboxModels,
    required this.phonePageData,
  });

  @override
  FormProgressIndicatorState createState() => FormProgressIndicatorState();
}

class FormProgressIndicatorState extends State<FormProgressIndicator> {
  int currentStep = 0;
  String name = '';

  void next() {
    setState(() {
      if (currentStep < steps.length - 1) currentStep++;
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

  void submitForm(mycontext) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (name.isNotEmpty) {
      prefs.setString('name', name);
    }
    navigateToMenu(mycontext);
  }

  void navigateToShare() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ShareForm(
          prev: prev,
          submit: submitForm,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void navigateToMenu(mycontext) {
    Navigator.pushAndRemoveUntil(
      mycontext,
      MaterialPageRoute(
        builder: (context) => Menu(
          collections: widget.collections,
          collectionNames: widget.collectionNames,
          checkboxModels: widget.checkboxModels,
          phonePageData: widget.phonePageData,
          hasFilled: true,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  List<Widget> steps = [];
  @override
  void initState() {
    super.initState();
    //initialize steps on form load:
    //if you want to add a page on the personal plan form, add it here:
    //use formpageTemplate.dart for checkbox pages with data from database below and selected items above.
    //create your own class for other pages.
    steps = [
      FormPageTemplate(
        key: UniqueKey(),
        next: next,
        prev: prev,
        collections: widget.collections,
        collectionNames: widget.collectionNames,
        model: widget.checkboxModels[widget.collectionNames[0]]!,
        collectionName: widget.collectionNames[0],
      ),
      FormPageTemplate(
        key: UniqueKey(),
        next: next,
        prev: prev,
        collections: widget.collections,
        collectionNames: widget.collectionNames,
        model: widget.checkboxModels[widget.collectionNames[1]]!,
        collectionName: widget.collectionNames[1],
      ),
      FormPageTemplate(
        key: UniqueKey(),
        next: next,
        prev: prev,
        collections: widget.collections,
        collectionNames: widget.collectionNames,
        model: widget.checkboxModels[widget.collectionNames[2]]!,
        collectionName: widget.collectionNames[2],
      ),
      FormPageTemplate(
        key: UniqueKey(),
        next: next,
        prev: prev,
        collections: widget.collections,
        collectionNames: widget.collectionNames,
        model: widget.checkboxModels[widget.collectionNames[3]]!,
        collectionName: widget.collectionNames[3],
      ),
      //<<<<<<<<<<<CHECKBOX PAGES END HERE
      //add contacts page:
      PhonePageForm(
        next: navigateToShare,
        prev: prev,
        collections: widget.collections,
        collectionNames: widget.collectionNames,
        phonePageData: widget.phonePageData,
      ),

      //ShareForm(prev: prev, submit: submitForm),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final AppInformation appInfoProvider =
        Provider.of<AppInformation>(context, listen: true);

    String skipText = appInfoProvider.formSkipButtonText[
            userInfoProvider.gender == ''
                ? 'general'
                : userInfoProvider.gender] ??
        'שמירה ויציאה';
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
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight,
                  color: lightGray,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Directionality(
                              textDirection: TextDirection.rtl,
                              child: myAutoSizedText(skipText,
                                  TextStyle(fontSize: 23.sp), null, 23),
                            ),
                            onPressed: () {
                              //clicked next button:
                              if (currentStep != (steps.length - 1)) {
                                widget.checkboxModels[
                                        widget.collectionNames[currentStep]]!
                                    .createSelection(userInfoProvider);
                              }
                              //clicked skip button:
                              navigateToMenu(context);
                            },
                          ),
                          if (currentStep > (0))
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                prev();
                              },
                            ),
                        ],
                      ),
                      // Bottom widget
                      // Progress indicator for the form:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          1 + widget.collectionNames.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 20.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: index <= currentStep
                                  ? primaryPurple
                                  : lightGray,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ).reversed.toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        //animation for switching between pages:
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
      ),
    );
  }
}
