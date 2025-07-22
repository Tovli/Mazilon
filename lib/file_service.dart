// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/util/PDF/create_pdf.dart';
import 'package:mazilon/util/logger_service.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/l10n/app_localizations.dart';

abstract class FileService {
  Future<void> share(
      String message,
      List<dynamic> titles,
      List<dynamic> subTitles,
      Map<String, String> texts,
      ShareFileType saveFormat,
      String textDirection);
  Future<String?> download(
      List<dynamic> titles,
      List<dynamic> subTitles,
      Map<String, String> texts,
      ShareFileType saveFormat,
      String textDirection);
}

class FileServiceImpl implements FileService {
  static Future<Map<String, dynamic>> getPrefsData() async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance

    final futures = <String, Future>{
      'difficultEvents': service.getItem(
          "userSelectionPersonalPlan-DifficultEvents",
          PersistentMemoryType.StringList),
      'makeSafer': service.getItem("userSelectionPersonalPlan-MakeSafer",
          PersistentMemoryType.StringList),
      'feelBetter': service.getItem("userSelectionPersonalPlan-FeelBetter",
          PersistentMemoryType.StringList),
      'distractions': service.getItem("userSelectionPersonalPlan-Distractions",
          PersistentMemoryType.StringList),
      'phoneNames': service.getItem(
          "PhonePageSavedPhoneNames", PersistentMemoryType.StringList),
      'phoneNumbers': service.getItem(
          "PhonePageSavedPhoneNumbers", PersistentMemoryType.StringList),
      'username': service.getItem("name", PersistentMemoryType.String),
    };

    final results = await Future.wait(futures.values);
    final data = Map.fromIterables(futures.keys, results);

    return {
      'DifficultEvents': data['difficultEvents'] ?? <String>[],
      'MakeSafer': data['makeSafer'] ?? <String>[],
      'FeelBetter': data['feelBetter'] ?? <String>[],
      'Distractions': data['distractions'] ?? <String>[],
      'phoneNames': data['phoneNames'] ?? <String>[],
      'phoneNumbers': data['phoneNumbers'] ?? <String>[],
      'username': data['username'] ?? ''
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

  static List<String> formatPhonesText(names, numbers) {
    List<String> formattedText = [];
    for (var i = 0; i < names.length; i++) {
      formattedText.add(names[i] + ':' + numbers[i]);
    }
    return formattedText;
  }

  static organizeDataForFile(List<dynamic> titles, List<dynamic> subTitles,
      Map<String, String> texts) async {
    // Set the page format to A4

    // Load the font for the PDF
    // Create a new PDF document
    final dataForPDF = await getPrefsData();
    // Retrieve user data from SharedPreferences
    List<String> difficultEvents = dataForPDF['DifficultEvents'];
    List<String> makeSafer = dataForPDF['MakeSafer'];
    List<String> feelBetter = dataForPDF['FeelBetter'];
    List<String> distractions = dataForPDF['Distractions'];
    List<String> phoneNames = dataForPDF['phoneNames'];
    List<String> phoneNumbers = dataForPDF['phoneNumbers'];
    String username = dataForPDF['username'];
    List<String> phoneDescription = formatPhonesText(phoneNames, phoneNumbers);

    List<List<String>> realData = [];
    realData = filterEmptyData([
      difficultEvents,
      makeSafer,
      feelBetter,
      distractions,
      phoneDescription
    ]);
    // Create the main title for the PDF
    String mainTitle =
        username == '' ? 'התוכנית המשולבת שלי' : 'התוכנית המשולבת של $username';

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

    // Load the logo image for the PDF

    // Create widgets for the PDF content
    return {
      "mainTitle": mainTitle,
      "realData": realData,
      "texts": {
        "text1": text1,
        "text2": text2,
        "text2Link": text2Link,
        "text3": text3,
        "text4": text4,
        "text5": text5,
        "text5Link": text5Link,
        "text6": text6
      }
    };
  }

  @override
  Future<void> share(
      String message,
      List<dynamic> titles,
      List<dynamic> subTitles,
      Map<String, String> texts,
      ShareFileType saveFormat,
      String textDirection) async {
    try {
      // Add the generated widgets to the PDF
      final dataForFile = await organizeDataForFile(titles, subTitles, texts);
      Map<String, dynamic> file;
      switch (saveFormat) {
        case ShareFileType.PDF:
          file = await createPDF(
              titles,
              subTitles,
              dataForFile["texts"]!,
              dataForFile["mainTitle"]!,
              dataForFile["realData"]!,
              textDirection);
          final tempFile = await saveTempPDF(file["file"], file["format"]);
          XFile tempXFile = XFile(tempFile.path);
          await Share.shareXFiles([tempXFile], text: message);
          break;
        default:
          file = {"file": null, "format": null};
      }

      // Save the PDF and share it
      if (file["file"] == null || file["format"] == null) {
        return;
      }
      AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
      mixPanelService.trackEvent("Plan shared");
    } catch (error, stackTrace) {
      IncidentLoggerService loggerService =
          GetIt.instance<IncidentLoggerService>();
      await loggerService.captureLog(
        error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<String?> saveAndroid(Uint8List data, String format) async {
    print(data); // Print the PDF data for debugging purposes
    try {
      // Open a save file dialog to allow the user to select a location to save the PDF
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:', // Dialog title
        fileName: 'התוכנית שלי.$format', // Default file name
        bytes: data, // PDF data to be saved
      );
      //If the user cancels the download
      AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
      mixPanelService.trackEvent("Plan downloaded Android");
      return outputFile;
    } catch (error, stackTrace) {
      IncidentLoggerService loggerService =
          GetIt.instance<IncidentLoggerService>();
      await loggerService.captureLog(
        error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  static Future<String?> saveWeb(List<int> data) async {
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
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    mixPanelService.trackEvent("Plan downloaded Web");
    return null;
  }

  @override
  Future<String?> download(
      List<dynamic> titles,
      List<dynamic> subTitles,
      Map<String, String> texts,
      ShareFileType saveFormat,
      String textDirection) async {
    final dataForFile = await organizeDataForFile(titles, subTitles, texts);
    Map<String, dynamic> file;
    Uint8List data = Uint8List(0);
    switch (saveFormat) {
      case ShareFileType.PDF:
        file = await createPDF(titles, subTitles, dataForFile["texts"]!,
            dataForFile["mainTitle"]!, dataForFile["realData"]!, textDirection);
        // Save the PDF and share it

        // Save the PDF for download
        data = await file["file"].save();

        break;
      default:
        file = {"file": null, "format": null};
    }
    if (file["file"] == null || file["format"] == null) {
      return null;
    }
    if (Platform.isAndroid) {
      return await saveAndroid(data, file["format"]);
    }
    if (kIsWeb) {
      return await saveWeb(data);
    }
    return null;
  }
}
