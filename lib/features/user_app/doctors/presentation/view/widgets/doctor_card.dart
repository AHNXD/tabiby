import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../doctor_details/view/doctor_details_screen.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ✅ Navigation to details screen remains the same
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(
              doctorName: doctor['name'],
              specialty: doctor['specialty'],
              experience: '15 Years of Experience',
              imageUrl: doctor['image'],
              rating: doctor['rating'].toString(),
            ),
          ),
        );
      },
      // The Stack's parent (the GridView cell) has a defined size.
      // We use Clip.none to allow the image to draw outside these bounds.
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 1. The white card container at the bottom
          Positioned(
            bottom: 0, // Pin the card to the bottom of the available space
            left: 0,
            right: 0,
            child: Container(
              height: 125, // Set a fixed height for the card itself
              padding: const EdgeInsets.only(
                // Leave space at the top for the overlapping image
                top: 45,
                bottom: 10,
                right: 10,
                left: 10,
              ),
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
                  Text(
                    doctor['name'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
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
                        color: doctor['isAvailable'] ? Colors.green : Colors.redAccent,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        doctor['isAvailable'] ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          color: doctor['isAvailable'] ? Colors.green : Colors.redAccent,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 8), // Spacer
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
          ),
          // 2. The overflowing doctor image at the top
          Positioned(
            // A negative 'top' value pushes the widget upwards,
            // outside the Stack's original bounds.
            top: -20,
            child: Image.asset(
              "assets/images/doctor.png", // Use the dynamic image from your data
              height: 100, // Define a clear size for the image
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}