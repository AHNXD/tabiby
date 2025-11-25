import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../core/widgets/custom_appbar.dart';

Widget _buildSpecialtyGridItem(
  BuildContext context,
  Map<String, dynamic> specialty,
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
            child: Image.asset(specialty['icon'], width: 40, height: 40),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        specialty['name'],
        style: TextStyle(color: Colors.grey[700], fontSize: 14),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

class AllSpecialtiesScreen extends StatelessWidget {
  static const String routeName = "/specialties";
  final List<Map<String, dynamic>> specialties;

  const AllSpecialtiesScreen({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppbar(title: "all_specialties".tr(context)),
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
          itemCount: specialties.length,
          itemBuilder: (context, index) {
            return _buildSpecialtyGridItem(context, specialties[index]);
          },
        ),
      ),
    );
  }
}
