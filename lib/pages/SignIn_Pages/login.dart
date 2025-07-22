import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/global_enums.dart';

import 'package:mazilon/initialForm/form.dart';
import 'package:mazilon/pages/SignIn_Pages/signup.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Firebase/firebase_functions.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/SignIn/form_container.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:mazilon/util/SignIn/sign_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

// LoginPage is a stateful widget that handles the user login process.
// It supports both email/password login and Google login.
class LoginPage extends StatefulWidget {
  PhonePageData phonePageData; // Data related to phone page
  FirebaseApp dbUsersApp; // FirebaseApp instance
  final Function changeLocale;

  LoginPage(
      {super.key,
      required this.dbUsersApp,
      required this.phonePageData,
      required this.changeLocale});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false; // Tracks the signing-in process
  late FirebaseAuthService _auth; // Auth service for Firebase operations

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize FirebaseAuthService with the specific FirebaseApp instance
    _auth = FirebaseAuthService(widget.dbUsersApp);
  }

  // General sign-in method that handles both email/password and Google sign-in.
  void signInGeneral(
      bool google, List<String> texts, UserInformation userInfo) {
    if (!google) {
      if (texts.any((text) => text.isEmpty)) {
        showToast(message: "Please fill in all the fields");
        return;
      }
    }

    signInBoth(google, texts[0], texts[1], userInfo)
        .then((result) => {callback(result, widget, context)});
  }

  // Handles sign-in with email and password.
  Future<bool> signIn(
      String email, String password, UserInformation userInfo) async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance

    setState(() {
      _isSigning = true;
    });

    User? user = await _auth.signInWithEmailAndPassword(
        email.trimRight(), password.trim());
    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      userInfo.updateUserId(user.uid);

      await service.setItem('userId', PersistentMemoryType.String, user.uid);
      userInfo.updateLoggedIn(true);

      await service.setItem('loggedIn', PersistentMemoryType.Bool, true);
      showToast(message: "User is successfully signed in");
      return true;
    } else {
      showToast(message: "Some error occurred");
      return false;
    }
  }

  // Handles both Google sign-in and email/password sign-in.
  Future<bool> signInBoth(bool google, String email, String password,
      UserInformation userInfo) async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance

    setState(() {
      _isSigning = true;
    });

    User? user = google
        ? await signInWithGoogle(userInfo)
        : await _auth.signInWithEmailAndPassword(email, password);
    setState(() {
      _isSigning = false;
    });
    userInfo.updateUserId(user!.uid);
    userInfo.updateLoggedIn(user != null);
    await service.setItem('loggedIn', PersistentMemoryType.Bool, user != null);
    await service.setItem('userId', PersistentMemoryType.String, user.uid);

    if (user != null) {
      showToast(message: "User is successfully signed in");
      return true;
    } else {
      showToast(message: "Some error occurred");
      return false;
    }
  }

  // Handles Google sign-in process.
  Future<User?> signInWithGoogle(UserInformation userInfo) async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance

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
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      userInfo.updateUserId(userCredential.user!.uid);
      userInfo.updateLoggedIn(userCredential.user != null);
      await service.setItem(
          'userId', PersistentMemoryType.String, userCredential.user!.uid);
      await service.setItem(
          'loggedIn', PersistentMemoryType.Bool, userCredential.user != null);
      await service.setItem('googleAccessToken', PersistentMemoryType.String,
          googleAuth.accessToken!);

      return userCredential.user;
    }
    // Save the access token for future use with Google Drive API

    return null; // User cancelled the Google sign-in process
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
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Displaying the login title with dynamic text based on user's gender
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      appInfoProvider.signUpLoginPage[
                              'LoginTitle-' + userInfoProvider.gender] ??
                          'התחברות למצילון',
                      TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                      null,
                      80),
                ),
                const SizedBox(
                  height: 30,
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
                  height: 20,
                ),
                // Sign in button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      signInGeneral(
                        false,
                        [
                          _emailController.text,
                          _passwordController.text,
                        ],
                        userInfoProvider,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isSigning
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Directionality(
                            textDirection: TextDirection.rtl,
                            child: myAutoSizedText(
                                appInfoProvider.signUpLoginPage['LoginButton-' +
                                        userInfoProvider.gender] ??
                                    'התחברות',
                                TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                                null,
                                40),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Google sign-in button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      signInGeneral(
                        true,
                        ["", ""],
                        userInfoProvider,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: myAutoSizedText(
                              appInfoProvider.signUpLoginPage[
                                      'LoginGoogleButton-' +
                                          userInfoProvider.gender] ??
                                  'התחברות עם גוגל',
                              TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp),
                              null,
                              40),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Link to Sign Up page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(
                              phonePageData: widget.phonePageData,
                              dbUsersApp: widget.dbUsersApp,
                              changeLocale: widget.changeLocale,
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider.signUpLoginPage['LoginToSignup-' +
                                    userInfoProvider.gender] ??
                                'לרישום',
                            TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp),
                            null,
                            30),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          appInfoProvider.signUpLoginPage['LoginNoAccount-' +
                                  userInfoProvider.gender] ??
                              '?אין לך חשבון',
                          TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12.sp),
                          null,
                          30),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Skip registration button
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InitialFormProgressIndicator(
                              phonePageData: widget.phonePageData,
                              changeLocale: widget.changeLocale),
                        ),
                      );
                    },
                    child: myAutoSizedText(
                        appInfoProvider.signUpLoginPage[
                                'LoginSkip-' + userInfoProvider.gender] ??
                            'לדילוג על הרישום',
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                        null,
                        30))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
