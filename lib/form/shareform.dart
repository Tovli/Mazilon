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

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    AppLocalizations.of(context)!.sharePageHeader(gender),
                    TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    null,
                    80),
                myAutoSizedText(
                    AppLocalizations.of(context)!.sharePageSubTitle(gender),
                    TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.sp,
                        color: Colors.black),
                    null,
                    35),
                myImage('assets/images/FormSubmit.png', context, 0.8, 0.4),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: myAutoSizedText(
                      AppLocalizations.of(context)!.sharePageMidTitle(gender),
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 18.sp),
                      null,
                      35),
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
                                "",
                                [
                                  AppLocalizations.of(context)!
                                      .difficultEventsHeader(gender),
                                  AppLocalizations.of(context)!
                                      .makeSaferHeader(gender),
                                  AppLocalizations.of(context)!
                                      .feelBetterHeader(gender),
                                  AppLocalizations.of(context)!
                                      .distractionsHeader(gender),
                                  AppLocalizations.of(context)!
                                      .phonesPageHeader(gender),
                                ],
                                [
                                  AppLocalizations.of(context)!
                                      .difficultEventsSubTitle(gender),
                                  AppLocalizations.of(context)!
                                      .makeSaferSubTitle(gender),
                                  AppLocalizations.of(context)!
                                      .feelBetterSubTitle(gender),
                                  AppLocalizations.of(context)!
                                      .distractionsSubTitle(gender),
                                  AppLocalizations.of(context)!
                                      .phonesPageHeader(gender),
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
                              AppLocalizations.of(context)!
                                  .difficultEventsHeader(gender),
                              AppLocalizations.of(context)!
                                  .makeSaferHeader(gender),
                              AppLocalizations.of(context)!
                                  .feelBetterHeader(gender),
                              AppLocalizations.of(context)!
                                  .distractionsHeader(gender),
                              AppLocalizations.of(context)!
                                  .phonesPageHeader(gender),
                            ], [
                              AppLocalizations.of(context)!
                                  .difficultEventsSubTitle(gender),
                              AppLocalizations.of(context)!
                                  .makeSaferSubTitle(gender),
                              AppLocalizations.of(context)!
                                  .feelBetterSubTitle(gender),
                              AppLocalizations.of(context)!
                                  .distractionsSubTitle(gender),
                              AppLocalizations.of(context)!
                                  .phonesPageHeader(gender),
                            ], appInfoProvider.sharePDFtexts,
                                ShareFileType.PDF);
                            if (result == null) {
                              // Show him a message
                              showToast(
                                  message: AppLocalizations.of(context)!
                                      .downloadFailed(gender));
                              return;
                            }
                            // Show a toast message to the user
                            showToast(
                                message: AppLocalizations.of(context)!
                                    .finishedDownloading(gender));
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
                    AppLocalizations.of(context)!.sharePageFinishButton(gender),
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
