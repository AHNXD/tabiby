import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/doctors/presentation/view/all_doctors_screen.dart';

import '../../../../../../core/utils/assets_data.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';
import '../../../data/models/centers_model.dart' show Clinics;

class ClinicTile extends StatelessWidget {
  final int centerID;

  final Clinics clinic;

  const ClinicTile({super.key, required this.centerID, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: ClipOval(
          child: CustomImageWidget(
            imageUrl: clinic.image,
            placeholderAsset: AssetsData.appIcon,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          clinic.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(
            context,
            AllDoctorsScreen.routeName,
            arguments: {'centerID': centerID, 'specialtyID': clinic.id},
          );
        },
      ),
    );
  }
}
