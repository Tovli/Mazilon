import 'package:flutter/material.dart';

class SimplifiedCheckboxForm extends StatefulWidget {
  @override
  _SimplifiedCheckboxFormState createState() => _SimplifiedCheckboxFormState();
}

class _SimplifiedCheckboxFormState extends State<SimplifiedCheckboxForm> {
  late Map<String, bool> _isChecked;
  final List<String> data = ['Option 1', 'Option 2']; // Simplified data

  @override
  void initState() {
    super.initState();
    _isChecked = Map.fromIterable(data, key: (v) => v, value: (v) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        ..._isChecked.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: _isChecked[key],
            onChanged: (bool? value) {
              setState(() {
                _isChecked[key] = value ?? false;
                debugPrint(
                    "$key is now: ${_isChecked[key]}"); // Direct feedback
              });
            },
          );
        }).toList(),
        TextButton(
            onPressed: () {
              debugPrint("Next button clicked"); // Direct feedback
              // Logic to proceed to the next page or action
            },
            child: Text('Next Page'))
      ]),
    );
  }
}
