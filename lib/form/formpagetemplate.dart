import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:mazilon/pages/FormAnswer.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';

class FormPageTemplate extends StatefulWidget {
  //next page:
  final Function next;
  //prev page:
  final Function prev;
  final List<String> collectionNames;
  final List<List<String>> collections;
  //model for the checkboxes:
  final CheckboxModel model;
  final String collectionName;

  FormPageTemplate(
      {Key? key,
      required this.next,
      required this.prev,
      required this.collectionNames,
      required this.collections,
      required this.model,
      required this.collectionName})
      : super(key: key);

  @override
  State<FormPageTemplate> createState() => _FormPageTemplateState();
}

class _FormPageTemplateState extends State<FormPageTemplate> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void deleteAnswer(int index) {
    widget.model.deleteitem(index);
    setState(() {});
  }

  void editAnswer(int index, String text) {
    widget.model.editItem(index, text);
    setState(() {});
  }

  //generate 3 items in the database items list at the bottom of the screen:
  void addSuggestion() {
    widget.model.increase();
    widget.model.update();
    widget.model.increase();
    widget.model.update();
    widget.model.increase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);
    Map<String, String> displayInformation = retrieveInformation(
        appInfoProvider, widget.collectionName, userInfoProvider.gender);

    bool validate = false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          //widthFactor: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: myAutoSizedText(
                            displayInformation['header'],
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                height: 1.5),
                            TextAlign.center,
                            40),
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
                            displayInformation['subTitle'],
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
                SizedBox(
                  height: 20.h,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  //generate list based on added strings(strings the user chose to manually add
                  // or items chosen from database item list at the bottom of the screen):
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.model.addedStrings.length,
                    itemBuilder: (context, index) {
                      return FormAnswer(
                        text: widget.model.addedStrings[index],
                        num: (index + 1),
                        edit: editAnswer,
                        remove: deleteAnswer,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width > 1000
                      ? 800
                      : MediaQuery.of(context).size.width,
                  child: Row(
                    //mainAxisSize: MediaQuery.of(context).size.width,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.sp > 40 ? 40 : 14.sp),
                          controller: _controller,
                          decoration: InputDecoration(
                            errorText: validate ? "Value Can't Be Empty" : null,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          if (_controller.text.isEmpty) {
                            validate = true;
                          } else {
                            validate = false;
                            widget.model.addItem([_controller.text]);

                            _controller.clear();
                            setState(() {});
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Colors.black, // This is the color of the text
                          backgroundColor: Colors
                              .white, // This is the background color of the button
                          shape: RoundedRectangleBorder(
                            // This is the shape of the button
                            borderRadius: BorderRadius.circular(
                                20), // This is the border radius
                            side: const BorderSide(
                                color:
                                    Colors.black), // This is the border color
                          ),
                          padding: const EdgeInsets.all(
                              10), // This is the padding inside the button
                        ),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: myAutoSizedText(
                              appInfoProvider.addFormPageTemplateStrings[
                                      'add-' + userInfoProvider.gender] ??
                                  'הוספה',
                              TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                              null,
                              20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: myAutoSizedText(
                          displayInformation['midTitle'],
                          TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                          TextAlign.center,
                          40),
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
                            displayInformation['midSubTitle'],
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                color: darkGray,
                                fontSize: 14.sp,
                                height: 1.5),
                            TextAlign.justify,
                            25),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  //database items(rowy) check box list:
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.model.length,
                    itemBuilder: (context, index) {
                      String item = widget.model.databaseItems[index];
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        activeColor: appGreen,
                        checkboxShape: CircleBorder(),
                        visualDensity: VisualDensity.compact,
                        title: Directionality(
                            textDirection: TextDirection.rtl,
                            child: !widget.model.isSelected(index)
                                ? DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [5, 5],
                                    color: appGreen,
                                    strokeWidth: 2,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      constraints:
                                          BoxConstraints(minHeight: 55),
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          item,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontFamily: "Rubix",
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  )
                                : DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [5, 5],
                                    color: Colors.transparent,
                                    strokeWidth: 2,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      //height: returnSizedBox(context, 70),
                                      constraints:
                                          BoxConstraints(minHeight: 55),
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        //border: Border.all(color: Color.fromARGB(255, 187, 167, 235))
                                      ),
                                      //color: widget.answer1.contains(widget.suggestions[index]) ? Colors.transparent : Color.fromARGB(255, 223, 218, 218),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          item,
                                          textAlign: TextAlign.right,
                                          //overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "Rubix",
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  )),
                        value: widget.model.isSelected(index),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              widget.model.setSelected(index, value, item);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                //add more button:
                widget.model.length < widget.model.databaseItems.length
                    ? TextButton(
                        onPressed: () {
                          addSuggestion();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Colors.black, // This is the color of the text
                          backgroundColor: Colors
                              .white, // This is the background color of the button
                          shape: RoundedRectangleBorder(
                            // This is the shape of the button
                            borderRadius: BorderRadius.circular(
                                20), // This is the border radius
                            side: const BorderSide(
                                color:
                                    Colors.black), // This is the border color
                          ),
                          padding: const EdgeInsets.all(
                              0), // This is the padding inside the button
                        ),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: myAutoSizedText(
                                displayInformation['showMoreButtonText'],
                                TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                                null,
                                40),
                          ),
                        ),
                      )
                    //nothing to add:
                    : SizedBox(
                        height: returnSizedBox(context, 10),
                      ),
                //spacing between add more and next button:
                SizedBox(
                  height: returnSizedBox(context, 10),
                ),
                //next button:
                ConfirmationButton(context, () {
                  widget.model.createSelection(userInfoProvider);
                  widget.next();
                },
                    displayInformation['nextButtonText'],
                    myTextStyle.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 22.sp)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
