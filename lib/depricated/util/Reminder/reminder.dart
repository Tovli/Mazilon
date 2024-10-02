import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:mazilon/util/styles.dart';

class Reminder extends StatefulWidget {
  final String text;
  final List<Icon> icon;
  const Reminder({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 75,
      height: 80,
      decoration: BoxDecoration(
        color: appWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...widget.icon,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 130,
                  height: 60,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: AutoSizeText(
                      widget.text,
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontFamily: 'Rubix'),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
