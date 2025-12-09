import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/doctor_details/data/models/doctor_model.dart';

import '../../../../doctor_details/view/doctor_details_screen.dart';

class DoctorCard extends StatelessWidget {
  final Doctors doctor; 

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(
              doctorName: doctor.name ?? '',
              specialty: doctor.specialty?.name ?? '',
              experience: '15 ${"years_of_experience".tr(context)}',
              imageUrl: doctor.img ?? 'assets/images/doctor.png',
              rating: doctor.rate?.toString() ?? '0',
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
              color: Colors.black.withOpacity(0.3),
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
              child: 
              
             // doctor.img == null?
              Image.asset(
                 "assets/images/doctor.png",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
              // :Image.network(
              //   doctor.img!,
              //   height: 100,
              //   width: 100,
              //   fit: BoxFit.cover,
              // ),
            ),
            Text(
              doctor.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              doctor.specialty?.name ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.amber,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  doctor.rate?.toString() ?? '0',
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
