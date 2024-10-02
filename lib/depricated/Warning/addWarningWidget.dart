// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/depricated/Warning/warningForm.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWarningWidget extends StatefulWidget {
  final Function add;
  const AddWarningWidget({super.key, required this.add});

  @override
  State<AddWarningWidget> createState() => _AddWarningWidgetState();
}

class _AddWarningWidgetState extends State<AddWarningWidget> {
  void addWarning() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WarningForm(add: widget.add);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 50,
      child: GestureDetector(
        onTap: addWarning,
        child: Card(
          color: appGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.add, size: 20, color: Colors.white),
                  myText(
                    'כתוב סימן משלך',
                    TextStyle(
                      color: Colors.white,
                      fontSize: 6.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
