import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class AppointmentItem extends StatelessWidget {
  final String day;
  final String month;
  final String doctorName;
  final String specialty;
  final String time;
  final String rating;
  final String avatarUrl;
  final String? doctorNotes;
  final String? prescription;

  const AppointmentItem({
    super.key,
    required this.day,
    required this.month,
    required this.doctorName,
    required this.specialty,
    required this.time,
    required this.rating,
    required this.avatarUrl,
    this.doctorNotes,
    this.prescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColors,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                month,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            if (doctorNotes != null || prescription != null)
              TextButton(
                onPressed: () {
                  _showDetailsDialog(context);
                },
                child: Text(
                  'see_more'.tr(context),
                  style: TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(avatarUrl)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${"took_it_at".tr(context)} $time',
                      style: const TextStyle(
                        color: Color(0xFF79BCA4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            Row(
              children: [
                Text(
                  rating,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.amber, size: 20),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE0E0E0), thickness: 1, height: 1),
      ],
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "details".tr(context),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColors,
                ),
              ),
              const SizedBox(height: 16),
              if (doctorNotes != null)
                _buildDetailSection(
                  icon: Icons.notes_rounded,
                  title: "doctor_notes".tr(context),
                  content: doctorNotes!,
                ),
              if (doctorNotes != null && prescription != null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(),
                ),
              if (prescription != null)
                _buildDetailSection(
                  icon: Icons.medical_services_rounded,
                  title: 'prescription'.tr(context),
                  content: prescription!,
                ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('close'.tr(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black54, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
