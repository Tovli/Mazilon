import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayQRPage extends StatelessWidget {
  final String uniqueKey;

  DisplayQRPage({required this.uniqueKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('סריקה'),
      ),
      body: Center(
        child: QrImageView(
          data: uniqueKey,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
