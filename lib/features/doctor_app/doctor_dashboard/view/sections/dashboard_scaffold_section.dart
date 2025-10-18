import 'package:flutter/material.dart';

import 'appBar_section.dart';

class DashboardScaffold extends StatelessWidget {
  final Widget body;

  const DashboardScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(child: body),
    );
  }
}
