import 'package:flutter/material.dart';
import 'package:tabiby/features/shared/home/presentation/view/home_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomeScreen.routeName: (context) => HomeScreen(),
  };
}
