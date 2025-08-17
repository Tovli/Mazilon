import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';

class LPAlertDialogBoxItem extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final IconData icon;

  const LPAlertDialogBoxItem({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    required this.icon,
  }) : super(key: key);
  press() async {
    await onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: lightGray,
      ),
      margin: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10.0),
          Icon(icon, color: Colors.black, size: 30.sp),
          TextButton(
            onPressed: press,
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.black, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }
}
