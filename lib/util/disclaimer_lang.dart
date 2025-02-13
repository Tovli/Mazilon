import 'package:flutter/material.dart';

class LanguageDropDown extends StatefulWidget {
  final List<Map<String, String>> list = [
    {
      'locale': 'en',
      'image': 'assets/images/united-states.png'
    }, // Replace with your image paths
    {
      'locale': 'he',
      'image': 'assets/images/israel.png'
    }, // Replace with your image paths
  ];

  final Function changeLocale;
  LanguageDropDown({required this.changeLocale, super.key});

  @override
  State<LanguageDropDown> createState() => _LanguageDropDownState();
}

class _LanguageDropDownState extends State<LanguageDropDown> {
  late String? dropdownValue;

  @override
  void initState() {
    super.initState();
    // Initialize dropdownValue with null to show "Change Language" initially
    dropdownValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        value: dropdownValue,
        hint: Text('Change Language'), // Default text when nothing is selected
        icon: const Icon(Icons.arrow_downward),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              dropdownValue = value;
              widget.changeLocale(value); // Update the locale
            });
          }
        },
        items: widget.list
            .map<DropdownMenuItem<String>>((Map<String, String> item) {
          return DropdownMenuItem<String>(
            value: item['locale']!,
            child: Row(
              children: [
                // Displaying the image with the flag
                Image.asset(
                  item['image']!,
                  width: 45,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
