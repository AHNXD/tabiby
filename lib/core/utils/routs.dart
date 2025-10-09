import 'package:flutter/material.dart';
import '../../features/home/presentation/views/home_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomePage.routeName: (context) => HomePage(),
  };
}
