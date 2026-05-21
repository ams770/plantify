import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AppFilePicker {
  final ImagePicker _imagePicker;
  AppFilePicker(this._imagePicker);

  Future<File?> pickSingleImageOrVid() async {
    try {
      FilePickerResult? file = await FilePicker.pickFiles(type: FileType.media);
      if (file != null) return File(file.files.first.path!);
    } catch (e) {}
    return null;
  }

  Future<File?> pickSingleImage() async {
    try {
      FilePickerResult? file = await FilePicker.pickFiles(type: FileType.image);
      if (file != null) return File(file.files.first.path!);
    } catch (e) {}
    return null;
  }

  Future<XFile?> catchCameraImage({int? quality}) async {
    return await _imagePicker.pickImage(
      source: ImageSource.camera,
      // preferredCameraDevice: CameraDevice.values.last,
      imageQuality: quality,
    );
  }

  Future<List<XFile?>> pickMultiImages() async {
    return await _imagePicker.pickMultiImage();
  }
}
