import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';

class PhonePageForm extends StatefulWidget {
  final Function next;
  final Function prev;
  final List<List<String>> collections;
  final List<String> collectionNames;

  PhonePageData phonePageData;
  PhonePageForm({
    Key? key,
    required this.next,
    required this.prev,
    required this.collections,
    required this.collectionNames,
    required this.phonePageData,
  }) : super(key: key);

  @override
  State<PhonePageForm> createState() => _PhonePageFormState();
}

class _PhonePageFormState extends State<PhonePageForm> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> numberControllers = [];
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  bool isEditingNew = false;
  int editingIndex = -1;

  //add contact to the list from the contact list in the phone
  void addItem(Contact contact) {
    String? phoneName = contact.displayName;
    String? phoneNumber =
        contact.phones?.isNotEmpty == true ? contact.phones?.first.value : null;

    if (phoneName != null && phoneNumber != null) {
      widget.phonePageData.addItem(phoneName, phoneNumber);
      editingIndex = widget.phonePageData.savedPhoneNames.length -
          1; // Set editingIndex to the index of the new contact
      nameControllers.add(TextEditingController(text: phoneName));
      numberControllers.add(TextEditingController(text: phoneNumber));
    } else {
      print("Both fields must be filled");
    }
  }
  //add contact to the list manually
  void addItemManual() {
    String phoneName = controller1.text;
    String phoneNumber = controller2.text;
    if (phoneName.isNotEmpty && phoneNumber.isNotEmpty) {
      Provider.of<PhonePageData>(context, listen: false)
          .addItem(phoneName, phoneNumber);
      controller1.clear();
      controller2.clear();
    } else {
      print("Both fields must be filled");
    }
  }

  Future<void> pickContact() async {
    PermissionStatus status = await Permission.contacts.status;

    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null) {
        addItem(contact);
      }
      setState(() {});
    } else {
      print("Permission to read contacts was denied");
    }
  }

  @override
  void dispose() {
    nameControllers.forEach((controller) => controller.dispose());
    numberControllers.forEach((controller) => controller.dispose());
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.phonePageData.savedPhoneNames.length; i++) {
      nameControllers.add(
          TextEditingController(text: widget.phonePageData.savedPhoneNames[i]));
      numberControllers.add(TextEditingController(
          text: widget.phonePageData.savedPhoneNumbers[i]));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.phonePageData = Provider.of<PhonePageData>(context, listen: false);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData(context);
  }

  void loadData(BuildContext context) {
    // Get your PhonePageData instance
    //PhonePageData phonePageData =
    //    Provider.of<PhonePageData>(context, listen: false);
    // Then initialize the controllers
    /*
    nameControllers = List<TextEditingController>.generate(
        phonePageData.savedPhoneNames.length,
        (index) =>
            TextEditingController(text: phonePageData.savedPhoneNames[index]));
    numberControllers = List<TextEditingController>.generate(
        phonePageData.savedPhoneNumbers.length,
        (index) => TextEditingController(
            text: phonePageData.savedPhoneNumbers[index]));
            */
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: returnSizedBox(context, 20)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          appInfoProvider.formPhonePage[
                              'header${userInfoProvider.gender}'],
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              height: 1.5),
                          TextAlign.center,
                          40),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: myAutoSizedText(
                        appInfoProvider.formPhonePage[
                            'subTitle${userInfoProvider.gender}'],
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkGray,
                            fontSize: 14.sp,
                            height: 1.3),
                        TextAlign.justify,
                        25),
                  ),
                ),
              ],
            ),
            SizedBox(height: returnSizedBox(context, 10)),
            //list of phones added in form Phone Page by the user either manually or from contact list:
            Consumer<PhonePageData>(
              builder: (context, phonePageData, child) {
                return Column(
                  children: [
                    Column(
                      children: [
                        ...phonePageData.savedPhoneNames
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          bool isEditing = index == editingIndex;
                          return Padding(
                            padding: EdgeInsets.all(returnSizedBox(context, 8)),
                            child: Row(
                              children: [
                                //buttons only shown if the user chose to start editing:
                                if (isEditing)
                                //DELETE BUTTON:(mostleft button)
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        size: returnSizedBox(context, 40)),
                                    onPressed: () {
                                      // Remove the item from phonePageData
                                      phonePageData.removeItemAt(index);

                                      // Remove the corresponding TextEditingController from the lists
                                      nameControllers.removeAt(index);
                                      numberControllers.removeAt(index);

                                      if (editingIndex == index) {
                                        editingIndex = -1;
                                      }
                                      phonePageData.update();
                                    },
                                  ),
                                //FINISH EDITING BUTTON:(second button from the left)
                                Offstage(
                                  offstage: !isEditing,
                                  child: IconButton(
                                    icon: Icon(Icons.check,
                                        size: returnSizedBox(context, 40)),
                                    onPressed: () {
                                      // Update the item with the new data from the text fields
                                      String newPhoneName =
                                          nameControllers[index].text;
                                      String newPhoneNumber =
                                          numberControllers[index].text;
                                      //save it in the phones lists (for names and numbers) in phonePageData:
                                      phonePageData.replaceItem(
                                          index, newPhoneName, newPhoneNumber);
                                      editingIndex = -1;
                                      //call the update method to update the UI and commit changes:
                                      phonePageData.update();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: isEditing
                                      ? TextField(
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12.sp),
                                          controller: numberControllers[index],
                                        )
                                      : InkWell(
                                          onTap: () {
                                            // Enter editing mode
                                            editingIndex = index;
                                            phonePageData.update();
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  returnSizedBox(context, 10)),
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: myText(
                                                    phonePageData
                                                        .savedPhoneNames[index],
                                                    TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14.sp,
                                                    ),
                                                    null),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                if (isEditing)
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: myText(
                                        appInfoProvider.formPhonePage['phone' +
                                                userInfoProvider.gender] ??
                                            'טלפון2',
                                        TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp),
                                        null),
                                  ),
                                const SizedBox(width: 10),
                                if (!isEditing)
                                  InkWell(
                                    onTap: () async {
                                      String url =
                                          'tel:${phonePageData.savedPhoneNumbers[index]}';
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(Uri.parse(url));
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    //phone icon button:
                                    child: CircleAvatar(
                                      radius: returnSizedBox(context, 20),
                                      backgroundColor: primaryPurple,
                                      foregroundColor: Colors.white,
                                      child: Icon(Icons.phone,
                                          size: returnSizedBox(context, 30)),
                                    ),
                                  ),
                                if (isEditing)
                                  Expanded(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextField(
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.sp),
                                        controller: nameControllers[index],
                                      ),
                                    ),
                                  ),
                                if (isEditing)
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: myText(
                                        appInfoProvider.formPhonePage['name' +
                                                userInfoProvider.gender] ??
                                            'שם2',
                                        TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp),
                                        null),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(
                            width: 10), // Add some space between the buttons
                        //add contact manually button:
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // Create new controllers with empty text
                              var nameController =
                                  TextEditingController(text: '');
                              var numberController =
                                  TextEditingController(text: '');

                              // Add the controllers to the lists
                              nameControllers.add(nameController);
                              numberControllers.add(numberController);

                              // Add a new item to phonePageData
                              phonePageData.savedPhoneNames.add('');
                              phonePageData.savedPhoneNumbers.add('');

                              editingIndex =
                                  phonePageData.savedPhoneNames.length - 1;
                              phonePageData.update();
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(6),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: myText(
                                appInfoProvider.formPhonePage[
                                    'manualTitle${userInfoProvider.gender}'],
                                TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryPurple,
                                ),
                                TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    //add contact from contact list button:
                    TextButton(
                      onPressed: pickContact,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(6),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: myText(
                            appInfoProvider.formPhonePage[
                                'contactImportTitle${userInfoProvider.gender}'],
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                            TextAlign.center),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: returnSizedBox(context, 10),
            ),
            //save all data after confirming:
            ConfirmationButton(context, () async {
              await widget.phonePageData.loadItemsFromPrefs();
              await widget.phonePageData.saveItemsToPrefs();
              widget.phonePageData.update();
              widget.next();
            },
                appInfoProvider
                    .formPhonePage['nextButton${userInfoProvider.gender}'],
                myTextStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 20.sp)),
          ],
        ),
      ),
    );
  }
}
