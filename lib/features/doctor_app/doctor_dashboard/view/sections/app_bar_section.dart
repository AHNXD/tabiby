import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
    title: const Text('Hello, Dr. Smith!'),
    actions: [
      IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
      const Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/doctor4.png'),
        ),
      ),
    ],
  );
}
