import 'package:flutter/material.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

class ShowAllWidget extends StatefulWidget {
  final Function(BuildContext, PagesCode) onTabTapped;
  final PagesCode pageCode;
  const ShowAllWidget({
    Key? key,
    required this.onTabTapped,
    required this.pageCode,
  }) : super(key: key);

  @override
  State<ShowAllWidget> createState() => _ShowAllWidgetState();
}

class _ShowAllWidgetState extends LPExtendedState<ShowAllWidget> {
  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);

    final gender = userInfoProvider.gender;
    return Row(
      children: [
        TextButton(
          onPressed: () {
            widget.onTabTapped(context, widget.pageCode);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                appLocale.showAll(gender),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
