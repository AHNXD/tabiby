import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_appbar.dart';


class AppBarSection extends StatelessWidget implements PreferredSizeWidget {

  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      title:  "Clinic Details",
      onBackButtonPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
