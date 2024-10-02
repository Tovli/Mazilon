import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'EmergencyPhonesTest.dart'; // Adjust the import path as necessary
import 'package:mockito/mockito.dart';
import 'package:url_launcher/url_launcher.dart';

class MockUrlLauncher extends Mock {
  Future<bool> canLaunchUrl(Uri url) => super.noSuchMethod(
        Invocation.method(#canLaunchUrl, [url]),
        returnValue: Future.value(true),
        returnValueForMissingStub: Future.value(false),
      );

  Future<void> launchUrl(Uri url) => super.noSuchMethod(
        Invocation.method(#launchUrl, [url]),
        returnValue: Future.value(),
        returnValueForMissingStub: Future.value(),
      );
}

class SimplifiedPhonePage extends StatelessWidget {
  final List<String> phoneNumbers;
  final Future<bool> Function(Uri url) canLaunchUrl;
  final Future<void> Function(Uri url) launchUrl;

  SimplifiedPhonePage({
    Key? key,
    required this.phoneNumbers,
    required this.canLaunchUrl,
    required this.launchUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ...phoneNumbers.map((number) => InkWell(
                  onTap: () async {
                    final url = Uri.parse('tel:$number');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      print('Could not launch $url');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text('Call $number', style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18)),
                  ),
                )),
            SizedBox(height: 20),
            EmergencyPhonesRow(), // Assuming this is a widget that displays emergency phone numbers
          ],
        ),
      ),
    );
  }
}
