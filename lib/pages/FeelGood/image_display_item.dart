import 'package:flutter/material.dart';
import 'package:mazilon/pages/FeelGood/FeelGoodInheritedWidget.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageDisplay extends StatelessWidget {
  final String imagePath;
  final int index;

  const ImageDisplay({super.key, required this.imagePath, required this.index});
  @override
  Widget build(BuildContext context) {
    final Function(String path, {BoxFit fit}) displayImage =
        FeelGoodInheritedWidget.of(context)?.displayImage ??
            (String path, {BoxFit fit = BoxFit.none}) {};

    final appLocale = AppLocalizations.of(context);
    final UserInformation userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final gender = userInfoProvider.gender;
    final Function(int index) deleteImageFunction =
        FeelGoodInheritedWidget.of(context)?.deleteImage ?? (int index) {};
    return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Column(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: displayImage(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        key: Key('deleteButtonIcon'),
                        child: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                TextButton(
                                  child: Text(
                                    appLocale!.closeButton(gender),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  key: Key('deleteButtonText'),
                                  child: Text(
                                    appLocale!.deleteButton(gender),
                                  ),
                                  onPressed: () {
                                    deleteImageFunction(index); // Delete image
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        //actual image displayed when clicked on image in above grid:
        child: displayImage(
          imagePath,
          fit: BoxFit.cover,
        ));
  }
}
