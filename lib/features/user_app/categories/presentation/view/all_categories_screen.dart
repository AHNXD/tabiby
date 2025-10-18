import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_appbar.dart';

Widget _buildCategoryGridItem(
  BuildContext context,
  Map<String, dynamic> category,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(category['icon'], width: 40, height: 40),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        category['name'],
        style: TextStyle(color: Colors.grey[700], fontSize: 14),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

class AllCategoriesScreen extends StatelessWidget {
  static const String routeName = "/categories";
  final List<Map<String, dynamic>> categories;

  const AllCategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppbar(title: "All Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryGridItem(context, categories[index]);
          },
        ),
      ),
    );
  }
}
