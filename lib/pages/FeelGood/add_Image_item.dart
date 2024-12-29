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

    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    final gender = userInfoProvider.gender;
    final appLocale = AppLocalizations.of(context);
    return DottedBorder(
      color: Colors.grey,
      strokeWidth: 2,
      child: Center(
        child: TextButton(
          key: Key('addImgButtonText'),
          child: Text(
            appLocale!.addImageButton(gender),
            style: const TextStyle(
                fontSize: 24.0), // adjust the font size as needed
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  appLocale!.addImageTitle(gender),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        key: Key('cameraButtonText'),
                        child: Text(
                          appLocale!.camera,
                        ),
                        onPressed: () {
                          pickImage("camera");
                        },
                      ),
                      TextButton(
                        key: Key('galleryButtonText'),
                        child: Text(appLocale!.gallery),
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
