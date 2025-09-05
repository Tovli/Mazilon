import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
// import your own styles/widgets
import 'package:mazilon/util/styles.dart';

/// Row with a phone icon and the contact name.
Widget phoneContact(String phone, String contact) {
  return Row(
    children: <Widget>[
      Semantics(
        button: true,
        label: 'Call $contact',
        child: Tooltip(
          message: 'Call',
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => dialPhone(phone),
            child: CircleAvatar(
              radius: 20, // ≥ 48px diameter tap target
              backgroundColor: primaryPurple,
              foregroundColor: appWhite,
              child: const Icon(Icons.phone, size: 20),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Card(
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: myAutoSizedText(
              contact,
              TextStyle(fontWeight: FontWeight.normal, fontSize: 20.sp),
              null,
              30,
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> dialPhone(String number) async {
  final sanitized = number.trim();
  final uri = Uri(scheme: 'tel', path: sanitized);
  debugPrint('Dialing $uri');

  if (await canLaunchUrl(uri)) {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) debugPrint('Could not launch $uri');
  } else {
    debugPrint('Cannot handle $uri');
    throw 'Could not launch $uri';
  }
}

Future<void> openWhatsApp(String number) async {
  // WhatsApp expects E.164 without '+', spaces or dashes, e.g. 15551234567
  final e164NoPlus = number.replaceAll(RegExp(r'[^\d]'), ''); // keep digits only
  if (e164NoPlus.isEmpty) {
    debugPrint('Invalid WhatsApp number: "$number"');
    return;
  }

  final uri = Uri.parse('https://wa.me/$e164NoPlus');
  if (await canLaunchUrl(uri)) {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) debugPrint('Could not launch $uri');
  } else {
    debugPrint('Cannot handle $uri');
  }
}

Future<void> openSite(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) {
    debugPrint('Invalid URL: $url');
    return;
  }

  // Choose one:
  // - External browser:
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  // - Or in-app web view (uncomment instead):
  // final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);

  if (!ok) debugPrint('Could not launch $uri');
}

/// Text + circular icon button (typed callback).
Widget getTextIconWidget(
  String text,
  VoidCallback onClick,
  IconData icon,
) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      myText(
        text,
        TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: (18.sp > 35 ? 35 : 20.sp),
        ),
        null,
      ),
      const SizedBox(width: 5.0),
      Semantics(
        button: true,
        label: text,
        child: Tooltip(
          message: text,
          child: GestureDetector(
            onTap: onClick,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
              child: Icon(icon, size: 20),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
    ],
  );
}