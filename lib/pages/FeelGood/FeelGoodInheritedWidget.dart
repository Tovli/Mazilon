import 'package:flutter/material.dart';

// InheritedWidget to manage video state
class FeelGoodInheritedWidget extends InheritedWidget {
  final List<String> imagePaths;
  final Function(String source) getImage;
  final Function(String path, {BoxFit fit}) displayImage;
  final Function(int index) deleteImage;
  // Method to change video

  const FeelGoodInheritedWidget({
    super.key,
    required this.imagePaths,
    required this.getImage,
    required this.deleteImage,
    required super.child,
    required this.displayImage,
  });

  // Convenience method to access the nearest instance of VideoPlayerInheritedWidget
  static FeelGoodInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FeelGoodInheritedWidget>();
  }

  @override
  bool updateShouldNotify(FeelGoodInheritedWidget oldWidget) {
    if (imagePaths.length != oldWidget.imagePaths.length) {
      return true;
    }
    for (int i = 0; i < imagePaths.length; i++) {
      if (imagePaths[i] != oldWidget.imagePaths[i]) {
        return true;
      }
    }

    return false; // Notify children when videoId changes
  }
}
