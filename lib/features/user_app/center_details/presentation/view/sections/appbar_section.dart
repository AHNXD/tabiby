import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../core/widgets/custom_appbar.dart';

class AppBarSection extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      title: "center_details".tr(context),
      onBackButtonPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
