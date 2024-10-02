import 'dart:io';
import 'dart:math';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

// Function to save a PDF file in android (tested)
Future<void> savePdf(Uint8List pdfData) async {
  print(pdfData); // Print the PDF data for debugging purposes
  try {
    // Open a save file dialog to allow the user to select a location to save the PDF
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:', // Dialog title
      fileName: 'התוכנית שלי.pdf', // Default file name
      bytes: pdfData, // PDF data to be saved
    );
    //If the user cancels the download
    if (outputFile == null) {
      // Show him a message
      showToast(message: 'ההורדה בוטלה');
      return;
    }
    // Show a toast message to the user
    showToast(message: 'הקובץ שלך ירד');
  } catch (e) {
    print('Error: $e');
  }
}
