import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'dart:math';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Display a random Inspirational Quote
class InspirationalQuote extends StatefulWidget {
  final List<String> quotes;
  const InspirationalQuote({super.key, required this.quotes});
  @override
  _InspirationalQuoteState createState() => _InspirationalQuoteState();
}

class _InspirationalQuoteState extends LPExtendedState<InspirationalQuote> {
  bool showText = true;
  String quote = '';
  int number = 0;
  AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
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

  void _refreshQuote() {
    setState(() {
      final prevNumber = number;
      number = Random().nextInt(widget.quotes.length);
      mixPanelService.trackEvent("Inspirational Quotes Refreshed", {
        "Old Quote": widget.quotes[prevNumber],
        "New Quote": widget.quotes[number],
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final refreshIconSize = min(38.0, max(26.0, 18.sp.toDouble()));

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
                onTap: setShow,
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
                    constraints:
                        const BoxConstraints.tightFor(width: 44, height: 44),
                    padding: EdgeInsets.zero,
                    splashRadius: 22,
                    icon: Icon(
                      Icons.refresh,
                      size: refreshIconSize,
                      color: appWhite,
                    ),
                    //"refresh" button to change the quote
                    onPressed: _refreshQuote,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          (appLocale.textDirection == "rtl" ? 30.0 : 0),
                          0,
                          (appLocale.textDirection == "rtl" ? 0.0 : 30.0),
                          0),
                      child: myAutoSizedText(
                          widget.quotes[number],
                          TextStyle(
                              fontWeight: FontWeight.normal,
                              color: appWhite,
                              fontSize: 24.sp),
                          appLocale!.textDirection == "rtl"
                              ? TextAlign.right
                              : TextAlign.left,
                          24,
                          4),
                    ),
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
