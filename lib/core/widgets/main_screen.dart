import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/diagnose_mode_screen.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/diet_mode_screen.dart';
import 'package:tabiby/features/user_app/home/presentation/view/home_screen.dart';
import 'package:tabiby/features/user_app/user_appointments/presentation/view/appointment_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to Home screen

  final List<Widget> _screens = [
    const HomeScreen(),
    const UserAppointmentScreen(),
    const DiagnoseModeScreen(),
    const DietModeScreen(),
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

      bottomNavigationBar: SafeArea(
        child: Container(
          // Added bottom margin so it truly floats
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          height: 70, // Slightly taller to give the items room to breathe
          decoration: BoxDecoration(
            color: AppColors.primaryColors, // Your app's theme color
            borderRadius: BorderRadius.circular(35.0),
            boxShadow: [
              BoxShadow(
                // A soft colored glow instead of a harsh black shadow
                color: AppColors.textButtonColors.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                0,
                Icons.home_outlined,
                Icons.home,
                'home'.tr(context),
              ),
              _buildNavItem(
                1,
                Icons.table_chart_outlined,
                Icons.table_chart,
                'my_appointments'.tr(context),
              ),
              _buildNavItem(
                2,
                Icons.medical_services_outlined,
                Icons.medical_services,
                'diagnose'.tr(context),
              ),
              _buildNavItem(
                3,
                Icons.restaurant_menu_outlined,
                Icons.restaurant_menu,
                'diet'.tr(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlineIcon,
    IconData solidIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;

    // Defines the colors based on selection state
    final activeColor = AppColors.whiteColor;
    final inactiveColor = AppColors.whiteColor.withValues(
      alpha: 0.5,
    ); // Soft faded white

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isSelected ? solidIcon : outlineIcon,
                key: ValueKey<bool>(isSelected),
                color: isSelected ? activeColor : inactiveColor,
                size: isSelected ? 26 : 24,
              ),
            ),

            const SizedBox(height: 4),

            // Text Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: isSelected
                    ? 11
                    : 10, // Text gets slightly larger when active
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                fontFamily: Theme.of(
                  context,
                ).textTheme.bodyLarge?.fontFamily, // Preserves your app's font
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: Text(label),
            ),

            const SizedBox(height: 4),

            // Animated White Dot Indicator (Fixed color to pop against the background)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 4,
              width: isSelected ? 16 : 0,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
