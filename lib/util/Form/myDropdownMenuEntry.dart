import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//this is the widget we use in the drop down menu for age selection
DropdownMenuEntry<String> buildDropdownMenuEntry(text, backgroundColor) {
  return DropdownMenuEntry(
      value: text,
      label: text,
      labelWidget: Container(
        child: myText(
            text,
            TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 16.sp > 25 ? 25 : 16.sp),
            null),
      ),
      style: MenuItemButton.styleFrom(foregroundColor: backgroundColor));
}
