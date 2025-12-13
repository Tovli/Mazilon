// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/styles.dart';

class InitialFormPage1 extends StatefulWidget {
  final Function next;
  final Function skip;
  final Function prev;
  final Function updateName;
  final Map<String, String> titles;
  const InitialFormPage1({
    super.key,
    required this.next,
    required this.skip,
    required this.prev,
    required this.updateName,
    required this.titles,
  });
  @override
  State<InitialFormPage1> createState() => _InitialFormPage1State();
}

class _InitialFormPage1State extends State<InitialFormPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text('maintitle'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 5,
                    0,
                    MediaQuery.of(context).size.width / 5,
                    0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('subtitle1'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 6,
                    0,
                    MediaQuery.of(context).size.width / 6,
                    0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('subtitle2'),
                ),
              ),
              SizedBox(
                height: returnSizedBox(context, 20),
              ),
              Image.asset(
                'assets/images/initialFormPage1.png',
                width: MediaQuery.sizeOf(context).width * 0.8 > 1000
                    ? 500
                    : MediaQuery.sizeOf(context).width *
                        0.8, // Adjust as needed
                height:
                    MediaQuery.sizeOf(context).height * 0.4, // Adjust as needed
              ),
              SizedBox(
                height: returnSizedBox(context, 50),
              ),
              // confirmationButton(context, () {
              //   widget.next();
              // },
              //     'המשך',
              //     myTextStyle.copyWith(
              //       fontSize: 20.sp,
              //     )),
              MaterialButton(
                key: Key('next'),
                onPressed: () {
                  setState(() {
                    widget.next;
                  });
                },
                splashColor: Colors.transparent,
                enableFeedback: false,
                child: Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              SizedBox(
                height: returnSizedBox(context, 20),
              ),
              confirmationButton(context, () {
                widget.skip();
              },
                  'לדילוג',
                  myTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  )),
              MaterialButton(
                key: Key('skip'),
                onPressed: () {
                  setState(() {
                    widget.skip;
                  });
                },
                splashColor: Colors.transparent,
                enableFeedback: false,
                child: Icon(
                  Icons.skip_previous,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
