import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import 'custom_dropdown_field.dart';

class Step2Widget extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<String> onGenderChanged;

  const Step2Widget({
    super.key,
    required this.onNext,
    required this.onGenderChanged,
  });

  @override
  State<Step2Widget> createState() => _Step2WidgetState();
}

class _Step2WidgetState extends State<Step2Widget> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          const SizedBox(height: 30),

          // --- Housing ---
          CustomTextField(hintText: 'housing'.tr(context)),
          const SizedBox(height: 30),

          // --- Gender Dropdown ---
          CustomDropdownField(
            hintText: 'gender'.tr(context),
            items: ['male'.tr(context), 'female'.tr(context)],
            value: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });

              if (value != null) {
                widget.onGenderChanged(value);
              }
            },
          ),
          const SizedBox(height: 30),

          // --- Weight ---
          CustomTextField(hintText: 'weight'.tr(context)),
          const SizedBox(height: 30),

          // --- Height ---
          CustomTextField(hintText: 'height'.tr(context)),
          const SizedBox(height: 40),

          // --- Next Button ---
          SecondryButton(text: 'next'.tr(context), onPressed: widget.onNext),
        ],
      ),
    );
  }
}
