import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:mazilon/util/PDF/save_pdf_web.dart'
    if (dart.library.io) 'package:mazilon/util/PDF/save_pdf_io.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';

// Function to combine phone names and numbers into a formatted list
List<String> setPhones(names, numbers) {
  List<String> temp = [];
  for (var i = 0; i < names.length; i++) {
    temp.add(names[i] + ':' + numbers[i]);
  }
  return temp;
}

// Function to load an image from assets and convert it to a format usable by the PDF generator
Future<pw.Image> loadAssetImage(String path) async {
  final data = await rootBundle.load(path);
  final bytes = data.buffer.asUint8List();
  final image = pw.MemoryImage(bytes);
  return pw.Image(image);
}

// Function to generate a PDF with the user's selections and share it
Future<void> generateAndSharePdf(String message, List<dynamic> titles,
    List<dynamic> subTitles, Map<String, String> texts) async {
  final pageFormat = PdfPageFormat.a4; // Set the page format to A4
  try {
    // Load the font for the PDF
    final ByteData fontData = await rootBundle.load('assets/fonts/CALIBRI.TTF');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    final pdf = pw.Document(); // Create a new PDF document
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve user data from SharedPreferences
    List<String> userSelectionDifficultEvents =
        prefs.getStringList('userSelectionPersonalPlan-DifficultEvents') ?? [];
    List<String> userSelectionMakeSafer =
        prefs.getStringList('userSelectionPersonalPlan-MakeSafer') ?? [];
    List<String> userSelectionFeelBetter =
        prefs.getStringList('userSelectionPersonalPlan-FeelBetter') ?? [];
    List<String> userSelectionDistractions =
        prefs.getStringList('userSelectionPersonalPlan-Distractions') ?? [];
    List<String> phoneNames =
        prefs.getStringList('PhonePageSavedPhoneNames') ?? [];
    List<String> phoneNumbers =
        prefs.getStringList('PhonePageSavedPhoneNumbers') ?? [];
    String username = prefs.getString('name') ?? '';

    // Create the main title for the PDF
    String mainTitle = username == ''
        ? 'התוכנית המשולבת שלי'
        : 'התוכנית המשולבת של ' + username;

    // Combine phone names and numbers
    List<String> phoneDescription = setPhones(phoneNames, phoneNumbers);

    // Retrieve text content for the PDF
    String text1 = texts['firstLine'] ?? '';
    String text2 = texts['firstLinkText'] ?? '';
    String text2Link = texts['firstLinkURL'] ?? '';
    String text3 = texts['secondLine'] ?? '';
    String text4 = texts['thirdLine'] ?? '';
    String text5 = texts['secondLinkText'] ?? '';
    String text5Link = texts['secondLinkURL'] ?? '';
    String text6 = texts['forthLine'] ?? '';

    // Prepare the data to be included in the PDF
    List<List<String>> data = [
      userSelectionDifficultEvents,
      userSelectionMakeSafer,
      userSelectionFeelBetter,
      userSelectionDistractions,
      phoneDescription
    ];
    List<List<String>> realData = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].isEmpty) {
        continue;
      }
      realData.add(data[i]);
    }

    // Load the logo image for the PDF
    final Image = await loadAssetImage('assets/images/Logo.png');

    // Create widgets for the PDF content
    List<pw.Widget> widgets = [];
    for (var i = 0; i < realData.length; i++) {
      if (realData[i].isEmpty) {
        continue;
      }

      // Add the main title for the first section
      if (i == 0) {
        widgets.add(pw.Container(
          width: pageFormat.availableWidth,
          child: pw.Align(
            alignment: pw.Alignment.centerRight, // Align the title to the right
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl, // Set text direction to RTL
              child: pw.Text(
                mainTitle,
                style: pw.TextStyle(fontSize: 40, font: ttf),
              ),
            ),
          ),
        ));
      } else {
        widgets.add(
          pw.SizedBox(
            height: 25,
          ),
        );
      }

      widgets.add(pw.SizedBox(
        height: 25,
      ));

      // Add the title, subtitle, and data for each section
      widgets.add(
        pw.Padding(
          padding: pw.EdgeInsets.all(8.0),
          child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(children: [
                pw.Container(
                  width: pageFormat.availableWidth,
                  child: pw.Align(
                    alignment: pw.Alignment
                        .centerRight, // Align the content to the right
                    child: pw.Directionality(
                      textDirection:
                          pw.TextDirection.rtl, // Set text direction to RTL
                      child: pw.Text(
                        titles[i],
                        style: pw.TextStyle(
                            fontSize: 26,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf),
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Container(
                  width: pageFormat.availableWidth,
                  child: pw.Align(
                    alignment: pw.Alignment
                        .centerRight, // Align the content to the right
                    child: pw.Directionality(
                      textDirection:
                          pw.TextDirection.rtl, // Set text direction to RTL
                      child: pw.Text(
                        subTitles[i],
                        style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf),
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Container(
                  color: PdfColor.fromInt(0xfaf6fd),
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      for (var entry in realData[i].asMap().entries)
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.only(right: 5),
                                child: pw.Directionality(
                                    textDirection: pw.TextDirection.rtl,
                                    child: pw.Text(
                                        '${entry.key + 1}. ${entry.value}',
                                        style: pw.TextStyle(
                                            fontSize: 20, font: ttf),
                                        textAlign: pw.TextAlign.right))),
                          ],
                        ),
                    ],
                  ),
                ),
              ])),
        ),
      );
    }

    // Add space before footer
    widgets.add(
      pw.Expanded(
        child: pw.SizedBox(),
      ),
    );

    // Add the footer content to the PDF
    widgets.add(
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(
          text1,
          style: pw.TextStyle(fontSize: 20, font: ttf),
          textAlign: pw.TextAlign.right,
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.UrlLink(
          destination: text2Link,
          child: pw.Text(
            text2,
            style: pw.TextStyle(fontSize: 24, font: ttf, color: PdfColors.blue),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(
          text3,
          style: pw.TextStyle(fontSize: 20, font: ttf),
          textAlign: pw.TextAlign.right,
        ),
      ),
      pw.SizedBox(height: 20),
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(
          text4,
          style: pw.TextStyle(fontSize: 20, font: ttf),
          textAlign: pw.TextAlign.right,
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.UrlLink(
          destination: text5Link,
          child: pw.Text(
            text5,
            style: pw.TextStyle(fontSize: 24, font: ttf, color: PdfColors.blue),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(
          text6,
          style: pw.TextStyle(fontSize: 20, font: ttf),
          textAlign: pw.TextAlign.right,
        ),
      ),
    ]));

    // Add the generated widgets to the PDF
    pdf.addPage(
      pw.MultiPage(
        header: (context) {
          return pw.Row(
            children: [
              pw.SizedBox(height: 100, width: 100, child: Image),
            ],
          );
        },
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets, // Build the PDF with the generated widgets
      ),
    );

    // Save the PDF and share it
    Uint8List pdfData = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempFile = File('${tempDir.path}/MyPlan${timestamp}.pdf');
    await tempFile.writeAsBytes(pdfData);
    XFile tempXFile = XFile(tempFile.path);
    await Share.shareXFiles([tempXFile], text: message);
  } catch (e) {
    print('Error: $e');
  }
}

