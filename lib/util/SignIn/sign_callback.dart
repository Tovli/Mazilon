import 'package:flutter/material.dart';
import 'package:mazilon/initialForm/form.dart';

// Function to handle the callback after an operation (e.g., sign-in or sign-up)
void callback(result, widget, context) {
  // If the result is successful (result is true)
  if (result) {
    // Navigate to the InitialFormProgressIndicator page, removing all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => InitialFormProgressIndicator(
          collections: widget.collections, // Pass collections data to the next page
          collectionNames: widget.collectionNames, // Pass collection names to the next page
          checkboxModels: widget.checkboxModels, // Pass checkbox models to the next page
          phonePageData: widget.phonePageData, // Pass phone page data to the next page
        ),
      ),
          (route) => false, // Remove all previous routes from the stack
    );
  }
}
