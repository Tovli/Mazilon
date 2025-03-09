import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/styles.dart';

class CustomCategoryPage extends StatefulWidget {
  //final Function changeLocale;

  CustomCategoryPage(
      {super.key,
      //required this.changeLocale
      });
      @override
  _CustomCategoryPageState createState() => _CustomCategoryPageState();
}

class _CustomCategoryPageState extends State<CustomCategoryPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SingleChildScrollView(
            child: Center(
                child: myAutoSizedText(
                    "Add Category",
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                    null,
                    40)),
          ),
          backgroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0))),
          toolbarHeight: 100),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter custom category name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String inputText = _controller.text;
                if (inputText.isNotEmpty) {
                  // Do something with the input text
                  Navigator.pop(context, inputText);  // Return the input text back to the previous page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a category name')),
                  );
                }
              },
            style: TextButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: myAutoSizedText(
                  "Submit",
                  TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  null,
                  24),
            ),
          ],
        ),
      ),
    );
  }
}