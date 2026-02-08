import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Phone/emergencyDialogBox.dart';
import 'package:mazilon/util/Phone/phoneTextAndIcon.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/EmergencyNumbers.dart';
import 'package:mazilon/l10n/app_localizations.dart';

// Breakpoints and sizing constants for the SOS grid on web/desktop.
const double _threeColumnMinWidth = 1600.0;
const double _wideTwoColumnMinWidth = 1400.0;
const double _standardTwoColumnMinWidth = 1000.0;
const double _tabletTwoColumnMinWidth = 760.0;
const double _singleColumnWideMinWidth = 500.0;

const int _oneColumn = 1;
const int _twoColumns = 2;
const int _threeColumns = 3;

const double _singleColumnAspectRatioCompact = 1.8;
const double _singleColumnAspectRatioWide = 2.8;
const double _twoColumnAspectRatioTablet = 1.8;
const double _twoColumnAspectRatioStandard = 2.3;
const double _twoColumnAspectRatioWide = 2.7;
const double _threeColumnAspectRatio = 2.8;

const double _gridOuterPadding = 8.0;
const double _gridItemSpacing = 12.0;
const double _cardBorderRadius = 10.0;
const double _cardBorderWidth = 1.0;
const double _cardHorizontalPadding = 10.0;
const double _cardVerticalPadding = 8.0;
const double _cardInnerHorizontalPadding = 8.0;
const double _cardInnerVerticalPadding = 6.0;
const double _cardContentSpacing = 6.0;
const double _iconBubbleSize = 30.0;
const double _iconSize = 16.0;
const Offset _iconOffset = Offset(-14, -14);

const double _desktopTypographyMinWidth = 1000.0;
const double _desktopTitleMaxFont = 28.0;
const double _mobileTitleMaxFont = 20.0;
const double _desktopDescriptionMaxFont = 22.0;
const double _mobileDescriptionMaxFont = 16.0;
const int _desktopDescriptionMaxLines = 6;
const int _mobileDescriptionMaxLines = 8;
const double _desktopNameFontSize = 22.0;
const double _mobileNameFontSize = 15.0;
const double _desktopDescriptionFontSize = 18.0;
const double _mobileDescriptionFontSize = 13.0;
const double _desktopPhoneFontSize = 18.0;
const double _mobilePhoneFontSize = 14.0;
const double _desktopPhoneMaxFont = 24.0;
const double _mobilePhoneMaxFont = 20.0;

class _EmergencyGridLayout {
  final int crossAxisCount;
  final double childAspectRatio;

  const _EmergencyGridLayout({
    required this.crossAxisCount,
    required this.childAspectRatio,
  });
}

// Extracts and returns the list of child widgets from a Row widget
List<Widget> extractChildrenFromRow(Row row) {
  return row.children;
}

// A stateless widget that displays a grid of emergency phone items
class EmergencyPhonesGrid extends StatelessWidget {
  const EmergencyPhonesGrid({super.key});

  _EmergencyGridLayout _resolveGridLayout(double screenWidth) {
    if (screenWidth >= _threeColumnMinWidth) {
      return const _EmergencyGridLayout(
        crossAxisCount: _threeColumns,
        childAspectRatio: _threeColumnAspectRatio,
      );
    }
    if (screenWidth >= _wideTwoColumnMinWidth) {
      return const _EmergencyGridLayout(
        crossAxisCount: _twoColumns,
        childAspectRatio: _twoColumnAspectRatioWide,
      );
    }
    if (screenWidth >= _standardTwoColumnMinWidth) {
      return const _EmergencyGridLayout(
        crossAxisCount: _twoColumns,
        childAspectRatio: _twoColumnAspectRatioStandard,
      );
    }
    if (screenWidth >= _tabletTwoColumnMinWidth) {
      return const _EmergencyGridLayout(
        crossAxisCount: _twoColumns,
        childAspectRatio: _twoColumnAspectRatioTablet,
      );
    }
    if (screenWidth >= _singleColumnWideMinWidth) {
      return const _EmergencyGridLayout(
        crossAxisCount: _oneColumn,
        childAspectRatio: _singleColumnAspectRatioWide,
      );
    }

    return const _EmergencyGridLayout(
      crossAxisCount: _oneColumn,
      childAspectRatio: _singleColumnAspectRatioCompact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInformation>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final gridLayout = _resolveGridLayout(screenWidth);
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
      padding: const EdgeInsets.all(_gridOuterPadding),
      child: GridView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridLayout.crossAxisCount,
          crossAxisSpacing: _gridItemSpacing,
          mainAxisSpacing: _gridItemSpacing,
          childAspectRatio: gridLayout.childAspectRatio,
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
    final isWideLayout = screenWidth >= _desktopTypographyMinWidth;
    final titleMaxFont =
        isWideLayout ? _desktopTitleMaxFont : _mobileTitleMaxFont;
    final descriptionMaxFont =
        isWideLayout ? _desktopDescriptionMaxFont : _mobileDescriptionMaxFont;
    final descriptionMaxLines =
        isWideLayout ? _desktopDescriptionMaxLines : _mobileDescriptionMaxLines;
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
        padding: const EdgeInsets.symmetric(
            horizontal: _cardHorizontalPadding, vertical: _cardVerticalPadding),
        decoration: BoxDecoration(
          border: Border.all(color: primaryPurple, width: _cardBorderWidth),
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardBorderRadius),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _cardInnerHorizontalPadding,
                vertical: _cardInnerVerticalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: myAutoSizedText(
                        number["name"],
                        TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.w800,
                            fontSize: isWideLayout
                                ? _desktopNameFontSize
                                : _mobileNameFontSize),
                        TextAlign.center,
                        titleMaxFont,
                        2),
                  ),
                  const SizedBox(height: _cardContentSpacing),
                  Expanded(
                    child: Center(
                      child: myAutoSizedText(
                          descriptionText.replaceAll(
                              '/', '\n'), // Replace '/' with newline
                          TextStyle(
                              fontWeight: FontWeight.w700,
                              color: primaryPurple,
                              fontSize: isWideLayout
                                  ? _desktopDescriptionFontSize
                                  : _mobileDescriptionFontSize),
                          TextAlign.center,
                          descriptionMaxFont,
                          descriptionMaxLines),
                    ),
                  ),
                  if (phoneNumber.isNotEmpty) ...[
                    const SizedBox(height: _cardContentSpacing),
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
                            fontSize: isWideLayout
                                ? _desktopPhoneFontSize
                                : _mobilePhoneFontSize,
                            decoration:
                                canCall ? TextDecoration.underline : null,
                          ),
                          TextAlign.center,
                          isWideLayout
                              ? _desktopPhoneMaxFont
                              : _mobilePhoneMaxFont,
                          1),
                    ),
                  ],
                ],
              ),
            ),
            Transform.translate(
              offset: _iconOffset,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: _iconBubbleSize,
                  height: _iconBubbleSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryPurple, width: 1),
                    color: primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    number['icon'],
                    color: Colors.white,
                    size: _iconSize,
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
