import 'package:flutter/material.dart';

class PersonalPlan extends StatefulWidget {
  final String text;
  const PersonalPlan({super.key, required this.text});

  @override
  State<PersonalPlan> createState() => _PersonalPlanState();
}

class _PersonalPlanState extends State<PersonalPlan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(minHeight: 100, maxHeight: 200, minWidth: 100),
      child: Card(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.text,
            ),
          ),
        ),
      ),
    );
  }
}
