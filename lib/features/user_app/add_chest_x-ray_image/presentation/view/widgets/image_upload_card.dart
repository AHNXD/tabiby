import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/xray_sections.dart';

class ImageUploadCard extends StatelessWidget {
  const ImageUploadCard({
    super.key,
    required this.selectedImage,
    required this.onTap,
  });

  final File? selectedImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return XrayUploadCard(imagePath: selectedImage?.path, onPick: onTap);
  }
}
