import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/home/presentation/view/home_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomeScreen.routeName: (context) => HomeScreen(),
  };
}
