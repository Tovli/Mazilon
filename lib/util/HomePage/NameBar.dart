import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Widget for the name of the user in the home page
class NameBar extends StatefulWidget {
  final List<Widget> icons;

  final String greetingString;
  const NameBar({
    super.key,
    required this.icons,
    required this.greetingString,
  });

  @override
  State<NameBar> createState() => NameBarState();
}

class NameBarState extends State<NameBar> {
  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInformation>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width > 1000
          ? 800
          : MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    myAutoSizedText(
                        AppLocalizations.of(context)!
                            .greetings(userInfoProvider.name),
                        TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        null,
                        40),
                  ],
                ),
                Row(children: widget.icons),
              ],
            ),
            myAutoSizedText(
                widget.greetingString,
                TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: darkGray),
                null,
                30),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}
