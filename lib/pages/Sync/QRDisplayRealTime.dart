import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayQRPageRealTime extends StatelessWidget {
  final String transactionId;
  final DatabaseReference callback;

  DisplayQRPageRealTime({required this.transactionId, required this.callback});

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: true);

    return PopScope(
      canPop: true,
      onPopInvoked: (didpop) async {
        callback.remove().catchError((error) {
          print("Failed to delete data: $error");
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(appInfoProvider.syncPages['QRScannerBack'] ?? "")),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              callback
                  .remove()
                  .then((_) => {Navigator.pop(context)})
                  .catchError((error) {
                print("Failed to delete data: $error");
              });

              // Add your custom functionality here
              // For example, pop the current route:

              // Navigator.of(context).pop();
              // Or, you can navigate to another page, show a dialog, etc.
            },
          ),
        ),
        body: Center(
          child: QrImageView(
            data: transactionId,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
    );
  }
}
