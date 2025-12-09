import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  final File? pickedImageFile;
  final String? currentImageUrl;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    this.pickedImageFile,
    this.currentImageUrl,
    required this.onTap,
  });

  ImageProvider<Object> _getAvatarImage() {
    if (pickedImageFile != null) {
      return FileImage(pickedImageFile!);
    } else if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(currentImageUrl!);
    } else {
      return const AssetImage('assets/images/user.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.primaryColors,
        backgroundImage: _getAvatarImage(),
        child: const Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.edit, color: AppColors.primaryColors, size: 20),
          ),
        ),
      ),
    );
  }
}
