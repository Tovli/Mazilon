import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/Phone/emergencyDialogBox.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/EmergencyNumbers.dart';
import 'dart:io';

// Extracts and returns the list of child widgets from a Row widget
List<Widget> extractChildrenFromRow(Row row) {
  return row.children;
}

// A stateless widget that displays a grid of emergency phone items
class EmergencyPhonesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final String defaultLocale =
        Platform.localeName; // Returns locale string in the form 'en_US'
    String countryCode = defaultLocale.substring(defaultLocale.length - 2);

    final localNumbers = countryCode == "IL" || appLocale!.language == "עברית"
        ? numbers["israel"]
        : numbers["usa"];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Horizontal spacing between items
          mainAxisSpacing: 10.0, // Vertical spacing between items
        ),
        itemCount: localNumbers.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          return EmergencyPhoneItem(
            i: index,
            number: localNumbers[index],
          );
        },
      ),
    );
  }
}

// A custom widget representing an emergency phone item in the grid
class EmergencyPhoneItem extends StatelessWidget {
  final int i; // Index of the emergency phone item

  final dynamic number;
  const EmergencyPhoneItem({required this.i, required this.number, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Display a dialog when the item is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EmergencyDialogBox(
              number: number["number"],
              link: number["link"],
              hasWhatsApp: number["whatsapp"],
              hasLink: number["link"] != "",
              canCall: number["canCall"],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: primaryPurple, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: myAutoSizedText(
                        number["name"],
                        TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp),
                        TextAlign.center,
                        40),
                  ),
                  Center(
                    child: myAutoSizedText(
                        number["description"]
                            .replaceAll('/', '\n'), // Replace '/' with newline
                        TextStyle(
                            fontWeight: FontWeight.normal,
                            color: primaryPurple,
                            fontSize: 14.sp),
                        TextAlign.center,
                        30),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(-20, -20), // Adjust the position of the icon
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryPurple, width: 1),
                    color: primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    number['icon'],
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
