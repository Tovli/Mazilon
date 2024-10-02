import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WarningItem extends StatefulWidget {
  final String warning;
  const WarningItem({super.key, required this.warning});

  @override
  State<WarningItem> createState() => _WarningItemState();
}

class _WarningItemState extends State<WarningItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
          minHeight: 100, maxHeight: 100, maxWidth: 200, minWidth: 100),
      child: Card(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              minFontSize: 12,
              widget.warning,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: 'Rubix'),
            ),
          ),
        ),
      ),
    );
  }
}
