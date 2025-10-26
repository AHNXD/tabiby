import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../doctor_details/view/doctor_details_screen.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(
              doctorName: doctor['name'],
              specialty: doctor['specialty'],
              experience: '15 ${"years_of_experience".tr(context)}',
              imageUrl: doctor['image'],
              rating: doctor['rating'].toString(),
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                "assets/images/doctor.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              doctor['name'],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              doctor['specialty'],
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  doctor['isAvailable']
                      ? FontAwesomeIcons.circleCheck
                      : FontAwesomeIcons.circleXmark,
                  color: doctor['isAvailable']
                      ? Colors.green
                      : Colors.redAccent,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  doctor['isAvailable']
                      ? 'available'.tr(context)
                      : 'unavailable'.tr(context),
                  style: TextStyle(
                    color: doctor['isAvailable']
                        ? Colors.green
                        : Colors.redAccent,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.amber,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  '${doctor['rating']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
