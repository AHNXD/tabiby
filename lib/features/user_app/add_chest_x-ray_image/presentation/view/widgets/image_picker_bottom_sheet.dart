import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/xray_sections.dart';

class ImagePickerBottomSheet {
  static void show(
    BuildContext context,
    ValueChanged<ImageSource> onImageSourceSelected,
  ) {
    showXrayImageSourceSheet(context, onImageSourceSelected);
  }
}
