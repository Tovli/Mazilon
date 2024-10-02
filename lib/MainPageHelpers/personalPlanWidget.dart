import 'package:fluttericon/elusive_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/personalPlanItem.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';
import 'package:mazilon/util/PDF/save_pdf_web.dart'
    if (dart.library.io) 'package:mazilon/util/PDF/save_pdf_io.dart';
import 'package:mazilon/util/PDF/shareAndDownload.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

// the personal plan widget, thats related to the personal plan section in home page
class PersonalPlanWidget extends StatefulWidget {
  final Map<String, dynamic> text; // the text of the personal plan
  final Function(int)
      changeCurrentIndex; // the function to change the current index
  const PersonalPlanWidget(
      {super.key, required this.text, required this.changeCurrentIndex});

  @override
  State<PersonalPlanWidget> createState() => _PersonalPlanWidgetState();
}

class _PersonalPlanWidgetState extends State<PersonalPlanWidget> {
  late List<String> randomItems = ['1', '2'];
  List<String> feelBetter = [];
  void loadFeelBetter() {
    var random = Random();
    var index1 = 0;
    var index2 = 0;
    // taking two random items from the list of the feel better answers or other question
    // that user filled in the form
    if (widget.text['list'].length >= 2) {
      index1 = random.nextInt(widget.text['list'].length);
      do {
        index2 = random.nextInt(widget.text['list'].length);
      } while (index1 == index2);
      setState(() {
        randomItems = [
          widget.text['list'][index1],
          widget.text['list'][index2]
        ];
      });
    } else if (widget.text['list'].length == 1) {
      index1 = 0;
      setState(() {
        randomItems = [widget.text['list'][index1]];
      });
    } else {
      setState(() {
        randomItems = [];
      });
    }
  }

  @override
  void initState() {
    loadFeelBetter();
    super.initState();
  }

