import 'package:flutter/material.dart';

import 'package:mazilon/pages/FeelGood/FeelGoodInheritedWidget.dart';
import 'package:mazilon/util/appInformation.dart';

import 'package:dotted_border/dotted_border.dart';

import 'package:provider/provider.dart';

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
    return DottedBorder(
      color: Colors.grey,
      strokeWidth: 2,
      child: Center(
        child: TextButton(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              key: Key('addImgButtonText'),
              appInfoProvider.feelGoodPageTitles['addImgButtonText'] ??
                  'הוספת תמונה',
              style: const TextStyle(
                  fontSize: 24.0), // adjust the font size as needed
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: Text(
                      appInfoProvider.feelGoodPageTitles['alertButtonTitle'] ??
                          'הוספת תמונה'),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          key: Key('cameraButtonText'),
                          child: Text(appInfoProvider
                                  .feelGoodPageTitles['cameraButtonText'] ??
                              'מצלמה'),
                          onPressed: () {
                            pickImage("camera");
                          },
                        ),
                        TextButton(
                          key: Key('galleryButtonText'),
                          child: Text(appInfoProvider
                                  .feelGoodPageTitles['galleryButtonText'] ??
                              'גלריה'),
                          onPressed: () {
                            pickImage("gallery");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
