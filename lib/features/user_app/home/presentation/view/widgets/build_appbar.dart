import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class BuildAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BuildAppbar({
    super.key,
    required this.name,
    this.isDoctor = false,
    this.toolbarHeight = kToolbarHeight + 16.0,
  });
  final double toolbarHeight;
  final String name;
  final bool isDoctor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: toolbarHeight.toDouble(),
          decoration: BoxDecoration(
            color: AppColors.primaryColors,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ListTile(
            leading: const CircleAvatar(
              radius: 24,
              child: Icon(Icons.person, size: 36),
              // backgroundImage: AssetImage('assets/images/user.png'),
            ),
            title: Text(
              'welcome_back'.tr(context),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            subtitle: Text(
              '${isDoctor ? "dr".tr(context) : ""} $name',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            trailing: isDoctor
                ? Icon(Icons.logout, color: Colors.white)
                : Icon(Icons.notifications, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight.toDouble());
}
