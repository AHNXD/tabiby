import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../core/widgets/custom_appbar.dart';
class AppBarSection extends StatelessWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomAppbar(title: "book_appointment".tr(context));
  }
}
