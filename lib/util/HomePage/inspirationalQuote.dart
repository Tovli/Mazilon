import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setShow();
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(4, 4, 0, 10),
                    child: Icon(Icons.close),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: myAutoSizedText(
                        widget.quotes[number],
                        TextStyle(
                            fontWeight: FontWeight.normal,
                            color: appWhite,
                            fontSize: 26.sp),
                        TextAlign.right,
                        26,
                        2),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
