import 'package:flutter/material.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/form/form.dart';

class PersonalPlan extends StatefulWidget {
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;
  final PhonePageData phonePageData;

  final bool hasFilled;

  const PersonalPlan(
      {super.key,
      required this.collections,
      required this.collectionNames,
      required this.checkboxModels,
      required this.phonePageData,
      required this.hasFilled});

  @override
  State<PersonalPlan> createState() => _PersonalPlanState();
}

class _PersonalPlanState extends State<PersonalPlan> {
  bool canedit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            myText('Schedule Screen', TextStyle(fontSize: 40), null),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FormProgressIndicator(
                      collections: widget.collections,
                      collectionNames: widget.collectionNames,
                      checkboxModels: widget.checkboxModels,
                      phonePageData: widget.phonePageData,
                    ), //place collections here
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(-1.0, 0.0);
                      var end = Offset.zero;
                      var tween = Tween(begin: begin, end: end);
                      var offsetAnimation = animation.drive(tween);

                      var fadeTween = Tween(begin: 0.0, end: 1.0);
                      var fadeAnimation = animation.drive(fadeTween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        ),
                      );
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: myText(
                  widget.hasFilled
                      ? appInfoProvider.returnToPlanStrings["alreadyFilled"]!
                      : appInfoProvider.returnToPlanStrings["didntFill"]!,
                  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  null),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
