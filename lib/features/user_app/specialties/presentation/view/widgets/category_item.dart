import 'package:flutter/material.dart';

class SpecialtyItem extends StatelessWidget {
  final List<Map<String, dynamic>> Specialties;
  final VoidCallback? onSeeAll;

  const SpecialtyItem({super.key, required this.Specialties, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: Specialties.length,
        itemBuilder: (context, index) {
          final Specialty = Specialties[index];
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(Specialty['icon'], width: 32, height: 32),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  Specialty['name'],
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
