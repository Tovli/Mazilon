import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';

class ReminderForm extends StatefulWidget {
  final Function add;
  const ReminderForm({super.key, required this.add});
  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height *
            22 /
            100, // Set height to 1/3 of screen height
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            myText('תזכורת חדשה', TextStyle(fontWeight: FontWeight.normal, fontSize: 12), null),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _controller,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'תזכורת',
                              contentPadding: EdgeInsets.only(right: 8.0),
                              labelStyle: TextStyle(fontWeight: FontWeight.normal, height: 0, fontSize: 20),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'הכנס בבקשה תזכורת';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    // Save the reminder
                    if (_formKey.currentState!.validate()) {
                      widget.add(_controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
