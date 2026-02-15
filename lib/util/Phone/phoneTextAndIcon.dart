import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

@visibleForTesting
bool? debugPhoneDialingSupportedOverride;

bool get isPhoneDialingSupported =>
    debugPhoneDialingSupportedOverride ?? !kIsWeb;

Future<bool> _launchWithFallback(Uri uri) async {
  try {
    var launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
    return launched;
  } catch (e) {
    debugPrint('Could not launch $uri');
    debugPrint(e.toString());
    return false;
  }
}

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
  if (!isPhoneDialingSupported) {
    debugPrint('Phone dialing is not supported on this platform.');
    return;
  }

  final normalized = number.replaceAll(RegExp(r'\s+'), '').trim();
  if (normalized.isEmpty) {
    return;
  }

  final uri = Uri.parse('tel:$normalized');
  final launched = await _launchWithFallback(uri);
  if (!launched) {
    debugPrint('Could not launch $uri');
  }
}

Future<void> openWhatsApp(String number) async {
  final normalized = number.replaceAll(RegExp(r'\s+'), '').trim();
  if (normalized.isEmpty) {
    return;
  }

  final uri = Uri.parse('https://wa.me/$normalized');
  final launched = await _launchWithFallback(uri);
  if (!launched) {
    debugPrint('Could not launch $uri');
  }
}

Future<void> openSite(String url) async {
  final trimmedUrl = url.trim();
  if (trimmedUrl.isEmpty) {
    return;
  }

  final hasExplicitScheme = trimmedUrl.contains('://');
  final uri = Uri.tryParse(
    hasExplicitScheme ? trimmedUrl : 'https://$trimmedUrl',
  );
  if (uri == null ||
      uri.host.isEmpty ||
      (!uri.isScheme('https') && !uri.isScheme('http'))) {
    debugPrint('Could not launch invalid url: $url');
    return;
  }

  final launched = await _launchWithFallback(uri);
  if (!launched) {
    debugPrint('Could not launch $uri');
  }
}

Widget getTextIconWidget(
  String text,
  Future<void> Function() onClick,
  IconData icon,
) {
  return InkWell(
    borderRadius: BorderRadius.circular(24),
    onTap: () async {
      await onClick();
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        myText(
            text,
            TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18.sp > 35 ? 35 : 20.sp),
            null),
        SizedBox(width: 5.0),
        CircleAvatar(
          radius: 20,
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          child: Icon(icon, size: 20),
        ),
        SizedBox(width: 10.0),
      ],
    ),
  );
}
