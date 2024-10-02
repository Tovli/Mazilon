import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart'; //
import 'package:provider/provider.dart'; //
import 'package:mazilon/util/appInformation.dart'; //

// the add form widget, it shows a form to add or edit an item to the list
class AddForm extends StatefulWidget {
  final Function add; // the function to add item to the list
  final int index; // the index of the item in the list
  final Function edit; // the function to edit the item in the list
  final String text; // the text of the item
  final String formTitle; // the title of the form
  @override
  const AddForm({
    super.key,
    required this.add,
    required this.index,
    required this.edit,
    required this.text,
    required this.formTitle,
  });
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

// build the add form widget
  @override
  Widget build(BuildContext context) {
    // get the appInformation and userInformation providers
    final appInfoProvider =
        Provider.of<AppInformation>(context, listen: true); //
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true); //

    return Dialog(
      child: Container(
        // set the width of the dialog to 800 if the screen width is more than 1000, else set it to the screen width
        width: MediaQuery.of(context).size.width > 1000
            ? 800
            : MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          // Wrap Column with SingleChildScrollView
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // text on the top of the form
              Directionality(
                textDirection: TextDirection.rtl,
                child: myAutoSizedText(
                    '${widget.formTitle} חדשה',
                    TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp // text size
                        ),
                    null,
                    40),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // the text field
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  maxLength:
                                      100, // set the max length of the text field
                                  controller: _controller,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    labelText: widget.formTitle,
                                    contentPadding: EdgeInsets.only(right: 1.0),
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Rubix',
                                        height: 0,
                                        fontSize: 20),
                                  ),
                                  validator: (value) {
                                    // validate the text field
                                    if (value == null || value.isEmpty) {
                                      return 'ה${widget.formTitle} לא יכולה להיות ריקה';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // the close button
                  TextButton(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      // the text of the close button
                      child: myAutoSizedText(
                          appInfoProvider.addThanksFormStrings[
                                  'close-' + userInfoProvider.gender] ??
                              'בטל',
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp // button text size
                              ),
                          null,
                          30),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // the save button
                  TextButton(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      // the text of the save button
                      child: myAutoSizedText(
                          appInfoProvider.addThanksFormStrings[
                                  'save-' + userInfoProvider.gender] ??
                              'שמור',
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp // button text size
                              ),
                          null,
                          30),
                    ),
                    onPressed: () {
                      // Save the item (add or edit) to the list
                      if (_formKey.currentState!.validate()) {
                        if (widget.text != '') {
                          widget.edit(_controller.text, widget.index);
                        } else
                          widget.add(_controller.text);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
