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
    EmergencyPhoneItem2(), // Item 0
    EmergencyPhoneItem1(), // Item 1
    EmergencyPhoneItem(i: 1), // Item 2 (index 1)
    EmergencyPhoneItem(i: 3), // Item 3 (index 3)
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
  const EmergencyPhoneItem({required this.i, super.key});

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    return InkWell(
      onTap: () async {
        // Display a dialog when the item is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (i == 1) {
              return EmergencyDialogBox(
                  number:
                      appInfoProvider.phonePageTitles['emergencyPhones']![i],
                  index: i);
            }
            return EmergencyDialogBoxNoWhatsapp(
              number: appInfoProvider.phonePageTitles['emergencyPhones']![i],
              index: i,
            );
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider.phonePageTitles['phoneName']![i],
                            TextStyle(
                                color: primaryPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp),
                            TextAlign.center,
                            40),
                      ),
                    ),
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myAutoSizedText(
                            appInfoProvider
                                .phonePageTitles['phoneDescription']![i]
                                .replaceAll(
                                    '/', '\n'), // Replace '/' with newline
                            TextStyle(
                                fontWeight: FontWeight.normal,
                                color: primaryPurple,
                                fontSize: 14.sp),
                            TextAlign.center,
                            30),
                      ),
                    ),
                  ],
                ),
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
                  child: const Icon(
                    Icons.phone,
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

// A stateless widget representing the second row of emergency phone items
class EmergencyPhonesRow2 extends StatelessWidget {
  const EmergencyPhonesRow2({
    super.key,
  });

  @override
  Row build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 1; i < 4; i += 2) // Iterate over the indexes 1 and 3
          Flexible(
            child: InkWell(
              onTap: () async {
                // Display a dialog when the item is tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    if (i == 1) {
                      return EmergencyDialogBox(
                          number: appInfoProvider
                              .phonePageTitles['emergencyPhones']![i],
                          index: i);
                    }
                    return EmergencyDialogBoxNoWhatsapp(
                        number: appInfoProvider
                            .phonePageTitles['emergencyPhones']![i],
                        index: i);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryPurple, width: 1),
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10), // Make the border circular
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Allow overflow
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myAutoSizedText(
                                appInfoProvider
                                    .phonePageTitles['phoneName']![i],
                                TextStyle(
                                    color: primaryPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                                TextAlign.right,
                                40), // Align the text to the right
                            myAutoSizedText(
                                appInfoProvider
                                    .phonePageTitles['phoneDescription']![i],
                                TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: primaryPurple,
                                    fontSize: 12.sp),
                                TextAlign.right,
                                30), // Align the text to the right
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(
                          -30, -10), // Adjust the position of the icon
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryPurple, width: 1),
                            color:
                                primaryPurple, // Change the background color here
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// A stateless widget representing the first row of emergency phone items
class EmergencyPhonesRow1 extends StatelessWidget {
  const EmergencyPhonesRow1({super.key});

  @override
  Row build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 2; i >= 0; i -= 2) // Iterate over the indexes 2 and 0
          Flexible(
            child: InkWell(
              onTap: () async {
                // Display a dialog when the item is tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    if (i == 2) {
                      return EmergencyDialogBox(
                          number: appInfoProvider
                              .phonePageTitles['emergencyPhones']![i],
                          index: i);
                    }
                    return EmergencyDialogBoxWithLink(
                        number: appInfoProvider
                            .phonePageTitles['emergencyPhones']![i],
                        index: i);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryPurple, width: 1),
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10), // Make the border circular
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Allow overflow
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myAutoSizedText(
                                appInfoProvider
                                    .phonePageTitles['phoneName']![i],
                                TextStyle(
                                    color: primaryPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                                TextAlign.right,
                                60), // Align the text to the right
                            myAutoSizedText(
                                appInfoProvider
                                    .phonePageTitles['phoneDescription']![i],
                                TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: primaryPurple,
                                    fontSize: 12.sp),
                                TextAlign.right,
                                40), // Align the text to the right
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(
                          -30, -10), // Adjust the position of the icon
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryPurple, width: 1),
                            color:
                                primaryPurple, // Change the background color here
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            i == 2 ? Icons.chat : Icons.phone,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// A custom widget representing a specific emergency phone item (index 2)
class EmergencyPhoneItem1 extends StatelessWidget {
  const EmergencyPhoneItem1({super.key});

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    return InkWell(
      onTap: () async {
        // Show dialog when the item is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EmergencyDialogBox(
                number: appInfoProvider.phonePageTitles['emergencyPhones']![2],
                index: 2);
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: myAutoSizedText(
                          appInfoProvider.phonePageTitles['phoneName']![2],
                          TextStyle(
                              color: primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp),
                          TextAlign.center,
                          60),
                    ),
                    Center(
                      child: myAutoSizedText(
                          appInfoProvider
                              .phonePageTitles['phoneDescription']![2],
                          TextStyle(
                              fontWeight: FontWeight.normal,
                              color: primaryPurple,
                              fontSize: 14.sp),
                          TextAlign.center,
                          40),
                    ),
                  ],
                ),
              ),
            ),
            // Icon displayed in the top left corner
            Transform.translate(
              offset: const Offset(-20, -20),
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
                  child: const Icon(
                    Icons.chat,
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

void main() {
  runApp(MaterialApp(
    home: EmergencyPhonesGrid(),
  ));
}

// A custom widget representing a specific emergency phone item (index 0)
class EmergencyPhoneItem2 extends StatelessWidget {
  const EmergencyPhoneItem2({super.key});

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    return InkWell(
      onTap: () async {
        // Show dialog when the item is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EmergencyDialogBoxWithLink(
                number: appInfoProvider.phonePageTitles['emergencyPhones']![0],
                index: 0);
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: myAutoSizedText(
                          appInfoProvider.phonePageTitles['phoneName']![0],
                          TextStyle(
                              color: primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp),
                          TextAlign.center,
                          60),
                    ),
                    Center(
                      child: myAutoSizedText(
                          appInfoProvider
                              .phonePageTitles['phoneDescription']![0],
                          TextStyle(
                              fontWeight: FontWeight.normal,
                              color: primaryPurple,
                              fontSize: 14.sp),
                          TextAlign.center,
                          40),
                    ),
                  ],
                ),
              ),
            ),
            // Icon displayed in the top left corner
            Transform.translate(
              offset: const Offset(-20, -20),
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
                  child: const Icon(
                    Icons.phone,
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
