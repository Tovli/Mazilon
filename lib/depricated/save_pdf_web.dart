import 'dart:html' as html;

// Function to save a PDF file in a web environment
Future<void> savePdf(List<int> pdfData) async {
  // Create a Blob object from the PDF data
  final blob = html.Blob([pdfData], 'application/pdf');

  // Generate a URL for the Blob object
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create an anchor element and set its href attribute to the Blob URL
  final anchor = html.AnchorElement(href: url)
  // Set the download attribute with the desired file name
    ..setAttribute('download', 'MyPlan.pdf')
  // Trigger a click on the anchor element to start the download
    ..click();
}
