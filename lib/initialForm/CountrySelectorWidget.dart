import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'package:mazilon/EmergencyNumbers.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/userInformation.dart';

import 'package:provider/provider.dart';

class CountrySelectorWidget extends StatefulWidget {
  final String text;
  final String disclaimerText;
  final bool centerContent;

  const CountrySelectorWidget(
      {Key? key,
      required this.text,
      required this.disclaimerText,
      this.centerContent = false})
      : super(key: key);

  @override
  _CountrySelectorWidgetState createState() => _CountrySelectorWidgetState();
}

class _CountrySelectorWidgetState
    extends LPExtendedState<CountrySelectorWidget> {
  bool isVisible = false;
  bool _didInitLocation = false;

  double _getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1000) {
      return 360;
    }
    return (screenWidth * 0.9).clamp(280.0, 340.0).toDouble();
  }

  String resolveCountryCode(String? currentLocation, BuildContext context) {
    final normalizedLocation = (currentLocation ?? '').trim().toUpperCase();
    if (normalizedLocation.isNotEmpty) {
      return normalizedLocation;
    }

    final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final platformCode =
        (platformLocale.countryCode ?? '').trim().toUpperCase();
    if (platformCode.isNotEmpty && countryPickerCodes.contains(platformCode)) {
      return platformCode;
    }

    final localeCode = Localizations.localeOf(context).countryCode ?? '';
    final normalizedLocale = localeCode.trim().toUpperCase();
    if (normalizedLocale.isNotEmpty &&
        countryPickerCodes.contains(normalizedLocale)) {
      return normalizedLocale;
    }

    return defaultPickerCountry.countryCodes.first;
  }

  void saveLocation(String location, UserInformation userInfo) async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance
    final normalizedLocation = location.trim().toUpperCase();
    await service.setItem(
        "location", PersistentMemoryType.String, normalizedLocation);
    userInfo.updateLocation(normalizedLocation);
  }

  void changeVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitLocation) {
      return;
    }

    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    if (userInfoProvider.location.isEmpty) {
      saveLocation(resolveCountryCode('', context), userInfoProvider);
    }
    _didInitLocation = true;
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInformation>(context);
    final initialCountryCode =
        resolveCountryCode(userInfoProvider.location, context);
    final contentWidth = _getContentWidth(context);
    final rightPadding = appLocale.textDirection == "rtl" ? 10.0 : 0.0;
    final leftPadding = appLocale.textDirection == "rtl" ? 0.0 : 10.0;
    final titleAlign = widget.centerContent
        ? TextAlign.center
        : (appLocale.textDirection == "rtl" ? TextAlign.right : TextAlign.left);
    return Column(
      crossAxisAlignment: widget.centerContent
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidth),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: myAutoSizedText(
                    widget.text,
                    TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    titleAlign,
                    24),
              ),
              TextButton(
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 8.w)),
                      iconColor: WidgetStatePropertyAll(
                        Colors.black,
                      ),
                      overlayColor: WidgetStatePropertyAll(backgroundGray)),
                  onPressed: changeVisible,
                  child: Icon(
                    Icons.question_mark,
                    size: 12.sp,
                  ))
            ],
          ),
        ),
        Container(
          width: contentWidth,
          height: 70,
          padding: widget.centerContent
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
              : EdgeInsets.fromLTRB(rightPadding, 12, leftPadding, 12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  spreadRadius: 1,
                  blurRadius: 0,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(8.r),
              color: backgroundGray),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CountryCodePicker(
                  showDropDownButton: false, // Remove the default button
                  showFlag: true,
                  showFlagDialog: true,
                  showFlagMain: true,
                  onChanged: (country) {
                    setState(() {
                      saveLocation(country.code!, userInfoProvider);
                    });
                  },
                  initialSelection: initialCountryCode,
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                  alignLeft: !widget.centerContent,
                  countryFilter: countryPickerCodes,
                  padding: EdgeInsets.zero, // Remove internal padding
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 24,
              ),
            ],
          ),
        ),
        Visibility(
            visible: isVisible,
            child: GestureDetector(
              onTap: () {
                changeVisible();
              },
              child: Container(
                  alignment: appLocale.textDirection == "rtl"
                      ? (widget.centerContent
                          ? Alignment.center
                          : Alignment.centerRight)
                      : (widget.centerContent
                          ? Alignment.center
                          : Alignment.centerLeft),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: Colors.black, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  width: contentWidth,
                  constraints: const BoxConstraints(minHeight: 50),
                  child: Text(
                    widget.disclaimerText,
                    textAlign: widget.centerContent
                        ? TextAlign.center
                        : (appLocale.textDirection == "rtl"
                            ? TextAlign.right
                            : TextAlign.left),
                  )),
            ))
      ],
    );
  }
}
