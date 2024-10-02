// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'package:mazilon/depricated/Warning/addWarningWidget.dart';
import 'package:mazilon/depricated/Warning/warningSuggestion.dart';
import 'package:mazilon/depricated/Warning/warningItem.dart';

class WarningsContainer extends StatefulWidget {
  final List<String> warnings;
  final Function add;
  const WarningsContainer(
      {super.key, required this.warnings, required this.add});

  @override
  State<WarningsContainer> createState() => _WarningsContainerState();
}

class _WarningsContainerState extends State<WarningsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WarningsSuggestion(add: widget.add),
              WarningsSuggestion(add: widget.add),
              WarningsSuggestion(add: widget.add),
              Row(
                children: widget.warnings
                    .map((warning) => WarningItem(warning: warning))
                    .toList(),
              ),
              AddWarningWidget(add: widget.add),
            ],
          ),
        ),
      ),
    );
  }
}
