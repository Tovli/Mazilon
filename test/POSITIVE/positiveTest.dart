import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'traitTest.dart';
import 'PositiveTraitItemSugTest.dart';
import 'positiveAddFormTest.dart';
import 'dart:math';

class Positive extends StatefulWidget {
  final Map<String, dynamic> fakeSharedPreferencesStorage;
  const Positive({super.key, required this.fakeSharedPreferencesStorage});

  @override
  State<Positive> createState() => _PositiveState();
}

class _PositiveState extends State<Positive> {
  List<String> traitsSuggestionsList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];
  List<String> positiveTraits = [];
  List<FocusNode> focusNodes = [];
  List<String> dates = [];
  FocusNode myFocusNode = FocusNode();
  String positiveTraitsMainTitle = '';
  String positiveTraitsSubTitle = '';
  String sug1 = '';
  String sug2 = '';
  String sug3 = '';

  void loadData() async {
    setState(() {
      positiveTraits =
          widget.fakeSharedPreferencesStorage['positiveTraits'] ?? [];
      dates = widget.fakeSharedPreferencesStorage['positiveDates'] ?? [];
      for (var _ in positiveTraits) {
        focusNodes.add(FocusNode());
      }
    });
  }

  void changePositiveTrait(String text, int index) async {
    setState(() {
      positiveTraits[index] = text;
      widget.fakeSharedPreferencesStorage['positiveTraits'] = positiveTraits;
    });
  }

  void removePositiveTrait(int removeIndex) async {
    List<String> positivetraitsTemp =
        widget.fakeSharedPreferencesStorage['positiveTraits'] ?? [];
    List<String> positivedatesTemp =
        widget.fakeSharedPreferencesStorage['positiveDates'] ?? [];
    positivetraitsTemp.removeAt(removeIndex);
    positivedatesTemp.removeAt(removeIndex);
    setState(() {
      widget.fakeSharedPreferencesStorage['positiveTraits'] =
          positivetraitsTemp;
      positiveTraits = positivetraitsTemp;
      focusNodes.removeAt(removeIndex);
      widget.fakeSharedPreferencesStorage['positiveDates'] = positivedatesTemp;
      dates = positivedatesTemp;
    });
  }

  void addPositiveTrait(String positiveTrait) async {
    List<String> positivetraitsTemp =
        widget.fakeSharedPreferencesStorage['positiveTraits'] ?? [];
    List<String> positivedatesTemp =
        widget.fakeSharedPreferencesStorage['positiveDates'] ?? [];
    positivetraitsTemp.add(positiveTrait);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    positivedatesTemp.add(formattedDate);

    setState(() {
      widget.fakeSharedPreferencesStorage['positiveTraits'] =
          positivetraitsTemp;
      positiveTraits = positivetraitsTemp;
      focusNodes.add(FocusNode());

      widget.fakeSharedPreferencesStorage['positiveDates'] = positivedatesTemp;
      dates = positivedatesTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(''),
            content: Text(
              "פופ אפ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('hh'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
    loadData();

    sug1 =
        traitsSuggestionsList[Random().nextInt(traitsSuggestionsList.length)];
    sug2 =
        traitsSuggestionsList[Random().nextInt(traitsSuggestionsList.length)];
    sug3 =
        traitsSuggestionsList[Random().nextInt(traitsSuggestionsList.length)];
  }

  void editNotification(String text, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
            add: addPositiveTrait,
            index: index,
            edit: changePositiveTrait,
            text: text,
            formTitle: 'מעלה',
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateAnyDirection
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 20, 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            key: Key('addTraitPlus'),
                            onPressed: () {
                              editNotification("", 0);
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 50.0,
                              color: Colors.purple,
                            )),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            'רשימת מעלות',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('מעלות חיובייות'),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => ThankYou(
                        key: Key('positiveTrait$index'),
                        text: positiveTraits[index],
                        number: (index + 1),
                        edit: editNotification,
                        remove: removePositiveTrait,
                        myFocusNode: focusNodes[index],
                        date: dates[index],
                        color: Colors.purple,
                      ),
                  itemCount: positiveTraits.length),
              positiveTraits.isEmpty
                  ? Container()
                  : const Divider(
                      color: Colors.grey,
                      indent: 30,
                      endIndent: 30,
                    ),
              PositiveTraitItemSug(
                key: Key('positiveTraitSug1'),
                add: addPositiveTrait,
                inputText: sug1,
              ),
              PositiveTraitItemSug(
                key: Key('positiveTraitSug2'),
                add: addPositiveTrait,
                inputText: sug2,
              ),
              PositiveTraitItemSug(
                key: Key('positiveTraitSug3'),
                add: addPositiveTrait,
                inputText: sug3,
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    var indices = List<int>.generate(
                        traitsSuggestionsList.length, (i) => i);
                    indices.shuffle();
                    sug1 = traitsSuggestionsList[indices[0]];
                    sug2 = traitsSuggestionsList[
                        indices[traitsSuggestionsList.length > 1 ? 1 : 0]];
                    sug3 = traitsSuggestionsList[
                        indices[traitsSuggestionsList.length > 2 ? 2 : 0]];
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'הצעות אחרות',
                      style: TextStyle(color: Colors.green),
                    ),
                    SizedBox(width: 1.0),
                    Icon(
                      Icons.refresh,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
