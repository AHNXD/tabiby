import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class CustomLoginSignUpAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomLoginSignUpAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topPadding =
        statusBarHeight + MediaQuery.of(context).size.height * 0.01;

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + topPadding),
      child: Container(
        padding: EdgeInsets.only(top: topPadding),
        color: AppColors.whiteColor,
        child: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.darkOverlayColor,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.darkOverlayColor,
              fontSize: 30,
            ),
          ),
          centerTitle: true,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}
