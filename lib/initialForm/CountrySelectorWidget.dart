import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CountrySelectorWidget extends StatefulWidget {
  final String text;
  final String disclaimerText;

  const CountrySelectorWidget(
      {Key? key, required this.text, required this.disclaimerText})
      : super(key: key);

  @override
  _CountrySelectorWidgetState createState() => _CountrySelectorWidgetState();
}

class _CountrySelectorWidgetState extends State<CountrySelectorWidget> {
  String? _selectedCountryCode = 'IL';
  bool isvisible = false;
  void saveLocation(String location, UserInformation userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("location", location);
    userInfo.updateLocation(location);
  }

  void changeVisible() {
    print("pressed");
    setState(() {
      isvisible = !isvisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInformation>(context);
    final appLocale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300.w),
          child: Row(
            children: [
              myAutoSizedText(
                  widget.text,
                  TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                  null,
                  24),
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
        CountryCodePicker(
          onChanged: (country) {
            setState(() {
              _selectedCountryCode = country.code;
              saveLocation(country.code!, userInfoProvider);
            });
          },
          initialSelection: userInfoProvider.location.isNotEmpty
              ? userInfoProvider.location
              : 'IL',
          // favorite: ['+972', 'IL'],
          showCountryOnly: true,
          showOnlyCountryWhenClosed: true,
          alignLeft: false,
          countryFilter: ['IL', 'US'],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              appLocale!.textDirection == "rtl" ? 0 : 0.w,
              0,
              appLocale!.textDirection == "rtl" ? 0.w : 00,
              0),
          child: Visibility(
              visible: isvisible,
              child: GestureDetector(
                onTap: () {
                  changeVisible();
                },
                child: Container(
                    alignment: appLocale!.textDirection == "rtl"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
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
                    width: 300.w,
                    height: 50.h,
                    child: Text(widget.disclaimerText)),
              )),
        )
      ],
    );
  }
}
