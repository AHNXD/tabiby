import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final VoidCallback? onSeeAll;

  const CategoryItem({super.key, required this.categories, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(category['icon'], width: 32, height: 32),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  category['name'],
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
