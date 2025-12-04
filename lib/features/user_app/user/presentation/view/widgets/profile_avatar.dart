import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: const CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.primaryColors,
        backgroundImage: AssetImage('assets/images/user.png'),
        child: Align(
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
