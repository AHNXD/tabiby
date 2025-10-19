import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

class ColoredTextTabBar extends StatelessWidget {
  const ColoredTextTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);

    final List<Color> tabColors = [
      const Color(0xFF79BCA4), // Finished
      Colors.red,              // Canceled
      Colors.amber,            // Pending
    ];

    return AnimatedBuilder(
      animation: controller.animation!,
      builder: (context, _) {
        return TabBar(
          controller: controller,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: tabColors[controller.index],
            ),
            insets: const EdgeInsets.symmetric(horizontal: 16),
          ),
          tabs: [
            Tab(
              child: Text(
                'finished'.tr(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.index == 0 ? tabColors[0] : Colors.grey,
                ),
              ),
            ),
            Tab(
              child: Text(
                'canceled'.tr(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.index == 1 ? tabColors[1] : Colors.grey,
                ),
              ),
            ),
            Tab(
              child: Text(
                'pending'.tr(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.index == 2 ? tabColors[2] : Colors.grey,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
