import 'package:flutter/widgets.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/file_service.dart';
import 'package:mazilon/global_enums.dart';
import 'personalPlan.dart';
import 'sectionBarHome.dart';

import 'dart:math';
import 'package:permission_handler/permission_handler.dart';

class PersonalPlanWidget extends StatefulWidget {
  final Map<String, dynamic> text;
  final Function(int) changeCurrentIndex;
  const PersonalPlanWidget(
      {super.key, required this.text, required this.changeCurrentIndex});

  @override
  State<PersonalPlanWidget> createState() => _PersonalPlanWidgetState();
}

class _PersonalPlanWidgetState extends State<PersonalPlanWidget> {
  late FileService fileService;
  late List<String> randomItems = ['1', '2'];

  List<String> feelBetter = [];
  void loadFeelBetter() {
    var random = Random();
    var index1 = 0;
    var index2 = 0;

    if (widget.text['list'].length >= 2) {
      index1 = random.nextInt(widget.text['list'].length);
      do {
        index2 = random.nextInt(widget.text['list'].length);
      } while (index1 == index2);

      setState(() {
        randomItems = [
          widget.text['list'][index1],
          widget.text['list'][index2]
        ];
      });
    } else if (widget.text['list'].length == 1) {
      index1 = 0;
      setState(() {
        randomItems = [widget.text['list'][index1]];
      });
    } else {
      setState(() {
        randomItems = [];
      });
    }
  }

  @override
  void initState() {
    fileService = GetIt.instance<FileService>();
    loadFeelBetter();
    super.initState();
  }

  void share(gender) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              width: 300,
              height: 50,
              child: Text(
                "test 1",
              ),
            ),
            actions: <Widget>[
              TextButton(
                key: Key("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "ביטול",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
              Container(
                width: 70,
                height: 50,
                child: TextButton(
                  key: Key("send1"),
                  child: Text(
                    "test2",
                  ),
                  onPressed: () async {
                    await fileService.share(
                        "test3",
                        [
                          "test4",
                          "test5",
                          "test6",
                          "test7",
                          "test8",
                        ],
                        [
                          "test4",
                          "test5",
                          "test6",
                          "test7",
                          "test8",
                        ],
                        {},
                        ShareFileType.PDF);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                width: 70,
                height: 50,
                child: TextButton(
                  key: Key("send2"),
                  child: Text("test9"),
                  onPressed: () async {
                    await fileService.share(
                        "test10",
                        [
                          "test10",
                          "test11",
                          "test12",
                          "test13",
                          "test14",
                        ],
                        [
                          "test10",
                          "test11",
                          "test12",
                          "test13",
                          "test14",
                        ],
                        {},
                        ShareFileType.PDF);

                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            SectionBarHome(
                text: '',
                textWidget: TextButton(
                    onPressed: () {
                      widget.changeCurrentIndex(1);
                    },
                    child: Text(
                      'התוכנית שלי',
                    )),
                icon: Icons.note_add,
                icons: [
                  TextButton(
                      key: Key("share"),
                      onPressed: () {
                        share("male");
                      },
                      child: Icon(Elusive.share)),
                  TextButton(
                    key: Key("download"),
                    child: Icon(Icons.download),
                    onPressed: () async {
                      fileService.download([
                        "male",
                        "male",
                        "male",
                        "male",
                        "male",
                      ], [
                        "male",
                        "male",
                        "male",
                        "male",
                        "male",
                      ], {}, ShareFileType.PDF);
//TODO: think of a way to do the other option to chose where to download the file to (like the share option)
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ההורדה החלה'),
                            content: const Text('התוכנית ירדה להורדות '),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
                subHeader: widget.text['SubTitle']),
            GridView.count(
                crossAxisCount: 2, // Set the number of items in each row
                crossAxisSpacing: 5,
                childAspectRatio: 12 / 4,
                shrinkWrap:
                    true, // Use this if the GridView is inside another scrolling widget
                physics:
                    NeverScrollableScrollPhysics(), // Adjust this value as needed to change the aspect ratio of the items
                children: randomItems
                    .map((pPlan) => Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 5),
                          child: PersonalPlan(text: pPlan),
                        ))
                    .toList()
                // Use this if the GridView is inside another scrolling widget
                ),
            GestureDetector(
              onTap: () {
                widget.changeCurrentIndex(1);
                // Handle the button tap here
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_left),
                  Text('לכל התוכנית'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
