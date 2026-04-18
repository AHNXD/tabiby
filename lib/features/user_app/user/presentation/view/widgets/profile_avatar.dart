import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../../core/utils/assets_data.dart';

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
      return const AssetImage(AssetsData.defaultProfileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(54),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 108,
              height: 108,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.mintSurfaceColor, AppColors.whiteColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColors.withValues(alpha: 0.18),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image(image: _getAvatarImage(), fit: BoxFit.cover),
                ),
              ),
            ),
            PositionedDirectional(
              end: -6,
              bottom: -6,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primaryColors,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
