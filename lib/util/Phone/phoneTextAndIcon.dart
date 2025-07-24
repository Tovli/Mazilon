import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

Widget phoneContact(phone, contact) {
  return Row(
    children: <Widget>[
      InkWell(
        onTap: () async {
          await dialPhone(phone);
        },
        child: CircleAvatar(
          radius: 20, // adjust as needed
          backgroundColor: primaryPurple,
          foregroundColor: appWhite,
          child: const Icon(Icons.phone, size: 20), // adjust as needed
        ),
      ),
      const SizedBox(width: 10.0), // adjust as needed
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: myAutoSizedText(
                contact,
                TextStyle(fontWeight: FontWeight.normal, fontSize: 20.sp),
                null,
                30), // present the contacts from myContacts list
          ),
        ),
      ),
    ],
  );
}

Future<void> dialPhone(String number) async {
  String url = 'tel:$number';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> openWhatsApp(String number) async {
  String url = 'https://wa.me/$number';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    debugPrint('Could not launch $url');
  }
}

Future<void> openSite(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    debugPrint('Could not launch $url');
  }
}

Widget getTextIconWidget(
  String text,
  Function onClick,
  IconData icon,
) {
  return SizedBox(
      child: Row(
    children: [
      myText(
          text,
          TextStyle(
              fontWeight: FontWeight.normal, fontSize: 18.sp > 35 ? 35 : 20.sp),
          null),
      SizedBox(width: 5.0),
      // Button to make a phone call
      GestureDetector(
        child: CircleAvatar(
          radius: 20, // adjust as needed
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          child: Icon(icon, size: 20), // adjust as needed
        ),
        onTap: () async {
          onClick();
        },
      ),
      SizedBox(width: 10.0),
    ],
  ));
}
