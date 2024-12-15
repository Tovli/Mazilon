import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/Phone/emergencyDialogBox.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/appInformation.dart';

// Extracts and returns the list of child widgets from a Row widget
List<Widget> extractChildrenFromRow(Row row) {
  return row.children;
}

// A stateless widget that displays a grid of emergency phone items
class EmergencyPhonesGrid extends StatelessWidget {
  final List<Widget> emergencyPhoneItems = [
    EmergencyPhoneItem(i: 0, icon: Icons.phone),
    EmergencyPhoneItem(i: 2, icon: Icons.chat),
    EmergencyPhoneItem(i: 1, icon: Icons.phone), // Item 2 (index 1)
    EmergencyPhoneItem(i: 3, icon: Icons.phone), // Item 3 (index 3)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Horizontal spacing between items
          mainAxisSpacing: 10.0, // Vertical spacing between items
        ),
        itemCount: emergencyPhoneItems.length, // Number of items in the grid
        itemBuilder: (BuildContext context, int index) {
          return emergencyPhoneItems[index];
        },
      ),
    );
  }
}

// A custom widget representing an emergency phone item in the grid
class EmergencyPhoneItem extends StatelessWidget {
  final int i; // Index of the emergency phone item
  final IconData icon; // Icon to display in the item
  const EmergencyPhoneItem({required this.i, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    return InkWell(
      onTap: () async {
        // Display a dialog when the item is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            switch (i) {
              case 0:
                return EmergencyDialogBox(
                  number:
                      appInfoProvider.phonePageTitles['emergencyPhones']![0],
                  index: 0,
                  hasWhatsApp: true,
                  hasLink: false,
                );

              case 1:
                return EmergencyDialogBox(
                  number:
                      appInfoProvider.phonePageTitles['emergencyPhones']![1],
                  index: 1,
                  hasWhatsApp: true,
                  hasLink: false,
                );

              case 2:
                return EmergencyDialogBox(
                  number:
                      appInfoProvider.phonePageTitles['emergencyPhones']![2],
                  index: 2,
                  hasWhatsApp: false,
                  hasLink: true,
                );

              case 3:
                return EmergencyDialogBox(
                  number:
                      appInfoProvider.phonePageTitles['emergencyPhones']![3],
                  index: 3,
                  hasWhatsApp: false,
                  hasLink: false,
                );

              default:
                return Container();
            }
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: primaryPurple, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: myAutoSizedText(
                        appInfoProvider.phonePageTitles['phoneName']![i],
                        TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp),
                        TextAlign.center,
                        40),
                  ),
                  Center(
                    child: myAutoSizedText(
                        appInfoProvider.phonePageTitles['phoneDescription']![i]
                            .replaceAll('/', '\n'), // Replace '/' with newline
                        TextStyle(
                            fontWeight: FontWeight.normal,
                            color: primaryPurple,
                            fontSize: 14.sp),
                        TextAlign.center,
                        30),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(-20, -20), // Adjust the position of the icon
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryPurple, width: 1),
                    color: primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