  // the share function, that shows the share dialog
  void share(appInfoProvider, gender) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              width: 300,
              height: 50,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: myAutoSizedText(
                    appInfoProvider.formSharePageTitles[
                        'shareTitle$gender'], // the title of the share dialog
                    TextStyle(
                      fontSize: 14.sp, // the font size of the title
                      fontWeight: FontWeight.normal,
                    ),
                    TextAlign.right,
                    26),
              ),
            ),
            // the buttons of the share dialog to whatsapp (routine and emergency) ,
            // and the share button , and the cancel button
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // the routine button to share the routine message on whatsapp
                  Container(
                    width: 100.w,
                    height: 50,
                    child: ElevatedButton(
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
                      // the text of the routine button
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider
                                .formSharePageTitles['routineSendButtonText']!,
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp // the font size of the text
                                ),
                            null,
                            35),
                      ),
                    ),
                  ),
                  // the emergency button to share the emergency message on whatsapp
                  Container(
                    width: 100.w,
                    height: 50,
                    child: ElevatedButton(
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
                      // the text of the emergency button
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider.formSharePageTitles[
                                'emergencySendButtonText']!,
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp // the font size of the text
                                ),
                            null,
                            35),
                      ),
                    ),
                  ),
                ],
              ),
              //gap between the routine, emergency buttons and the share and cancel buttons
              SizedBox(height: 35),
              // the share button , to share the pdf file of the personal plan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 70.w,
                    height: 50,
                    child: IconButton(
                      icon: const Icon(Icons.share), // the share icon
                      onPressed: () async {
                        // the function to generate and share the pdf file of the personal plan
                        await generateAndSharePdf(
                          appInfoProvider.shareMessages['regular']!,
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
                            appInfoProvider
                                .formDifficultEventsTitles['subTitle$gender'],
                            appInfoProvider
                                .formMakeSaferTitles['subTitle$gender'],
                            appInfoProvider
                                .formFeelBetterTitles['subTitle$gender'],
                            appInfoProvider
                                .formDistractionsTitles['subTitle$gender'],
                            appInfoProvider.formPhonePage['subTitle$gender'],
                          ],
                          appInfoProvider.sharePDFtexts,
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  // the cancel button to close the share dialog
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: const Text(
                        "ביטול",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red // the color of the text
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

// the build function of the personal plan widget
  @override
  Widget build(BuildContext context) {
    loadFeelBetter();
    // the providers of the app information and the user information
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final gender = userInfoProvider.gender;
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            // the section bar of the personal plan section in the home page,
            // with the title of the section and the icon of the section , and share and download buttons
            // and the sub title of the section, when the user presses the section bar,
            // it will take him to the personal plan page
            SectionBarHome(
                textWidget: TextButton(
                    onPressed: () {
                      widget.changeCurrentIndex(1);
                    },
                    // the title of the personal plan section in the home page
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          appInfoProvider.personalPlanMainTitle[
                              'PersonalPlanMainTitle-' +
                                  userInfoProvider.gender],
                          TextStyle(
                            fontSize: 24.sp, // the font size of the title
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // the color of the title
                          ),
                          null,
                          40),
                    )),
                icon: Icons.note_add, // the icon of the personal plan section
                icons: [
                  // the share and download buttons
                  myTextButton(() {
                    share(appInfoProvider, gender);
                  }, Elusive.share, Colors.black),
                  myTextButton(() async {
                    // the function to download the pdf file of the personal plan
                    await downloadPDF(
                      [
                        appInfoProvider
                            .formDifficultEventsTitles['header$gender'],
                        appInfoProvider.formMakeSaferTitles['header$gender'],
                        appInfoProvider.formFeelBetterTitles['header$gender'],
                        appInfoProvider.formDistractionsTitles['header$gender'],
                        appInfoProvider.formPhonePage['header$gender'],
                      ],
                      [
                        appInfoProvider
                            .formDifficultEventsTitles['subTitle$gender'],
                        appInfoProvider.formMakeSaferTitles['subTitle$gender'],
                        appInfoProvider.formFeelBetterTitles['subTitle$gender'],
                        appInfoProvider
                            .formDistractionsTitles['subTitle$gender'],
                        appInfoProvider.formPhonePage['subTitle$gender'],
                      ],
                      appInfoProvider.sharePDFtexts,
                    );
//TODO: think of a way to do the other option to chose where to download the file to (like the share option)
                    showDialog(
                      // the dialog that shows the user that the download has started and finished
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(appInfoProvider
                                    .returnToPlanStrings['StartedDownload'] ??
                                'ההורדה החלה'),
                          ),
                          content: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(appInfoProvider
                                    .returnToPlanStrings['FinishDownload'] ??
                                'התוכנית ירדה'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(appInfoProvider
                                        .returnToPlanStrings['Finish'] ??
                                    'סיום'),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }, Icons.download, Colors.black) // the download icon
                ],
                // the sub title of the personal plan section in the home page
                subHeader: widget.text['SubTitle']),
            GridView.count(
                crossAxisCount: 2, // Set the number of items in each row
                crossAxisSpacing: 5,
                childAspectRatio: 12 / 4,
                shrinkWrap:
                    true, // Use this if the GridView is inside another scrolling widget
                physics:
                    const NeverScrollableScrollPhysics(), // Adjust this value as needed to change the aspect ratio of the items
                // the personal plan items that the user filled in the form
                children: randomItems
                    .map((pPlan) => Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 5),
                          child: PersonalPlanItem(text: pPlan),
                        ))
                    .toList()
                // Use this if the GridView is inside another scrolling widget
                ),
            // the button to take the user to the personal plan page
            GestureDetector(
              onTap: () {
                widget.changeCurrentIndex(1);
                // Handle the button tap here
              },
              child: Row(
                children: [
                  const Icon(Icons.arrow_left),
                  myAutoSizedText(
                      appInfoProvider.returnToPlanStrings['AllPlan'] ??
                          'לכל התוכנית',
                      TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp // the font size of the text
                          ),
                      null,
                      20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
