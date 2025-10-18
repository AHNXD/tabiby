import 'package:flutter/material.dart';

import '../../../../user/view/user_profile.dart';
import '../widgets/build_appbar.dart';

class AppBarSection extends StatelessWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BuildAppbar(
      onProfileTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfileScreen(),
          ),
        );
      },
    );
  }
}
