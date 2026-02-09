import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Phone/emergencyDialogBox.dart';
import 'package:mazilon/util/Phone/phoneTextAndIcon.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/EmergencyNumbers.dart';
import 'package:mazilon/l10n/app_localizations.dart';

enum _EmergencyScreenSize {
  compact,
  xs,
  sm,
  md,
  lg,
  xl,
}

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

class _EmergencyGridLayout {
  final int crossAxisCount;
  final double childAspectRatio;

  const _EmergencyGridLayout({
    required this.crossAxisCount,
    required this.childAspectRatio,
  });
}

class _EmergencyGridBreakpoint {
  final double minWidth;
  final _EmergencyScreenSize screenSize;

  const _EmergencyGridBreakpoint({
    required this.minWidth,
    required this.screenSize,
  });
}

const Map<_EmergencyScreenSize, _EmergencyGridLayout> _gridLayoutByScreenSize =
    {
  _EmergencyScreenSize.compact: _EmergencyGridLayout(
    crossAxisCount: 1,
    childAspectRatio: 1.8,
  ),
  _EmergencyScreenSize.xs: _EmergencyGridLayout(
    crossAxisCount: 1,
    childAspectRatio: 2.8,
  ),
  _EmergencyScreenSize.sm: _EmergencyGridLayout(
    crossAxisCount: 2,
    childAspectRatio: 1.8,
  ),
  _EmergencyScreenSize.md: _EmergencyGridLayout(
    crossAxisCount: 2,
    childAspectRatio: 2.3,
  ),
  _EmergencyScreenSize.lg: _EmergencyGridLayout(
    crossAxisCount: 2,
    childAspectRatio: 2.7,
  ),
  _EmergencyScreenSize.xl: _EmergencyGridLayout(
    crossAxisCount: 3,
    childAspectRatio: 2.8,
  ),
};

const List<_EmergencyGridBreakpoint> _gridBreakpoints = [
  _EmergencyGridBreakpoint(
    minWidth: 1600.0,
    screenSize: _EmergencyScreenSize.xl,
  ),
  _EmergencyGridBreakpoint(
    minWidth: 1400.0,
    screenSize: _EmergencyScreenSize.lg,
  ),
  _EmergencyGridBreakpoint(
    minWidth: 1000.0,
    screenSize: _EmergencyScreenSize.md,
  ),
  _EmergencyGridBreakpoint(
    minWidth: 760.0,
    screenSize: _EmergencyScreenSize.sm,
  ),
  _EmergencyGridBreakpoint(
    minWidth: 500.0,
    screenSize: _EmergencyScreenSize.xs,
  ),
];

// Extracts and returns the list of child widgets from a Row widget
List<Widget> extractChildrenFromRow(Row row) {
  return row.children;
}

// A stateless widget that displays a grid of emergency phone items
class EmergencyPhonesGrid extends StatelessWidget {
  const EmergencyPhonesGrid({super.key});

  _EmergencyGridLayout _resolveGridLayout(double screenWidth) {
    for (final breakpoint in _gridBreakpoints) {
      if (screenWidth >= breakpoint.minWidth) {
        return _gridLayoutByScreenSize[breakpoint.screenSize] ??
            _gridLayoutByScreenSize[_EmergencyScreenSize.compact]!;
      }
    }

    return _gridLayoutByScreenSize[_EmergencyScreenSize.compact]!;
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
    final typography = isWideLayout
        ? emergencyDesktopPhoneTypography
        : emergencyMobilePhoneTypography;
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
                            fontSize: typography.nameFontSize),
                        TextAlign.center,
                        typography.titleMaxFont,
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
                              fontSize: typography.descriptionFontSize),
                          TextAlign.center,
                          typography.descriptionMaxFont,
                          typography.descriptionMaxLines),
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
                            fontSize: typography.phoneFontSize,
                            decoration:
                                canCall ? TextDecoration.underline : null,
                          ),
                          TextAlign.center,
                          typography.phoneMaxFont,
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
