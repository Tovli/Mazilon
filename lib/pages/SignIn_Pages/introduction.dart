import 'package:flutter/material.dart';

import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Introduction widget serves as an initial loading screen or introduction page.
class Introduction extends StatefulWidget {
  final Widget?
      child; // Optional child widget that can be passed to this screen
  const Introduction({super.key, this.child});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final appLocale = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying a welcome message in Hebrew with custom styling
            myAutoSizedText(
                appLocale!.introductionRestartGreeting(
                    userInfoProvider.gender), // Welcome message in Hebrew
                TextStyle(
                  fontSize: 40.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                null,
                100),
            const SizedBox(height: 20.0),
            // Displaying a large circular progress indicator (spinner)
            const SizedBox(
              height: 300,
              width: 300,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
