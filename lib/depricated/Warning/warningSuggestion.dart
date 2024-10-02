import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Firebase/firebase_functions.dart';

class WarningsSuggestion extends StatefulWidget {
  final Function add;
  const WarningsSuggestion({super.key, required this.add});

  @override
  State<WarningsSuggestion> createState() => _WarningsSuggestionState();
}

class _WarningsSuggestionState extends State<WarningsSuggestion> {
  String text = '';
  List<String> warnings = [];
  // List<String> warnings = [
  //   'עצב עמוק ומתמשך',
  //   'חרדה ודאגה בלתי מוסברת',
  //   'תחושת חוסר תקווה וייאוש',
  //   'כעס ותוקפנות בלתי נשלטים',
  //   'אשמה ובושה קשות',
  //   'חוסר עניין והנאה מפעילויות אהובות',
  //   'תחושת ריקנות ובדידות קיצונית',
  //   'עצבנות קיצונית וקושי להתרכז',
  //   'מחשבות אובדניות ופגיעה עצמית',
  //   'שינויים קיצוניים בתיאבון ובשינה',
  //   'הימנעות מפעילויות חברתיות',
  //   'התבודדות וריחוק מאנשים אהובים',
  //   'שימוש באלכוהול, סמים או התנהגויות מזיקות',
  //   'הזנחה עצמית, היגיינה אישית ירודה',
  //   'קשיים בריכוז, קבלת החלטות ותפקוד יומיומי',
  //   'נטילת סיכונים לא מחושבים',
  //   'ביטויים של אלימות מילולית או פיזית',
  //   'מחשבות ופנטזיות על בריחה או מוות',
  //   'עייפות מתמשכת וחוסר אנרגיה',
  //   'כאבים פיזיים בלתי מוסברים',
  //   'שינויים בתיאבון ובמשקל',
  //   'קשיים בשינה ובהירדמות',
  //   'בעיות עיכול וסף כאב נמוך',
  //   'ירידה בתפקוד המיני',
  //   'סימנים של הזנחה גופנית',
  //   'ריחוק וניתוק מחברים ומשפחה',
  //   'קשיים בתקשורת ובקיום קשרים חברתיים',
  //   'ביטול תוכניות ופעילויות חברתיות',
  //   'תחושת בדידות קיצונית ודחייה חברתית',
  //   'קשיים בעבודה או בלימודים',
  //   'התנהגות תוקפנית או נסיגה חברתית',
  //   'הזנחת היגיינה אישית וטיפוח עצמי',
  //   'הזנחת סביבת המחיה',
  //   'קשיים בניהול משימות יומיומיות',
  //   'חוסר אכפתיות כלפי העתיד',
  //   'תחושת חוסר אונים והתמכרות לעזרה מאחרים',
  // ];

  /*void fetchWarnings2() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('warning-suggestions')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    warnings =
        documents.map((doc) => doc.get('suggestions') as String).toList();
    var rng = new Random();
    var randomNumber = rng.nextInt(warnings.length);
    text = warnings[randomNumber];
  }*/

  @override
  void initState() {
    super.initState();
    fetchWarnings().then((result) {
      setState(() {
        warnings = result.warnings;
        text = result.text;
      });
    });
    // var rng = new Random();
    // var randomNumber = rng.nextInt(warnings.length);
    // text = warnings[randomNumber];
  }

  void addWarning() {
    setState(() {
      widget.add(text);
      var rng = new Random();
      var randomNumber = rng.nextInt(warnings.length);
      text = warnings[randomNumber];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(20),
            dashPattern: [5, 5],
            color: appGreen,
            strokeWidth: 2,
            child: Container(
              color: Colors.transparent,
              height: 100,
              width: 100,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText.rich(
                    minFontSize: 10,
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'הצעה -',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: darkGray,
                              fontSize: 14.sp),
                        ),
                        TextSpan(
                          text: text,
                          style:
                              TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.sp),
                        ),
                      ],
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1),
                  color: Colors.grey[200],
                  shape: BoxShape.circle),
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.all(1)),
                onPressed: () => {addWarning()},
                child: Icon(
                  Icons.add,
                  color: Colors.green,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
