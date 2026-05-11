import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/ai_usage/ai_usage_cubit.dart';
import 'package:tabiby/core/models/ai_usage_models.dart';
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

  void _onItemTapped(int index, {required bool isEnabled}) {
    if (!isEnabled) {
      messages(
        context,
        'ai_usage_limit_reached'.tr(context),
        AppColors.orangeColor,
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: SafeArea(
        child: BlocBuilder<AiUsageCubit, AiUsageState>(
          builder: (context, usageState) {
            final diagnosisRemaining = usageState
                .remainingByFeature[AiFeatureType.diagnosis]
                ?.remaining;
            final xrayRemaining = usageState
                .remainingByFeature[AiFeatureType.xrayAnalysis]
                ?.remaining;
            final bool diagnoseEnabled =
                (diagnosisRemaining == null || diagnosisRemaining > 0) ||
                (xrayRemaining == null || xrayRemaining > 0);
            final bool dietEnabled =
                true; // Diet screen should always be accessible; plan creation is limited inside the screen.

            return Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryColors,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
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
                    isEnabled: true,
                  ),
                  _buildNavItem(
                    1,
                    Icons.table_chart_outlined,
                    Icons.table_chart,
                    'my_appointments'.tr(context),
                    isEnabled: true,
                  ),
                  _buildNavItem(
                    2,
                    Icons.medical_services_outlined,
                    Icons.medical_services,
                    'diagnose'.tr(context),
                    isEnabled: diagnoseEnabled,
                  ),
                  _buildNavItem(
                    3,
                    Icons.restaurant_menu_outlined,
                    Icons.restaurant_menu,
                    'diet'.tr(context),
                    isEnabled: dietEnabled,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlineIcon,
    IconData solidIcon,
    String label, {
    required bool isEnabled,
  }) {
    final isSelected = _selectedIndex == index;

    // Defines the colors based on selection state
    final activeColor = AppColors.whiteColor;
    final inactiveColor = AppColors.whiteColor.withValues(
      alpha: 0.5,
    ); // Soft faded white

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index, isEnabled: isEnabled),
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
                color: !isEnabled
                    ? inactiveColor.withValues(alpha: 0.35)
                    : isSelected
                    ? activeColor
                    : inactiveColor,
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
                color: !isEnabled
                    ? inactiveColor.withValues(alpha: 0.35)
                    : isSelected
                    ? activeColor
                    : inactiveColor,
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
