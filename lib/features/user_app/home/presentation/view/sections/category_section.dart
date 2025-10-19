import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../categories/presentation/view/all_categories_screen.dart';
import '../../../../categories/presentation/view/widgets/category_item.dart';
import '../widgets/data.dart';
import '../widgets/section_header.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'find_your_doctor'.tr(context),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AllCategoriesScreen(categories: categories),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        CategoryItem(categories: categories),
      ],
    );
  }
}
