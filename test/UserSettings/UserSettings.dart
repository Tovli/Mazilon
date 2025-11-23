import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  final String username;
  final String age;
  final String gender;
  final Function updateData;
  final Map<String, String> titles;

  const UserSettings(
      {super.key,
      required this.username,
      required this.age,
      required this.gender,
      required this.updateData,
      required this.titles});
  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  String? dropdownValueAge = '55+';
  TextEditingController _namecontroller = TextEditingController();

  String? dropdownValueGender = '';
  String? name = '';
  List<String> ages = ['18-', '18-30', '30-40', '40-55', '55+'];
  List<String> genders = ['אתה', 'את', 'לשון מעורבת', 'לא מעוניין להגיד'];

  void savePage(age, gender) {
    widget.updateData(_namecontroller.text, gender, age);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    dropdownValueAge = widget.age;
    dropdownValueGender = widget.gender == 'male'
        ? 'אתה'
        : (widget.gender == 'female' ? 'את' : '');
    super.initState();
    _namecontroller = TextEditingController(text: widget.username);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _namecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('הגדרות משתמש'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                'עדכון פרטים אישיים',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(widget.titles["name"] ?? "")),
                  Container(
                    width: 300,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        height: 35,
                        child: TextField(
                          key: Key('nameField'),
                          controller: _namecontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                          ),
                          onChanged: (text) {
                            // Do something with the text
                            name = text;
                          },
                        ),
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      widget.titles["age"] ?? 'גיל',
                    ),
                  ),
                  Container(
                    key: Key('dropdownAge'),
                    width: 300,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownMenu<String>(
                        width: 300,
                        initialSelection: "18-30",
                        dropdownMenuEntries: [
                          ...['-18', '18-30', '30-40', '40-55', '55+'].map(
                              (age) =>
                                  DropdownMenuEntry(value: age, label: age))
                        ],
                        onSelected: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              dropdownValueAge = newValue;
                            }
                          });
                          // Do something with the selected value
                        },
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      widget.titles["gender"] ?? "",
                    ),
                  ),
                  Container(
                    key: Key('dropdownGender'),
                    width: 300,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownMenu<String>(
                        initialSelection: 'לשון מעורבת'

                        //userInfoProvider.gender == 'nonbinary'
                        // ? 'לא בינארי'
                        // : 'לא מעוניין להגיד'
                        ,
                        width: 300,
                        dropdownMenuEntries: [
                          ...genders
                              .map((gender) => DropdownMenuEntry(
                                  value: gender, label: gender))
                              .toList()
                        ],
                        onSelected: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              dropdownValueGender = newValue;
                            }
                          });
                          // Do something with the selected value
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: MediaQuery.of(context).size.width > 1000
                    ? 600
                    : MediaQuery.of(context).size.width * 0.6,
                child: TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    switch (dropdownValueGender!) {
                      case 'אתה':
                        savePage(dropdownValueAge!, 'male');
                        break;
                      case 'את':
                        savePage(dropdownValueAge!, 'female');
                        break;
                      case 'לשון מעורבת':
                        savePage(dropdownValueAge!, '');
                        break;
                      default:
                        savePage(dropdownValueAge!, '');
                    }
                  },
                  child: Text('אישור'),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
