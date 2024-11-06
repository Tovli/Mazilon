import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import 'package:mazilon/pages/SignIn_Pages/login.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/logger_service.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Firebase/firebase_functions.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/SignIn/form_container.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:mazilon/util/SignIn/sign_callback.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

// SignUpPage is a stateful widget that handles user registration, allowing new users to create an account.
class SignUpPage extends StatefulWidget {
  final List<List<String>> collections; // Data collections for the form
  final List<String> collectionNames; // Names of the data collections
  final Map<String, CheckboxModel>
      checkboxModels; // Checkbox models used in the form
  PhonePageData phonePageData; // Data related to phone page
  FirebaseApp dbUsersApp; // FirebaseApp instance

  SignUpPage(
      {super.key,
      required this.collections,
      required this.collectionNames,
      required this.checkboxModels,
      required this.dbUsersApp,
      required this.phonePageData});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late FirebaseAuthService _auth; // Auth service for Firebase operations

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize FirebaseAuthService with the specific FirebaseApp instance
    _auth = FirebaseAuthService(widget.dbUsersApp);
  }

  bool isSigningUp = false; // Tracks the signing-up process

  // Validates the input fields and initiates the sign-up process
  void validateText(List<String> texts, UserInformation userInfo) {
    if (texts.any((text) => text.isEmpty)) {
      showToast(message: "Please fill in all the fields");
      return;
    }
    signUp(
      userInfo,
      texts[0],
      texts[1],
    ).then((result) => {callback(result, widget, context)});
  }

  // Handles the sign-up process using email and password
  Future<bool> signUp(UserInformation userInfo, email, password) async {
    setState(() {
      isSigningUp = true;
    });

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isSigningUp = false;
      });

      if (user != null) {
        showToast(message: "User is successfully created");
        userInfo.updateUserId(user!.uid);
        prefs.setString('userId', user.uid);
        userInfo.updateLoggedIn(true);
        prefs.setBool('loggedIn', true);
        return true;
      } else {
        showToast(message: "Some error happened");
        return false;
      }
    } catch (error, stackTrace) {
      IncidentLoggerService loggerService =
          GetIt.instance<IncidentLoggerService>();
      await loggerService.captureException(
        error,
        stackTrace: stackTrace,
      );

      setState(() {
        isSigningUp = false;
      });

      showToast(
          message:
              "Error during sign up. Please check your input and try again.");
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                collections: widget.collections,
                collectionNames: widget.collectionNames,
                checkboxModels: widget.checkboxModels,
                phonePageData: widget.phonePageData,
                dbUsersApp: widget.dbUsersApp,
              ),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes the default back button
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the sign-up title
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      appInfoProvider.signUpLoginPage[
                              'SignUpTitle-' + userInfoProvider.gender] ??
                          'הרשמה',
                      TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      null,
                      80),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                // Email input field
                FormContainer(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                // Password input field
                FormContainer(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                // Sign-up button
                SizedBox(
                  width: MediaQuery.of(context).size.width > 1000
                      ? 600
                      : MediaQuery.of(context).size.width * 0.6,
                  child: TextButton(
                    onPressed: () {
                      validateText(
                          [_emailController.text, _passwordController.text],
                          userInfoProvider);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: isSigningUp
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Directionality(
                            textDirection: TextDirection.rtl,
                            child: myAutoSizedText(
                                appInfoProvider.signUpLoginPage[
                                        'SignUpButton-' +
                                            userInfoProvider.gender] ??
                                    'הרשמה',
                                TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                                null,
                                40),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Link to the login page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    myAutoSizedText(
                        appInfoProvider.signUpLoginPage[
                                'SignUpExists-' + userInfoProvider.gender] ??
                            "כבר יש לך חשבון",
                        TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 12.sp),
                        TextAlign.right,
                        30),
                    const SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              collections: widget.collections,
                              collectionNames: widget.collectionNames,
                              checkboxModels: widget.checkboxModels,
                              phonePageData: widget.phonePageData,
                              dbUsersApp: widget.dbUsersApp,
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider.signUpLoginPage['SignUpToLogin-' +
                                    userInfoProvider.gender] ??
                                'להתחברות',
                            TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp),
                            null,
                            30),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
