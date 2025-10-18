import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController residenceController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final String? maritalStatus;
  final String? isSmoker;
  final ValueChanged<String?> onMaritalStatusChanged;
  final ValueChanged<String?> onIsSmokerChanged;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.residenceController,
    required this.heightController,
    required this.weightController,
    required this.maritalStatus,
    required this.isSmoker,
    required this.onMaritalStatusChanged,
    required this.onIsSmokerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryColors,
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primaryColors,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value == null || !value.contains('@')
              ? 'Please enter a valid email'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primaryColors,
            ),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: residenceController,
          decoration: InputDecoration(
            labelText: 'Residence',
            prefixIcon: const Icon(
              Icons.home_outlined,
              color: AppColors.primaryColors,
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: maritalStatus,
          decoration: InputDecoration(
            labelText: 'Marital Status',
            prefixIcon: const Icon(
              Icons.favorite_border,
              color: AppColors.primaryColors,
            ),
          ),
          items: ['Single', 'Married', 'Divorced', 'Widowed']
              .map(
                (label) => DropdownMenuItem(value: label, child: Text(label)),
              )
              .toList(),
          onChanged: onMaritalStatusChanged,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: heightController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: const Icon(
                    Icons.height,
                    color: AppColors.primaryColors,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: const Icon(
                    Icons.monitor_weight_outlined,
                    color: AppColors.primaryColors,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: isSmoker,
          decoration: InputDecoration(
            labelText: 'Smoker',
            prefixIcon: Icon(Icons.smoke_free, color: AppColors.primaryColors),
          ),
          items: ['Yes', 'No']
              .map(
                (label) => DropdownMenuItem(value: label, child: Text(label)),
              )
              .toList(),
          onChanged: onIsSmokerChanged,
        ),
      ],
    );
  }
}
