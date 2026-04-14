import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';

class LanguageDropDown extends StatefulWidget {
  final List<Map<String, String>> list = [
    {
      'locale': 'en',
      'label': 'English',
      'image': 'assets/images/united-states.png'
    },
    {
      'locale': 'he',
      'label': 'עברית',
      'image': 'assets/images/israel.png'
    },
    {
      'locale': 'ar',
      'label': 'العربية',
      'image': ''
    },
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
    final Locale defaultSystemLocale =
        WidgetsBinding.instance.platformDispatcher.locale;
    final supportedLocale = widget.list
        .where((item) => item['locale'] == defaultSystemLocale.languageCode)
        .toList();
    dropdownValue = supportedLocale.isNotEmpty
        ? supportedLocale.first['locale']
        : widget.list.first['locale'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: widget.list
                .map(
                  (item) => Text(
                    item['label'] ?? item['locale']!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
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
                    if (item['image']!.isNotEmpty) ...[
                      Image.asset(
                        item['image']!,
                        width: 45,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(item['label'] ?? item['locale']!),
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
