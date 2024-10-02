import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

abstract class ImagePickerService {
  Future<XFile?> pickImage({required ImageSource source});
  Future<File> saveImagePaths(List<String> imagePaths);
  Future<void> getImage(String source, List<String> imagePaths);
  void deleteImage(int index, List<String> imagePaths);
  Future<void> loadImagePaths(List<String> imagePaths);
  displayImage(String path, {BoxFit fit = BoxFit.none});
  Widget getOnlineImage(String url);
}

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<XFile?> pickImage({required ImageSource source}) {
    return _picker.pickImage(source: source);
  }

  @override
  Future<File> saveImagePaths(List<String> imagePaths) async {
    final file = await getImagePathFile();
    return file.writeAsString(imagePaths.join('\n'));
  }

  @override
  Future<void> getImage(String source, List<String> imagePaths) async {
    ImageSource imageSource =
        source == 'camera' ? ImageSource.camera : ImageSource.gallery;
    try {
      final pickedFile = await _picker.pickImage(source: imageSource);

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final savedImage =
            await File(pickedFile.path).copy('${appDir.path}/$fileName');

        print("took");
        print(savedImage.path);
        imagePaths.add(savedImage.path);
        saveImagePaths(imagePaths);
      }
    } catch (e) {
      print(e);
      print('No Image Selected');
    }
  }

  @override
  void deleteImage(int index, List<String> imagePaths) {
    File(imagePaths[index]).deleteSync();
    imagePaths.removeAt(index);
    saveImagePaths(imagePaths);
  }

  @override
  Future<void> loadImagePaths(List<String> imagePaths) async {
    try {
      final file = await getImagePathFile();
      String contents = await file.readAsString();

      imagePaths.addAll(
          contents.split('\n').where((path) => path.isNotEmpty).toList());
    } catch (e) {
      // If encountering an error, return an empty list

      imagePaths = [];
    }
  }

  Future<File> getImagePathFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/imagePaths.txt');
  }

  @override
  Image displayImage(String path, {BoxFit fit = BoxFit.none}) {
    return Image.file(
      File(path),
      fit: fit,
    );
  }

  @override
  getOnlineImage(String url) {
    return Image.network(url);
  }
}
