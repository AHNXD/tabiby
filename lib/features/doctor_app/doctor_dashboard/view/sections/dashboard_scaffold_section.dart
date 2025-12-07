import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/home/presentation/view/widgets/build_appbar.dart';

class DashboardScaffold extends StatelessWidget {
  final Widget body;

  const DashboardScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppbar(isDoctor: true),
      body: SafeArea(child: body),
    );
  }
}
