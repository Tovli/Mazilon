import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';

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
    final Locale defaultSystemLocale =
        WidgetsBinding.instance.platformDispatcher.locale;
    if (defaultSystemLocale.languageCode == 'he') {
      dropdownValue = widget.list[1]['locale'];
    } else {
      dropdownValue = widget.list[0]['locale'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.width > 1000
              ? 600
              : MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: primaryPurple,
            borderRadius: BorderRadius.circular(20), // Rounded edges
          ),
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: SizedBox.shrink(),
            isExpanded: true,
            underline: SizedBox.shrink(),
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
