import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxForm extends StatefulWidget {
  final List<String> data;
  final Function next;
  final Function prev;
  final Function saveData;
  const CheckboxForm(
      {Key? key,
      required this.next,
      required this.prev,
      required this.data,
      required this.saveData})
      : super(key: key);
  @override
  _CheckboxFormState createState() => _CheckboxFormState();
}

class _CheckboxFormState extends State<CheckboxForm> {
  late Map<String, bool> _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked =
        Map.fromIterable(widget.data, key: (v) => v, value: (v) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        ..._isChecked.keys.map((String key) {
          return CheckboxListTile(
            title: Text(
              key,
              textDirection: TextDirection.rtl,
            ),
            value: _isChecked[key],
            onChanged: (bool? value) {
              setState(() {
                _isChecked[key] = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.trailing,
          );
        }).toList(),
        TextButton(
            onPressed: () {
              // TODO ADD THE LOGIC TO SAVE THE INFORMATION THE USER CHOSE IN SHARED PREFENRENCES
              widget.next();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: myText(
                'עמוד הבא',
                TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                null))
      ]),
    );
  }
}
