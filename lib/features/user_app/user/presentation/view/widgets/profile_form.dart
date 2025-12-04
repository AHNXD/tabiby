import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../core/utils/colors.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController fnController;
  final TextEditingController lnController;
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
    required this.fnController,
    required this.lnController,
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
          controller: fnController,
          decoration: InputDecoration(
            labelText: 'first_name'.tr(context),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryColors,
            ),
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your first name'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: lnController,
          decoration: InputDecoration(
            labelText: 'last_name'.tr(context),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryColors,
            ),
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your last name'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'email'.tr(context),
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
            labelText: 'phone'.tr(context),
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
            labelText: 'residence'.tr(context),
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
            labelText: 'marital_status'.tr(context),
            prefixIcon: const Icon(
              Icons.favorite_border,
              color: AppColors.primaryColors,
            ),
          ),
          items:
              [
                    'single'.tr(context),
                    'married'.tr(context),
                    'divorced'.tr(context),
                    'widowed'.tr(context),
                  ]
                  .map(
                    (label) =>
                        DropdownMenuItem(value: label, child: Text(label)),
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
                  labelText: 'height'.tr(context),
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
                  labelText: 'weight'.tr(context),
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
            labelText: 'smoker'.tr(context),
            prefixIcon: Icon(Icons.smoke_free, color: AppColors.primaryColors),
          ),
          items: ['yes'.tr(context), 'no'.tr(context)]
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
