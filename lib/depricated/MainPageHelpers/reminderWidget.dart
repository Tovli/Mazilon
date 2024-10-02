import 'package:flutter/material.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/depricated/util/Reminder/reminder.dart';
import 'package:mazilon/depricated/util/Reminder/reminderForm.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';

class ReminderWidget extends StatefulWidget {
  final List<String> reminders;
  final Function add;

  final String reminderMainTitle;
  final String reminderSubTitle;

  const ReminderWidget({
    super.key,
    required this.reminders,
    required this.add,
    required this.reminderMainTitle,
    required this.reminderSubTitle,
  });

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  void addNotification() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReminderForm(add: widget.add);
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            SectionBarHome(
                //text: widget.reminderMainTitle,
                textWidget: Container(),
                icon: Icons.notifications,
                icons: [myTextButton(addNotification, Icons.add, Colors.black)],
                subHeader: widget.reminderSubTitle),
            Column(
              children: widget.reminders
                  // ignore: prefer_const_constructors
                  .map((reminder) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        // ignore: prefer_const_constructors
                        child: Reminder(text: reminder, icon: [
                          Icon(Icons.edit, color: darkGray, size: 25)
                        ]),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
