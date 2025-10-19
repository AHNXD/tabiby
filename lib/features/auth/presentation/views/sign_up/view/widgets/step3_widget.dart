import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import '../../../../../../user_app/home/presentation/view/home_screen.dart';
import 'number_of_children_field.dart';
import 'selectable_circle.dart'; // ✅ لإظهار التاريخ بشكل جميل

class Step3Widget extends StatefulWidget {
  final bool? hasChildren;
  final int numberOfChildren;
  final bool agreeToTerms;
  final String gender;

  final ValueChanged<bool?> onChildrenChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAgreeToggle;
  final VoidCallback onSignUp;

  const Step3Widget({
    super.key,
    required this.hasChildren,
    required this.numberOfChildren,
    required this.agreeToTerms,
    required this.gender,
    required this.onChildrenChanged,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAgreeToggle,
    required this.onSignUp,
  });

  @override
  State<Step3Widget> createState() => _Step3WidgetState();
}

class _Step3WidgetState extends State<Step3Widget> {
  DateTime? _selectedDate; // 👈 لتخزين التاريخ المختار

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMale = widget.gender == "Male";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          CustomTextField(hintText: 'marital_status'.tr(context)),
          const SizedBox(height: 30),

          // --- Have Children ---
          Opacity(
            opacity: isMale ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: isMale,
              child: Row(
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
                        'have_children'.tr(context),
                        style: TextStyle(
                          color: AppColors.textFieldColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SelectableCircle(
                    icon: Icons.check,
                    isSelected: widget.hasChildren == true,
                    onTap: () => widget.onChildrenChanged(true),
                  ),
                  const SizedBox(width: 10),
                  SelectableCircle(
                    icon: Icons.close,
                    isSelected: widget.hasChildren == false,
                    selectedColor: Colors.red,
                    onTap: () => widget.onChildrenChanged(false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // --- Number of Children ---
          Opacity(
            opacity: isMale ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: isMale,
              child: Row(
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
                        'number_of_children'.tr(context),
                        style: TextStyle(
                          color: AppColors.textFieldColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  NumberOfChildrenField(
                    enabled: widget.hasChildren == true,
                    value: widget.numberOfChildren,
                    onIncrement: widget.onIncrement,
                    onDecrement: widget.onDecrement,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // --- Date of Birth Field ---
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedDate == null
                      ? 'select_your_birth'.tr(context)
                      : DateFormat('dd-MM-yyyy').format(_selectedDate!),
                  style: TextStyle(
                    color: _selectedDate == null
                        ? AppColors.textFieldColor
                        : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          const SizedBox(height: 60),

          // --- Agree to Terms ---
          Row(
            children: [
              GestureDetector(
                onTap: widget.onAgreeToggle,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.agreeToTerms
                        ? AppColors.primaryColors
                        : Colors.transparent,
                    border: Border.all(
                      color: widget.agreeToTerms
                          ? AppColors.primaryColors
                          : AppColors.textColor,
                      width: 1.5,
                    ),
                  ),
                  child: widget.agreeToTerms
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textColor,
                    ),
                    children: [
                      TextSpan(text: 'read_and_agree_conditions'.tr(context)),
                      TextSpan(
                        text: 'terms_conditions'.tr(context),
                        style: const TextStyle(
                          color: AppColors.primaryColors,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                       TextSpan(text: ' ${"and".tr(context)} '),
                      TextSpan(
                        text: 'privacy_policy'.tr(context),
                        style: const TextStyle(
                          color: AppColors.primaryColors,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // --- Sign Up Button ---
          SecondryButton(
            text: 'sign_up'.tr(context),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