// Function to generate a PDF and allow the user to download it
Future<void> downloadPDF(List<dynamic> titles, List<dynamic> subTitles,
    Map<String, String> texts) async {
  final pageFormat = PdfPageFormat.a4; // Set the page format to A4
  final ByteData fontData = await rootBundle.load('assets/fonts/CALIBRI.TTF');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());
  final pdf = pw.Document(); // Create a new PDF document
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve user data from SharedPreferences
  List<String> userSelectionDifficultEvents =
      prefs.getStringList('userSelectionPersonalPlan-DifficultEvents') ?? [];
  List<String> userSelectionMakeSafer =
      prefs.getStringList('userSelectionPersonalPlan-MakeSafer') ?? [];
  List<String> userSelectionFeelBetter =
      prefs.getStringList('userSelectionPersonalPlan-FeelBetter') ?? [];
  List<String> userSelectionDistractions =
      prefs.getStringList('userSelectionPersonalPlan-Distractions') ?? [];
  List<String> phoneNames =
      prefs.getStringList('PhonePageSavedPhoneNames') ?? [];
  List<String> phoneNumbers =
      prefs.getStringList('PhonePageSavedPhoneNumbers') ?? [];
  String username = prefs.getString('name') ?? '';

  // Create the main title for the PDF
  String mainTitle =
      username == '' ? 'התוכנית המשולבת שלי' : 'התוכנית המשולבת של ' + username;

  // Combine phone names and numbers
  List<String> phoneDescription = setPhones(phoneNames, phoneNumbers);

  // Retrieve text content for the PDF
  String text1 = texts['firstLine'] ?? '';
  String text2 = texts['firstLinkText'] ?? '';
  String text2Link = texts['firstLinkURL'] ?? '';
  String text3 = texts['secondLine'] ?? '';
  String text4 = texts['thirdLine'] ?? '';
  String text5 = texts['secondLinkText'] ?? '';
  String text5Link = texts['secondLinkURL'] ?? '';
  String text6 = texts['forthLine'] ?? '';

  // Prepare the data to be included in the PDF
  List<List<String>> data = [
    userSelectionDifficultEvents,
    userSelectionMakeSafer,
    userSelectionFeelBetter,
    userSelectionDistractions,
    phoneDescription
  ];
  List<List<String>> realData = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i].isEmpty) {
      continue;
    }
    realData.add(data[i]);
  }

  // Load the logo image for the PDF
  final Image = await loadAssetImage('assets/images/Logo.png');

  // Create widgets for the PDF content
  List<pw.Widget> widgets = [];
  for (var i = 0; i < realData.length; i++) {
    if (realData[i].isEmpty) {
      continue;
    }

    // Add the main title for the first section
    if (i == 0) {
      widgets.add(pw.Container(
        width: pageFormat.availableWidth,
        child: pw.Align(
          alignment: pw.Alignment.centerRight, // Align the title to the right
          child: pw.Directionality(
            textDirection: pw.TextDirection.rtl, // Set text direction to RTL
            child: pw.Text(
              mainTitle,
              style: pw.TextStyle(fontSize: 40, font: ttf),
            ),
          ),
        ),
      ));
    } else {
      widgets.add(
        pw.SizedBox(
          height: 25,
        ),
      );
    }

    widgets.add(pw.SizedBox(
      height: 25,
    ));

    // Add the title, subtitle, and data for each section
    widgets.add(
      pw.Padding(
        padding: pw.EdgeInsets.all(8.0),
        child: pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(children: [
              pw.Container(
                width: pageFormat.availableWidth,
                child: pw.Align(
                  alignment: pw
                      .Alignment.centerRight, // Align the content to the right
                  child: pw.Directionality(
                    textDirection:
                        pw.TextDirection.rtl, // Set text direction to RTL
                    child: pw.Text(
                      titles[i],
                      style: pw.TextStyle(
                          fontSize: 26,
                          fontWeight: pw.FontWeight.bold,
                          font: ttf),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Container(
                width: pageFormat.availableWidth,
                child: pw.Align(
                  alignment: pw
                      .Alignment.centerRight, // Align the content to the right
                  child: pw.Directionality(
                    textDirection:
                        pw.TextDirection.rtl, // Set text direction to RTL
                    child: pw.Text(
                      subTitles[i],
                      style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          font: ttf),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Container(
                color: PdfColor.fromInt(0xfaf6fd),
                child: pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    for (var entry in realData[i].asMap().entries)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.only(right: 5),
                              child: pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                      '${entry.key + 1}. ${entry.value}',
                                      style:
                                          pw.TextStyle(fontSize: 20, font: ttf),
                                      textAlign: pw.TextAlign.right))),
                        ],
                      ),
                  ],
                ),
              ),
            ])),
      ),
    );
  }

  // Add space before footer
  widgets.add(
    pw.Expanded(
      child: pw.SizedBox(),
    ),
  );

  // Add the footer content to the PDF
  widgets
      .add(pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        text1,
        style: pw.TextStyle(fontSize: 20, font: ttf),
        textAlign: pw.TextAlign.right,
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.UrlLink(
        destination: text2Link,
        child: pw.Text(
          text2,
          style: pw.TextStyle(fontSize: 24, font: ttf, color: PdfColors.blue),
          textAlign: pw.TextAlign.right,
        ),
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        text3,
        style: pw.TextStyle(fontSize: 20, font: ttf),
        textAlign: pw.TextAlign.right,
      ),
    ),
    pw.SizedBox(height: 20),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        text4,
        style: pw.TextStyle(fontSize: 20, font: ttf),
        textAlign: pw.TextAlign.right,
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.UrlLink(
        destination: text5Link,
        child: pw.Text(
          text5,
          style: pw.TextStyle(fontSize: 24, font: ttf, color: PdfColors.blue),
          textAlign: pw.TextAlign.right,
        ),
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        text6,
        style: pw.TextStyle(fontSize: 20, font: ttf),
        textAlign: pw.TextAlign.right,
      ),
    ),
  ]));

  // Add the generated widgets to the PDF
  pdf.addPage(
    pw.MultiPage(
      header: (context) {
        return pw.Row(
          children: [
            pw.SizedBox(height: 100, width: 100, child: Image),
          ],
        );
      },
      pageFormat: PdfPageFormat.a4,
      build: (context) => widgets, // Build the PDF with the generated widgets
    ),
  );

  // Save the PDF for download
  Uint8List pdfData = await pdf.save();
  await savePdf(pdfData);
}
