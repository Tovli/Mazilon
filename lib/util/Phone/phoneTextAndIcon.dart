import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

Widget phoneContact(String phone, String contact) {
  final trimmedPhone = phone.trim();
  final displayName = contact.trim().isEmpty ? trimmedPhone : contact.trim();

  return Row(
    children: <Widget>[
      InkWell(
        onTap: () async {
          await dialPhone(trimmedPhone);
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
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            await dialPhone(trimmedPhone);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myAutoSizedText(
                      displayName,
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
                      TextAlign.left,
                      26,
                      2),
                  if (trimmedPhone.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    myAutoSizedText(
                        trimmedPhone,
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: primaryPurple),
                        TextAlign.left,
                        22,
                        1),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> dialPhone(String number) async {
  final normalized = number.replaceAll(RegExp(r'\s+'), '').trim();
  if (normalized.isEmpty) {
    return;
  }

  final uri = Uri.parse('tel:$normalized');
  try {
    var launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      launched = await launchUrl(uri, webOnlyWindowName: '_self');
    }

    if (!launched) {
      debugPrint('Could not launch $uri');
    }
  } catch (e) {
    debugPrint('Could not launch $uri');
    debugPrint(e.toString());
  }
}

Future<void> openWhatsApp(String number) async {
  final normalized = number.replaceAll(RegExp(r'\s+'), '').trim();
  final uri = Uri.parse('https://wa.me/$normalized');
  try {
    var launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      launched = await launchUrl(uri, webOnlyWindowName: '_blank');
    }

    if (!launched) {
      debugPrint('Could not launch $uri');
    }
  } catch (e) {
    debugPrint('Could not launch $uri');
    debugPrint(e.toString());
  }
}

Future<void> openSite(String url) async {
  final uri = Uri.parse(url);
  try {
    var launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      launched = await launchUrl(uri, webOnlyWindowName: '_blank');
    }

    if (!launched) {
      debugPrint('Could not launch $uri');
    }
  } catch (e) {
    debugPrint('Could not launch $uri');
    debugPrint(e.toString());
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
