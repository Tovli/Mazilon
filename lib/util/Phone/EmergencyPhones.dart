import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Phone/emergencyDialogBox.dart';
import 'package:mazilon/util/Phone/phoneTextAndIcon.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/EmergencyNumbers.dart';
import 'package:mazilon/l10n/app_localizations.dart';

// Extracts and returns the list of child widgets from a Row widget
List<Widget> extractChildrenFromRow(Row row) {
  return row.children;
}

// A stateless widget that displays a grid of emergency phone items
class EmergencyPhonesGrid extends StatelessWidget {
  const EmergencyPhonesGrid({super.key});

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1600) return 3;
    if (screenWidth >= 760) return 2;
    return 1;
  }

  double _getChildAspectRatio(double screenWidth, int crossAxisCount) {
    if (crossAxisCount == 1) {
      return screenWidth >= 500 ? 2.8 : 1.8;
    }
    if (crossAxisCount == 3) {
      return 2.8;
    }
    if (screenWidth >= 1400) return 2.7;
    if (screenWidth >= 1000) return 2.3;
    return 1.8;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInformation>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    String countryCode = userInfo.location.trim();
    if (countryCode.isEmpty) {
      countryCode = Localizations.localeOf(context).countryCode ??
          defaultPickerCountry.countryCodes.first;
    }

    final Country? country = findCountryByCode(countryCode);
    if (country == null) {
      debugPrint(
          'No emergency mapping for countryCode="$countryCode". Using default "${defaultEmergencyCountry.id}".');
    }
    final localNumbers = (country ?? defaultEmergencyCountry).emergencyNumbers;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // Number of columns in the grid
          crossAxisSpacing: 12.0, // Horizontal spacing between items
          mainAxisSpacing: 12.0, // Vertical spacing between items
          childAspectRatio: _getChildAspectRatio(screenWidth, crossAxisCount),
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
    final appLocale = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideLayout = screenWidth >= 1000;
    final titleMaxFont = isWideLayout ? 28.0 : 20.0;
    final descriptionMaxFont = isWideLayout ? 22.0 : 16.0;
    final descriptionMaxLines = isWideLayout ? 6 : 8;
    final String phoneNumber = (number["number"] ?? '').toString().trim();
    final bool canCall = number["canCall"] == true && phoneNumber.isNotEmpty;
    final bool hasWhatsApp = number["whatsapp"] == true;
    final bool hasLink = (number["link"] ?? '').toString().trim().isNotEmpty;
    final bool hasAnyAction = canCall || hasWhatsApp || hasLink;
    final isRtl = appLocale?.textDirection == "rtl";
    final descriptionText = isRtl
        ? (number["descriptionHe"] ?? number["description"] ?? '')
        : (number["description"] ?? '');
    return InkWell(
      onTap: hasAnyAction
          ? () async {
              // Directly dial call-only numbers. Keep dialog for multi-action entries.
              if (canCall && !hasWhatsApp && !hasLink) {
                await dialPhone(phoneNumber);
                return;
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EmergencyDialogBox(
                    number: number["number"],
                    whatsappNumber:
                        number["whatsappNumber"] ?? number["number"],
                    link: number["link"],
                    hasWhatsApp: number["whatsapp"],
                    hasLink: number["link"] != "",
                    canCall: number["canCall"],
                  );
                },
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: primaryPurple, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: myAutoSizedText(
                        number["name"],
                        TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.w800,
                            fontSize: isWideLayout ? 22 : 15),
                        TextAlign.center,
                        titleMaxFont,
                        2),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Center(
                      child: myAutoSizedText(
                          descriptionText.replaceAll(
                              '/', '\n'), // Replace '/' with newline
                          TextStyle(
                              fontWeight: FontWeight.w700,
                              color: primaryPurple,
                              fontSize: isWideLayout ? 18 : 13),
                          TextAlign.center,
                          descriptionMaxFont,
                          descriptionMaxLines),
                    ),
                  ),
                  if (phoneNumber.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: canCall
                          ? () async {
                              await dialPhone(phoneNumber);
                            }
                          : null,
                      child: myAutoSizedText(
                          phoneNumber,
                          TextStyle(
                            fontWeight: FontWeight.w800,
                            color: primaryPurple,
                            fontSize: isWideLayout ? 18 : 14,
                            decoration:
                                canCall ? TextDecoration.underline : null,
                          ),
                          TextAlign.center,
                          isWideLayout ? 24 : 20,
                          1),
                    ),
                  ],
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(-14, -14), // Adjust the position of the icon
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryPurple, width: 1),
                    color: primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    number['icon'],
                    color: Colors.white,
                    size: 16,
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
