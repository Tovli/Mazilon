// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DisclaimerPage extends StatefulWidget {
  final Map<String, dynamic> fakeSharedPreferencesStorage;
  const DisclaimerPage({
    super.key,
    required this.fakeSharedPreferencesStorage,
  });
  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  @override
  Widget build(BuildContext context) {
    void updateDisclaimers() async {
      widget.fakeSharedPreferencesStorage['disclaimerConfirmed'] = true;
    }

    //if (appInfoProvider.disclaimerText.length == 0) {
    // return const Center(child: Introduction());
    // }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 100.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    "appInfoProvider.disclaimerText",
                  ),
                ),
                Container(
                  key: Key("accept"),
                  width: MediaQuery.of(context).size.width > 1000
                      ? 600
                      : MediaQuery.of(context).size.width * 0.6,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        updateDisclaimers();
                      });
                    },
                    child: Text('אישור'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
