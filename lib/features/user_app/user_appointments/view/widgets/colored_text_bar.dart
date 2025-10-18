import 'package:flutter/material.dart';

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
                'Finished',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.index == 0 ? tabColors[0] : Colors.grey,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Canceled',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.index == 1 ? tabColors[1] : Colors.grey,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Pending',
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
