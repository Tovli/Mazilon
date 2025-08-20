import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get_it/get_it.dart';

import 'package:mazilon/global_enums.dart';
import 'package:mazilon/file_service.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/styles.dart';

import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/Share/show_share_dialog.dart';

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

class _ShareFormState extends LPExtendedState<ShareForm> {
  late FileService fileService;
  void setHasFilled() async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance

    await service.setItem("hasFilled", PersistentMemoryType.Bool, true);
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
                  height: returnSizedBox(context, 25),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: myAutoSizedText(
                      appLocale!.sharePageHeader(gender),
                      TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      null,
                      80),
                ),
                myAutoSizedText(
                    appLocale!.sharePageSubTitle(gender),
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
                      appLocale!.sharePageMidTitle(gender),
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 18.sp),
                      null,
                      35),
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
                          onPressed: () {
                            showShareDialog(context);
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
                              appLocale.difficultEventsHeader(gender),
                              appLocale.makeSaferHeader(gender),
                              appLocale.feelBetterHeader(gender),
                              appLocale.distractionsHeader(gender),
                              appLocale.phonesPageHeader(gender),
                            ], [
                              appLocale.difficultEventsSubTitle(gender),
                              appLocale.makeSaferSubTitle(gender),
                              appLocale.feelBetterSubTitle(gender),
                              appLocale.distractionsSubTitle(gender),
                              appLocale.phonesPageHeader(gender),
                            ], appInfoProvider.sharePDFtexts, ShareFileType.PDF,
                                appLocale.textDirection);
                            if (result == null) {
                              // Show him a message
                              showToast(
                                  message: appLocale!.downloadFailed(gender));
                              return;
                            }
                            // Show a toast message to the user
                            showToast(
                                message:
                                    appLocale!.finishedDownloading(gender));
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
                    appLocale!.sharePageFinishButton(gender),
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
