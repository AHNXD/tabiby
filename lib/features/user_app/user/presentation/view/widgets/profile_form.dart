import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/enums.dart';
import '../../../../../../core/utils/validation.dart';
import '../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../auth/presentation/views/sign_up/view/widgets/custom_dropdown_field.dart';
import '../../../../../auth/presentation/views/sign_up/view/widgets/selectable_circle.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController fnController;
  final TextEditingController lnController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController residenceController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final String? maritalStatus;
  final bool? isSmoke;
  final ValueChanged<bool?> onSmokeChanged;
  final ValueChanged<String?> onMaritalStatusChanged;

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
    required this.isSmoke,
    required this.onSmokeChanged,
    required this.onMaritalStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hintText: 'first_name'.tr(context),
          controller: fnController,
          validator: (val) =>
              Validator.validate(val, ValidationState.normal, context),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          hintText: 'last_name'.tr(context),
          controller: lnController,
          validator: (val) =>
              Validator.validate(val, ValidationState.normal, context),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          hintText: 'email'.tr(context),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icons.email,
          validator: (val) =>
              Validator.validate(val, ValidationState.email, context),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          hintText: 'phone'.tr(context),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          suffixIcon: Icons.phone,
          validator: (val) =>
              Validator.validate(val, ValidationState.phoneNumber, context),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          hintText: 'address'.tr(context),
          controller: residenceController,
          suffixIcon: Icons.home,
          validator: (val) =>
              Validator.validate(val, ValidationState.normal, context),
        ),
        const SizedBox(height: 16),

        CustomDropdownField(
          hintText: 'marital_status'.tr(context),
          value: maritalStatus,
          items: [
            'single'.tr(context),
            'married'.tr(context),
            'divorced'.tr(context),
            'widowed'.tr(context),
          ],
          onChanged: onMaritalStatusChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'please_select_marital_status'.tr(context);
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'height'.tr(context),
                controller: heightController,
                keyboardType: TextInputType.number,
                suffixIcon: Icons.height,
                validator: (val) =>
                    Validator.validate(val, ValidationState.price, context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                hintText: 'weight'.tr(context),
                controller: weightController,
                keyboardType: TextInputType.number,
                suffixIcon: Icons.monitor_weight,
                validator: (val) =>
                    Validator.validate(val, ValidationState.price, context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'are_you_a_smoker'.tr(context),
                  style: const TextStyle(
                    color: AppColors.textFieldColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SelectableCircle(
              icon: Icons.check,
              isSelected: isSmoke == true,
              onTap: () => onSmokeChanged(true),
            ),
            const SizedBox(width: 10),
            SelectableCircle(
              icon: Icons.close,
              isSelected: isSmoke == false,
              selectedColor: Colors.red,
              onTap: () => onSmokeChanged(false),
            ),
          ],
        ),
      ],
    );
  }
}
