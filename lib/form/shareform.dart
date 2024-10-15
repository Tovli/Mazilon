import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/PDF/shareAndDownload.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void setHasFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasFilled', true);
  }

  @override
  void initState() {
    super.initState();
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
                //whatsapp share msg row:
                /*  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //send whatsapp routine text button:
                    ElevatedButton(
                      onPressed: () async {
                        String text = appInfoProvider.shareMessages['regular']!;
                        Uri whatsappUrl =
                            Uri.parse("https://wa.me/?text=$text");
                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(whatsappUrl);
                        } else {
                          throw 'Could not launch $whatsappUrl';
                        }
                      },
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider
                                .formSharePageTitles['routineSendButtonText']!,
                            TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                            null,
                            35),
                      ),
                    ),
                    //send whatsapp emergency text button:
                    ElevatedButton(
                      onPressed: () async {
                        String text = appInfoProvider.shareMessages[
                            'emergency']!; // Your message for the routine button
                        Uri whatsappUrl =
                            Uri.parse("https://wa.me/?text=$text");
                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(whatsappUrl);
                        } else {
                          throw 'Could not launch $whatsappUrl';
                        }
                      },
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider.formSharePageTitles[
                                'emergencySendButtonText']!,
                            TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                            null,
                            35),
                      ),
                    ),
                  ],
                ),
               */
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
                            await generateAndSharePdf(
                              appInfoProvider.shareMessages['emergency']!,
                              [
                                appInfoProvider
                                    .formDifficultEventsTitles['header$gender'],
                                appInfoProvider
                                    .formMakeSaferTitles['header$gender'],
                                appInfoProvider
                                    .formFeelBetterTitles['header$gender'],
                                appInfoProvider
                                    .formDistractionsTitles['header$gender'],
                                appInfoProvider.formPhonePage['header$gender'],
                              ],
                              [
                                appInfoProvider.formDifficultEventsTitles[
                                    'subTitle$gender'],
                                appInfoProvider
                                    .formMakeSaferTitles['subTitle$gender'],
                                appInfoProvider
                                    .formFeelBetterTitles['subTitle$gender'],
                                appInfoProvider
                                    .formDistractionsTitles['subTitle$gender'],
                                appInfoProvider
                                    .formPhonePage['subTitle$gender'],
                              ],
                              appInfoProvider.sharePDFtexts,
                            );
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
                            downloadPDF(
                              [
                                appInfoProvider
                                    .formDifficultEventsTitles['header$gender'],
                                appInfoProvider
                                    .formMakeSaferTitles['header$gender'],
                                appInfoProvider
                                    .formFeelBetterTitles['header$gender'],
                                appInfoProvider
                                    .formDistractionsTitles['header$gender'],
                                appInfoProvider.formPhonePage['header$gender'],
                              ],
                              [
                                appInfoProvider.formDifficultEventsTitles[
                                    'subTitle$gender'],
                                appInfoProvider
                                    .formMakeSaferTitles['subTitle$gender'],
                                appInfoProvider
                                    .formFeelBetterTitles['subTitle$gender'],
                                appInfoProvider
                                    .formDistractionsTitles['subTitle$gender'],
                                appInfoProvider
                                    .formPhonePage['subTitle$gender'],
                              ],
                              appInfoProvider.sharePDFtexts,
                            );
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
