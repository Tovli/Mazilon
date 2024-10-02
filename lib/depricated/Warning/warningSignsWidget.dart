import 'package:flutter/material.dart';

import 'package:mazilon/depricated/Warning/warningsContainer.dart';

class WarningSignsWidget extends StatefulWidget {
  final List<String> warnings;
  final Function add;
  final String warningMainTitle;
  final String warningSubTitle;
  const WarningSignsWidget(
      {super.key,
      required this.warnings,
      required this.add,
      required this.warningMainTitle,
      required this.warningSubTitle});

  @override
  State<WarningSignsWidget> createState() => _WarningSignsWidgetState();
}

class _WarningSignsWidgetState extends State<WarningSignsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
          /*SectionBarHome(
                text: widget.warningMainTitle,
                textWidget: Container(),
                icon: Icons.warning,
                icons: [],
                subHeader: widget.warningSubTitle),*/
            SizedBox(
              height: 10,
            ),
            WarningsContainer(warnings: widget.warnings, add: widget.add),
          ],
        ),
      ),
    );
  }
}
