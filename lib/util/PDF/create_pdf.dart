import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Map<String, dynamic>> createPDF(
    List<dynamic> titles,
    List<dynamic> subTitles,
    Map<String, String> texts,
    String mainTitle,
    List<List<String>> data) async {
  final pageFormat = PdfPageFormat.a4;
  final ByteData fontData = await rootBundle.load('assets/fonts/CALIBRI.TTF');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());
  final imageData = await rootBundle.load(
    'assets/images/Logo.png',
  );
  final imageBytes = imageData.buffer.asUint8List();
  final image = pw.Image(pw.MemoryImage(imageBytes));
  final pdf = pw.Document();
  List<pw.Widget> widgets = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i].isEmpty) {
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
                color: const PdfColor.fromInt(0xfaf6fd),
                child: pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    for (var entry in data[i].asMap().entries)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.only(right: 5),
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
        texts["text1"]!,
        style: pw.TextStyle(fontSize: 20, font: ttf),
        textAlign: pw.TextAlign.right,
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.UrlLink(
        destination: texts["text2Link"]!,
        child: pw.Text(
          texts["text2"]!,
          style: pw.TextStyle(fontSize: 24, font: ttf, color: PdfColors.blue),
          textAlign: pw.TextAlign.right,
        ),
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        texts["text3"]!,
        style: pw.TextStyle(fontSize: 20, font: ttf),
        textAlign: pw.TextAlign.right,
      ),
    ),
    pw.SizedBox(height: 20),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        texts["text4"]!,
        style: pw.TextStyle(fontSize: 20, font: ttf),
        textAlign: pw.TextAlign.right,
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.UrlLink(
        destination: texts["text5Link"]!,
        child: pw.Text(
          texts["text5"]!,
          style: pw.TextStyle(fontSize: 24, font: ttf, color: PdfColors.blue),
          textAlign: pw.TextAlign.right,
        ),
      ),
    ),
    pw.SizedBox(height: 10),
    pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        texts["text6"]!,
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
  return {"file": pdf, "format": "pdf"};
}

Future<File> saveTempPDF(pw.Document pdf, String format) async {
  Uint8List fileData = await pdf.save();
  final tempDir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final tempFile = File('${tempDir.path}/התוכנית שלי$timestamp.$format');
  await tempFile.writeAsBytes(fileData);
  return tempFile;
}
