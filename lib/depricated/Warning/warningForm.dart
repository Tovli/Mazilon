import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WarningForm extends StatefulWidget {
  final Function add;
  const WarningForm({super.key, required this.add});
  @override
  State<WarningForm> createState() => _WarningFormState();
}

class _WarningFormState extends State<WarningForm> {
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

            myText('סימן אזהרה חד', TextStyle(fontSize: 12.sp), null),

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
                              labelText: 'סימן',
                              contentPadding: EdgeInsets.only(right: 8.0),
                              labelStyle: TextStyle(fontWeight: FontWeight.normal, height: 0, fontSize: 20.sp),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'הסימן אינו יכול להיות ריק';
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
                  child: myText('בטל', TextStyle(fontSize: 20.sp), null),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: myText('מור', TextStyle(fontSize: 20.sp), null),
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
