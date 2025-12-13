import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

//miscaleanous styles and functions
Color pdfpurple = const Color(0x00faf6fd);
Color primaryPurple = const Color(0xFFA688F8);
Color lightGray = const Color.fromARGB(255, 231, 231, 231);
Color backgroundGray = const Color(0xFFfaf8f8);
Color darkGray = const Color(0xFF9A9EB6);
Color appGreen = const Color(0xFF01B91E);
Color appBlue = const Color(0xFF0F2851);
Color lightPurple = const Color(0xFFE3C6FF);
Color appWhite = const Color(0xFFFAF8F8);

double returnSizedBox(BuildContext context, int size) {
  if (MediaQuery.of(context).size.width < 400) {
    return size / 2;
  }

  if (MediaQuery.of(context).size.width < 500) {
    return size + 0.1;
  }
  if (MediaQuery.of(context).size.width < 600) {
    return size + 10;
  }
  return size + 20;
}

ButtonStyle myButtonStyle = TextButton.styleFrom(
  backgroundColor: primaryPurple,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);
ButtonStyle myButtonStyle3 = TextButton.styleFrom(
  backgroundColor: Colors.red,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);
TextStyle myTextStyle =
    TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

ButtonStyle myButtonStyle2 = TextButton.styleFrom(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.black,
  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);

Widget confirmationButton(
  BuildContext context,
  FutureOr<void> Function() onPressed,
  String text,
  TextStyle? buttonTextStyle,
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width > 1000
        ? 600
        : MediaQuery.of(context).size.width * 0.6,
    child: TextButton(
      onPressed: () {
        onPressed();
      },
      style: myButtonStyle,
      child: myAutoSizedText(text, buttonTextStyle, null, 50),
    ),
  );
}

Widget cancelButton(
  BuildContext context,
  FutureOr<void> Function() onPressed,
  String text,
  TextStyle? buttonTextStyle,
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width > 1000
        ? 600
        : MediaQuery.of(context).size.width * 0.6,
    child: TextButton(
      onPressed: () {
        onPressed();
      },
      style: myButtonStyle3,
      child: myAutoSizedText(text, buttonTextStyle, null, 50),
    ),
  );
}

Widget resetButton(
  BuildContext context,
  FutureOr<void> Function() onPressed,
  String text,
  TextStyle? buttonTextStyle,
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width > 1000
        ? 400
        : MediaQuery.of(context).size.width * 0.3,
    child: TextButton(
      onPressed: () {
        onPressed();
      },
      style: myButtonStyle3,
      child: myAutoSizedText(text, buttonTextStyle, null, 50),
    ),
  );
}

const emptyStyle = TextStyle();
Text myText(String content, TextStyle? style, TextAlign? align) {
  final TextStyle textStyle = (style ?? emptyStyle).copyWith(
    fontFamily: 'Rubix',
  );
  return Text(
    content,
    style: textStyle,
    textAlign: align,
  );
}

AutoSizeText myAutoSizedText(
  String content,
  TextStyle? style,
  TextAlign? align,
  double maxFontSize, [
  int maxLines = 20,
]) {
  final TextStyle textStyle = (style ?? emptyStyle).copyWith(
    fontFamily: 'Rubix',
  );
  final TextAlign textAlign = align ?? TextAlign.center;
  return AutoSizeText(
    content,
    maxFontSize: maxFontSize,
    style: textStyle,
    textAlign: textAlign,
    maxLines: maxLines == 20 ? null : maxLines,
  );
}

Image myImage(String path, BuildContext context, double width, double height) {
  final Size screensize = MediaQuery.of(context).size;

  return Image.asset(
    path,
    width: screensize.width * width, // Adjust as needed
    height: screensize.height * height, // Adjust as needed
  );
}

Widget myTextButton(
  FutureOr<void> Function() onPressed,
  IconData icon,
  Color color,
) {
  return TextButton(
    onPressed: () {
      onPressed();
    },
    child: Icon(
      icon,
      color: color,
      size: 30,
    ),
  );
}

Icon mainpageListsAddIcon = Icon(
  Icons.add,
  color: primaryPurple, // the color of the add icon
  size: 30, // the size of the add icon
);
