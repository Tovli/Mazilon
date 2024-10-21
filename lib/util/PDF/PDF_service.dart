import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PDFService {
  Future<pw.Document> create(
      List<dynamic> titles, List<dynamic> subTitles, Map<String, String> texts);

  Future<void> share(String message, List<dynamic> titles,
      List<dynamic> subTitles, Map<String, String> texts);
  Future<String?> download(
      List<dynamic> titles, List<dynamic> subTitles, Map<String, String> texts);
}

class PDFServiceImpl implements PDFService {
  static Future<Map<String, dynamic>> getPrefsData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
    return {
      'DifficultEvents': userSelectionDifficultEvents,
      'MakeSafer': userSelectionMakeSafer,
      'FeelBetter': userSelectionFeelBetter,
      'Distractions': userSelectionDistractions,
      'phoneNames': phoneNames,
      'phoneNumbers': phoneNumbers,
      'username': username
    };
  }

  static List<List<String>> filterEmptyData(List<List<String>> data) {
    List<List<String>> filtered = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].isEmpty) {
        continue;
      }
      filtered.add(data[i]);
    }
    return filtered;
  }

  static List<String> setPhones(names, numbers) {
    List<String> temp = [];
    for (var i = 0; i < names.length; i++) {
      temp.add(names[i] + ':' + numbers[i]);
    }
    return temp;
  }

  static Future<pw.Image> loadAssetImage(String path) async {
    // Load an image from assets and convert it to a format usable by the PDF generator
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = pw.MemoryImage(bytes);
    return pw.Image(image);
  }

  static Future<String?> savePdfAndroid(Uint8List pdfData) async {
    print(pdfData); // Print the PDF data for debugging purposes
    try {
      // Open a save file dialog to allow the user to select a location to save the PDF
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:', // Dialog title
        fileName: 'התוכנית שלי.pdf', // Default file name
        bytes: pdfData, // PDF data to be saved
      );
      //If the user cancels the download
      return outputFile;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<String?> savePdfWeb(List<int> pdfData) async {
    // Create a Blob object from the PDF data
    /*final blob = html.Blob([pdfData], 'application/pdf');

    // Generate a URL for the Blob object
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and set its href attribute to the Blob URL
    final anchor = html.AnchorElement(href: url)
      // Set the download attribute with the desired file name
      ..setAttribute('download', 'MyPlan.pdf')
      // Trigger a click on the anchor element to start the download
      ..click();*/
    //TODO: return a String to show a message to the user
    return null;
  }

  @override
  Future<pw.Document> create(List<dynamic> titles, List<dynamic> subTitles,
      Map<String, String> texts) async {
    final pageFormat = PdfPageFormat.a4; // Set the page format to A4

    // Load the font for the PDF
    final ByteData fontData = await rootBundle.load('assets/fonts/CALIBRI.TTF');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    final pdf = pw.Document(); // Create a new PDF document
    final dataForPDF = await getPrefsData();
    // Retrieve user data from SharedPreferences
    List<String> difficultEvents = dataForPDF['DifficultEvents'];
    List<String> makeSafer = dataForPDF['MakeSafer'];
    List<String> feelBetter = dataForPDF['FeelBetter'];
    List<String> distractions = dataForPDF['Distractions'];
    List<String> phoneNames = dataForPDF['phoneNames'];
    List<String> phoneNumbers = dataForPDF['phoneNumbers'];
    String username = dataForPDF['username'];

    // Create the main title for the PDF
    String mainTitle =
        username == '' ? 'התוכנית המשולבת שלי' : 'התוכנית המשולבת של $username';

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

    List<List<String>> realData = [];
    realData = filterEmptyData([
      difficultEvents,
      makeSafer,
      feelBetter,
      distractions,
      phoneDescription
    ]);
    // Load the logo image for the PDF
    final image = await loadAssetImage('assets/images/Logo.png');

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
          padding: const pw.EdgeInsets.all(8.0),
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
                  color: const PdfColor.fromInt(0xfaf6fd),
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      for (var entry in realData[i].asMap().entries)
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.only(right: 5),
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
              pw.SizedBox(height: 100, width: 100, child: image),
            ],
          );
        },
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets, // Build the PDF with the generated widgets
      ),
    );
    return pdf;
  }

  @override
  Future<void> share(String message, List<dynamic> titles,
      List<dynamic> subTitles, Map<String, String> texts) async {
    try {
      // Add the generated widgets to the PDF
      final pdf = await create(titles, subTitles, texts);

      // Save the PDF and share it
      Uint8List pdfData = await pdf.save();
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/MyPlan$timestamp.pdf');
      await tempFile.writeAsBytes(pdfData);
      XFile tempXFile = XFile(tempFile.path);
      await Share.shareXFiles([tempXFile], text: message);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Future<String?> download(List<dynamic> titles, List<dynamic> subTitles,
      Map<String, String> texts) async {
    final pdf = await create(titles, subTitles, texts);
    // Save the PDF for download
    Uint8List pdfData = await pdf.save();
    if (Platform.isAndroid) {
      return await savePdfAndroid(pdfData);
    }
    if (kIsWeb) {
      return await savePdfWeb(pdfData);
    }
    return null;
  }
}
