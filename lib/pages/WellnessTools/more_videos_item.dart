import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/pages/FeelGood/image_picker_service_impl.dart';
import 'package:mazilon/pages/WellnessTools/VideoPlayerInheritedWidget.dart';
import 'package:mazilon/pages/WellnessTools/VideoPlayerPageFactory.dart';
import 'package:mazilon/util/styles.dart';

class MoreVideosItem extends StatelessWidget {
  final Map<String, List<String>> videoData;
  final int index;
  final String thumbnailUrl;
  final Function changeVidoeIdIndex;

  MoreVideosItem({
    required this.videoData,
    required this.index,
    required this.thumbnailUrl,
    required this.changeVidoeIdIndex,
  });

  @override
  Widget build(BuildContext context) {
    final ImagePickerService imageService =
        GetIt.instance<ImagePickerService>();
    return Container(
      width: 150,
      height: 100,
      child: GestureDetector(
        onTap: changeVidoeIdIndex(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 150,
              child: imageService.getOnlineImage(thumbnailUrl),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  myAutoSizedText(
                    videoData['videoHeadline']![index],
                    TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    TextAlign.right,
                    20,
                    2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
