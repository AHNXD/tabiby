import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/home/presentation/view/home_screen.dart';
import 'package:tabiby/features/user_app/user/presentation/view/user_profile.dart';
import 'package:tabiby/features/user_app/user_appointments/view/appointment_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  // List of the actual screens to display in the body
  final List<Widget> _screens = [
    const UserAppointmentScreen(),
    const HomeScreen(),
    const UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),

      // The Bottom Navigation Bar for switching tabs
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.table_chart_outlined),
            activeIcon: const Icon(Icons.table_chart),
            label: 'my_appointments'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'home'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'my_profile'.tr(context),
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColors,
        unselectedItemColor: AppColors.baseShimmerColor,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        elevation: 10,
      ),
    );
  }
}
