import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class ColoredTextTabBar extends StatelessWidget {
  const ColoredTextTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
    final List<_AppointmentTabData> tabs = [
      _AppointmentTabData(
        label: 'finished'.tr(context),
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.primaryColors,
      ),
      _AppointmentTabData(
        label: 'pending'.tr(context),
        icon: Icons.hourglass_top_rounded,
        color: AppColors.warningAccentColor,
      ),
      _AppointmentTabData(
        label: 'canceled'.tr(context),
        icon: Icons.cancel_outlined,
        color: AppColors.dangerSoftColor,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.sagePanelColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: AnimatedBuilder(
        animation: controller.animation!,
        builder: (context, _) {
          return TabBar(
            controller: controller,
            dividerColor: AppColors.transparentColor,
            indicatorSize: TabBarIndicatorSize.tab,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            splashBorderRadius: BorderRadius.circular(18),
            indicator: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            tabs: List.generate(tabs.length, (index) {
              final bool isSelected = controller.index == index;
              final _AppointmentTabData tab = tabs[index];

              return SizedBox(
                height: 54,
                child: Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: tab.color.withValues(
                            alpha: isSelected ? 0.14 : 0.08,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          tab.icon,
                          size: 14,
                          color: isSelected
                              ? tab.color
                              : AppColors.grey500Color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? tab.color
                                : AppColors.grey600Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _AppointmentTabData {
  const _AppointmentTabData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}
