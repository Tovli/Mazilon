import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/Thanks/AddForm.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mazilon/util/Thanks/thanksItemSug.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mazilon/util/customCatFunctions.dart';


// the thank you list widget, it shows the list of the thank yous
// this code is related to todo list in homepage.
class customCatWidget extends StatefulWidget {
  final Function(BuildContext, int)
      onTabTapped; // the function to call when pressing on the "see more" to go to wanted page (journal page)
  const customCatWidget({super.key, required this.onTabTapped});
  @override
  State<customCatWidget> createState() => _CustomCatWidgetState();
}

class _CustomCatWidgetState extends State<customCatWidget> {
  List<String> categoryNames = [];
  @override
  void initState() {
    super.initState();
  }

Future<List<String>> _listCategories() async {
    Map<String, List<String>> categoryMap = await loadCategories();
    
    // Get the category names (keys of the map)

      return categoryMap.keys.toList();

  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<List<String>>(
    future: _listCategories(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Or any loading widget
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return SizedBox(); // Empty if no categories
      } else {
        final categoryNames = snapshot.data!;
        return SizedBox(
          width: MediaQuery.of(context).size.width > 1000
              ? 800
              : MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                SectionBarHome(
                  textWidget: TextButton(
                    onPressed: () {
                      widget.onTabTapped(context, 3);
                    },
                    child: myAutoSizedText(
                      "Custom categories",
                      TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      null,
                      40,
                    ),
                  ),
                  icon: FontAwesome5.asterisk,
                  icons: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: primaryPurple,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ],
                  subHeader: "custom category test",
                ),
              ],
            ),
          ),
        );
      }
    },
  );
}
}