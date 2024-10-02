import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mazilon/pages/FeelGood/FeelGoodInheritedWidget.dart';
import 'package:mazilon/pages/FeelGood/add_Image_item.dart';
import 'package:mazilon/pages/FeelGood/image_display_item.dart';
import 'package:mazilon/pages/FeelGood/image_picker_service_impl.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeelGood extends StatefulWidget {
  const FeelGood({super.key});

  @override
  _FeelGoodPageState createState() => _FeelGoodPageState();
}

class _FeelGoodPageState extends State<FeelGood> {
  late ImagePickerService pickerService;
  List<String> imagePaths = [];
  late Future<void> _loadImagesFuture;
  //final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    pickerService = GetIt.instance<ImagePickerService>();
    _loadImagesFuture = _loadImagePaths();
  }

  Future<void> _loadImagePaths() async {
    await pickerService.loadImagePaths(imagePaths);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AppInformation appInfoProvider =
        Provider.of<AppInformation>(context, listen: true);
    return FeelGoodInheritedWidget(
      displayImage: pickerService.displayImage,
      imagePaths: [...imagePaths],
      getImage: (String source) async {
        await pickerService.getImage(source, imagePaths);
        setState(() {});
      },
      deleteImage: (int index) {
        setState(() {
          pickerService.deleteImage(index, imagePaths);
        });
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: SafeArea(
            child: Container(
              height: 130.0,
              child: Image.asset(
                'assets/images/Logo.png',
                width: MediaQuery.of(context).size.width * 0.4 > 1000
                    ? 500
                    : MediaQuery.of(context).size.width * 0.2,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: myAutoSizedText(
                    appInfoProvider.feelGoodPageTitles['header'] ?? '',
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    TextAlign.center,
                    60),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: myAutoSizedText(
                    appInfoProvider.feelGoodPageTitles['subHeader'],
                    TextStyle(fontSize: 18.sp),
                    null,
                    18),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Scrollbar(
                  //images uploaded from phone grid view:
                  child: FutureBuilder<void>(
                      future: _loadImagesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return GridView.builder(
                          itemCount: imagePaths.length +
                              1, // +1 for the camera/upload icon
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 items per row
                            crossAxisSpacing: 10, // horizontal spacing
                            mainAxisSpacing: 10, // vertical spacing
                          ),
                          itemBuilder: (context, index) {
                            // If this is the last item, return a grid item with the camera and upload icons
                            if (index == imagePaths.length) {
                              return ImageAddItem();
                            }
                            return ImageDisplay(
                              imagePath: imagePaths[index],
                              index: index,
                            );
                          },
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
