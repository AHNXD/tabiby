import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

class BuildAppbar extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;

  const BuildAppbar({super.key, this.onProfileTap, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'welcome_back'.tr(context),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text('Mr. Esam Derawan', style: TextStyle(fontSize: 18)),
          ],
        ),
        const Spacer(),

        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 244, 240, 240),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.grey, size: 26),
          ),
        ),
        const SizedBox(width: 10),

        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 244, 240, 240),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.grey,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
