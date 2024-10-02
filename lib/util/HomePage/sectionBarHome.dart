import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/styles.dart';

//Template for the "title" of sections in the home page
//i.e "התוכנית שלי", "רשימת מעלות", "תודו ליסט"
//specifically, the titles in the home page
class SectionBarHome extends StatefulWidget {
  final Widget textWidget; // what's the title
  final IconData icon; // the icon next to the title
  final List<Widget>
      icons; //icons to interact with on the left side of the section
  final String subHeader; //what's the subtitle
  const SectionBarHome({
    super.key,
    required this.textWidget,
    required this.icon,
    required this.icons,
    required this.subHeader,
  });

  @override
  State<SectionBarHome> createState() => SectionBarHomeState();
}

class SectionBarHomeState extends State<SectionBarHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: widget.icons),
            Row(
              children: [
                widget.textWidget,
                Icon(
                  widget.icon,
                  color: Colors.black,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
        widget.subHeader.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 5),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: myAutoSizedText(
                      widget.subHeader,
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: darkGray,
                      ),
                      TextAlign.right,
                      30),
                ),
              )
            : Container(),
      ],
    );
  }
}
