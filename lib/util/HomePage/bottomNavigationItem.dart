import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/styles.dart';

//Item for the bottom Navigation in the home page
Widget bottomNavigationItem(current, icon, text) {
  Color color = current ? primaryPurple : darkGray;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Icon(
          icon,
          color: color,
        ),
      ),
      Expanded(
        child: myAutoSizedText(
            text,
            TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 14.sp),
            null,
            25),
      )
    ],
  );
}
