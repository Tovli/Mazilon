import 'package:flutter/material.dart';

import 'package:mazilon/disclaimerPage.dart';
import 'package:mazilon/initialForm/form.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/pages/SignIn_Pages/login.dart';
import 'package:mazilon/menu.dart';
import 'package:firebase_core/firebase_core.dart';

// FirstPage widget determines the correct page
// to navigate to based on the user's status (e.g., disclaimer signed, logged in, first time using the app).
class FirstPage extends StatefulWidget {
  final List<List<String>> collections; // Data collections relevant to the user
  final List<String> collectionNames; // Names of the data collections
  final Map<String, CheckboxModel> checkboxModels; // Checkbox models for forms
  PhonePageData phonePageData; // Data related to phone page
  bool
      firsttime; // Flag indicating if this is the first time the user is using the app
  bool hasFilled; // Flag indicating if the user has filled out required forms

  FirstPage(
      {super.key,
      required this.collections,
      required this.collectionNames,
      required this.checkboxModels,
      required this.firsttime,
      required this.hasFilled,
      required this.phonePageData});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);

    // If the user has not signed the disclaimer, show the DisclaimerPage.
    if (!userInfoProvider.disclaimerSigned) {
      return const DisclaimerPage();
    }

    // If the user is not logged in, navigate to the LoginPage.
    //TODO: Should This be removed? or kept for when we want to enable it?
    /* if (false) {
      return LoginPage(
        collections: widget.collections,
        collectionNames: widget.collectionNames,
        checkboxModels: widget.checkboxModels,
        phonePageData: widget.phonePageData,
        dbUsersApp: widget.dbUsersApp,
      );
    }*/

    // If this is the user's first time using the app, show the initial form progress indicator.
    if (widget.firsttime) {
      return InitialFormProgressIndicator(
        collections: widget.collections,
        collectionNames: widget.collectionNames,
        checkboxModels: widget.checkboxModels,
        phonePageData: widget.phonePageData,
      );
    }

    // If none of the above, show the main menu of the app.
    return Menu(
      collections: widget.collections,
      collectionNames: widget.collectionNames,
      checkboxModels: widget.checkboxModels,
      phonePageData: widget.phonePageData,
      hasFilled: widget.hasFilled,
    );
  }
}
