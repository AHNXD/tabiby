import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/validation.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import 'custom_dropdown_field.dart';

const List<String> _bloodTypeOptions = <String>[
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

class Step2Widget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String?> onBloodTypeChanged;
  final TextEditingController addressCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController heightCtrl;
  final String? selectedGender;
  final String? bloodType;

  const Step2Widget({
    super.key,
    required this.formKey,
    required this.onNext,
    required this.onGenderChanged,
    required this.onBloodTypeChanged,
    required this.addressCtrl,
    required this.weightCtrl,
    required this.heightCtrl,
    this.selectedGender,
    this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              children: [
                const SizedBox(height: 4),
                CustomTextField(
                  hintText: 'address'.tr(context),
                  controller: addressCtrl,
                  suffixIcon: Icons.location_on_outlined,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.normal, context),
                ),
                const SizedBox(height: 18),
                CustomDropdownField(
                  hintText: 'gender'.tr(context),
                  prefixIcon: Icons.wc_rounded,
                  items: ['male', 'female'],
                  value: selectedGender,
                  onChanged: (value) {
                    if (value != null) onGenderChanged(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_select_gender'.tr(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                CustomDropdownField(
                  hintText: 'blood_type'.tr(context),
                  prefixIcon: Icons.bloodtype_outlined,
                  items: _bloodTypeOptions,
                  value: bloodType,
                  onChanged: onBloodTypeChanged,
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  hintText: 'weight'.tr(context),
                  controller: weightCtrl,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.price, context),
                  suffixIcon: Icons.monitor_weight_rounded,
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  hintText: 'height'.tr(context),
                  controller: heightCtrl,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.price, context),
                  suffixIcon: Icons.height,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          SecondryButton(text: 'next'.tr(context), onPressed: onNext),
        ],
      ),
    );
  }
}
