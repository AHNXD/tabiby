import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/validation.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import 'custom_dropdown_field.dart';

class Step2Widget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final ValueChanged<String> onGenderChanged;
  final TextEditingController addressCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController heightCtrl;
  final String? selectedGender;

  const Step2Widget({
    super.key,
    required this.formKey,
    required this.onNext,
    required this.onGenderChanged,
    required this.addressCtrl,
    required this.weightCtrl,
    required this.heightCtrl,
    this.selectedGender,
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
              padding: const EdgeInsets.symmetric(horizontal: 32),
              children: [
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'address'.tr(context),
                  controller: addressCtrl,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.normal, context),
                ),
                const SizedBox(height: 30),
                CustomDropdownField(
                  hintText: 'gender'.tr(context),
                  items: ['male'.tr(context), 'female'.tr(context)],
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
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'weight'.tr(context),
                  controller: weightCtrl,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.price, context),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'height'.tr(context),
                  controller: heightCtrl,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.price, context),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          SecondryButton(text: 'next'.tr(context), onPressed: onNext),
        ],
      ),
    );
  }
}
