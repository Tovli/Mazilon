import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get_it/get_it.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/file_service.dart';

import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/styles.dart';

import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareForm extends StatefulWidget {
  final Function prev;
  final Function submit;

  ShareForm({
    Key? key,
    required this.prev,
    required this.submit,
  }) : super(key: key);

  @override
  State<ShareForm> createState() => _ShareFormState();
}

class _ShareFormState extends State<ShareForm> {
  late FileService fileService;
  void setHasFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasFilled', true);
  }

  @override
  void initState() {
    super.initState();
    fileService = GetIt.instance<FileService>();
    setHasFilled();
  }

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final gender = userInfoProvider.gender;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: returnSizedBox(context, 100),
                ),
                myAutoSizedText(
                    appInfoProvider.formSharePageTitles['header'],
                    TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    null,
                    80),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      appInfoProvider.formSharePageTitles[
                          'subTitle${userInfoProvider.gender}'],
                      TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.sp,
                          color: Colors.black),
                      TextAlign.center,
                      35),
                ),
                myImage('assets/images/FormSubmit.png', context, 0.8, 0.4),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: myAutoSizedText(
                        appInfoProvider.formSharePageTitles[
                            'midTitle${userInfoProvider.gender}'],
                        TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18.sp),
                        TextAlign.center,
                        35),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //share personal plan PDF button:
                        IconButton(
                          onPressed: () async {
                            await fileService.share(
                                appInfoProvider.shareMessages['emergency']!,
                                [
                                  appInfoProvider.formDifficultEventsTitles[
                                      'header$gender'],
                                  appInfoProvider
                                      .formMakeSaferTitles['header$gender'],
                                  appInfoProvider
                                      .formFeelBetterTitles['header$gender'],
                                  appInfoProvider
                                      .formDistractionsTitles['header$gender'],
                                  appInfoProvider
                                      .formPhonePage['header$gender'],
                                ],
                                [
                                  appInfoProvider.formDifficultEventsTitles[
                                      'subTitle$gender'],
                                  appInfoProvider
                                      .formMakeSaferTitles['subTitle$gender'],
                                  appInfoProvider
                                      .formFeelBetterTitles['subTitle$gender'],
                                  appInfoProvider.formDistractionsTitles[
                                      'subTitle$gender'],
                                  appInfoProvider
                                      .formPhonePage['subTitle$gender'],
                                ],
                                appInfoProvider.sharePDFtexts,
                                ShareFileType.PDF);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors
                                .white, // Set the background color to white
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              side: BorderSide(
                                  color: primaryPurple), // Set the border color
                            ),
                          ),
                          icon: Icon(Icons.share,
                              color: primaryPurple), // Set the icon color
                          padding: const EdgeInsets.all(10),
                        ),
                        //download personal plan PDF button:
                        IconButton(
                          onPressed: () async {
                            var result = await fileService.download([
                              appInfoProvider
                                  .formDifficultEventsTitles['header$gender'],
                              appInfoProvider
                                  .formMakeSaferTitles['header$gender'],
                              appInfoProvider
                                  .formFeelBetterTitles['header$gender'],
                              appInfoProvider
                                  .formDistractionsTitles['header$gender'],
                              appInfoProvider.formPhonePage['header$gender'],
                            ], [
                              appInfoProvider
                                  .formDifficultEventsTitles['subTitle$gender'],
                              appInfoProvider
                                  .formMakeSaferTitles['subTitle$gender'],
                              appInfoProvider
                                  .formFeelBetterTitles['subTitle$gender'],
                              appInfoProvider
                                  .formDistractionsTitles['subTitle$gender'],
                              appInfoProvider.formPhonePage['subTitle$gender'],
                            ], appInfoProvider.sharePDFtexts,
                                ShareFileType.PDF);
                            if (result == null) {
                              // Show him a message
                              showToast(message: 'ההורדה נכשלה');
                              return;
                            }
                            // Show a toast message to the user
                            showToast(message: 'הקובץ שלך ירד');
                          },

                          style: TextButton.styleFrom(
                            backgroundColor: Colors
                                .white, // Set the background color to white
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              side: BorderSide(
                                  color: primaryPurple), // Set the border color
                            ),
                          ),
                          icon: Icon(Icons.download,
                              color: primaryPurple), // Set the icon color
                          padding: const EdgeInsets.all(10),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                ConfirmationButton(context, () {
                  widget.submit(context);
                },
                    appInfoProvider.formSharePageTitles['finishButton'],
                    myTextStyle.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 22.sp)),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
