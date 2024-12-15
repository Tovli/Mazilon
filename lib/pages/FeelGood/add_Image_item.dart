import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mazilon/pages/FeelGood/FeelGoodInheritedWidget.dart';
import 'package:mazilon/util/appInformation.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:mazilon/util/userInformation.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageAddItem extends StatefulWidget {
  ImageAddItem({Key? key}) : super(key: key);
  @override
  _ImageAddItemState createState() => _ImageAddItemState();
}

class _ImageAddItemState extends State<ImageAddItem> {
  @override
  Widget build(BuildContext context) {
    void pickImage(String source) {
      Navigator.of(context).pop();
      FeelGoodInheritedWidget.of(context)?.getImage(source);
    }

    final AppInformation appInfoProvider =
        Provider.of<AppInformation>(context, listen: true);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    final gender = userInfoProvider.gender;

    return DottedBorder(
      color: Colors.grey,
      strokeWidth: 2,
      child: Center(
        child: TextButton(
          key: Key('addImgButtonText'),
          child: Text(
            AppLocalizations.of(context)!.addImageButton(gender),
            style: const TextStyle(
                fontSize: 24.0), // adjust the font size as needed
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.addImageTitle(gender),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        key: Key('cameraButtonText'),
                        child: Text(
                          AppLocalizations.of(context)!.camera,
                        ),
                        onPressed: () {
                          pickImage("camera");
                        },
                      ),
                      TextButton(
                        key: Key('galleryButtonText'),
                        child: Text(AppLocalizations.of(context)!.gallery),
                        onPressed: () {
                          pickImage("gallery");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
