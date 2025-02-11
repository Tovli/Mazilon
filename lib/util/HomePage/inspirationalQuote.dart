import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Display a random Inspirational Quote
class InspirationalQuote extends StatefulWidget {
  final List<String> quotes;
  const InspirationalQuote({super.key, required this.quotes});
  @override
  _InspirationalQuoteState createState() => _InspirationalQuoteState();
}

class _InspirationalQuoteState extends State<InspirationalQuote> {
  bool showText = true;
  String quote = '';
  int number = 0;
  //Let the user close the window
  void setShow() {
    {
      setState(() {
        showText = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //decide which quote to show

    number = Random().nextInt(widget.quotes.length);
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    return Visibility(
      visible: showText,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryPurple,
        ),
        width: MediaQuery.of(context).size.width > 1000
            ? 800
            : MediaQuery.of(context).size.width,
        height: 120,
        child: Stack(
          children: [
            Positioned(
              top: 5, // Adjust the position as needed
              left: appLocale!.textDirection == "rtl" ? 5 : null,
              right: appLocale!.textDirection == "rtl" ? null : 5,

              child: GestureDetector(
                onTap: () {
                  setShow();
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                  child: Icon(Icons.close),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 35,
                      color: appWhite,
                    ),
                    //"refresh" button to change the quote
                    onPressed: () {
                      setState(() {
                        number = Random().nextInt(widget.quotes.length);
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: myAutoSizedText(
                        widget.quotes[number],
                        TextStyle(
                            fontWeight: FontWeight.normal,
                            color: appWhite,
                            fontSize: 26.sp),
                        appLocale!.textDirection == "rtl"
                            ? TextAlign.right
                            : TextAlign.left,
                        26,
                        2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
