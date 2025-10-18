import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import 'custom_dropdown_field.dart';

class Step2Widget extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<String>
  onGenderChanged; // 👈 نُضيف هذا السطر لتمرير قيمة الجنس

  const Step2Widget({
    super.key,
    required this.onNext,
    required this.onGenderChanged, // 👈 مطلوب من الأب (SignUpScreen)
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
          const CustomTextField(hintText: 'Housing'),
          const SizedBox(height: 30),

          // --- Gender Dropdown ---
          CustomDropdownField(
            hintText: 'Gender',
            items: const ['Male', 'Female'],
            value: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });

              if (value != null) {
                widget.onGenderChanged(value); // 👈 نُعيد القيمة للشاشة الأب
              }
            },
          ),
          const SizedBox(height: 30),

          // --- Weight ---
          const CustomTextField(hintText: 'Weight'),
          const SizedBox(height: 30),

          // --- Height ---
          const CustomTextField(hintText: 'Height'),
          const SizedBox(height: 40),

          // --- Next Button ---
          SecondryButton(text: 'Next', onPressed: widget.onNext),
        ],
      ),
    );
  }
}
