import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import 'package:tabiby/features/auth/presentation/views/sign_up/view/widgets/custom_dropdown_field.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import '../../../../../../shared/privacy_policy/presentation/view/privacy_policy_screen.dart';
import '../../../../../../shared/terms_and_condition_screen/presentation/view/terms_and_conditions_screen.dart';
import 'number_of_children_field.dart';
import 'selectable_circle.dart';

class Step3Widget extends StatefulWidget {
  final bool? hasChildren;
  final bool? isSmoke;
  final int numberOfChildren;
  final bool agreeToTerms;
  final String gender;
  final String? maritalStatus;
  final DateTime? selectedDate;
  final bool isLoading;

  final ValueChanged<bool?> onChildrenChanged;
  final ValueChanged<bool?> onSmokeChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAgreeToggle;
  final VoidCallback onSignUp;
  final ValueChanged<String> onMaritalStatusChanged;
  final ValueChanged<DateTime> onDateChanged;

  const Step3Widget({
    super.key,
    required this.hasChildren,
    required this.isSmoke,
    required this.numberOfChildren,
    required this.agreeToTerms,
    required this.gender,
    required this.maritalStatus,
    required this.selectedDate,
    required this.isLoading,
    required this.onChildrenChanged,
    required this.onSmokeChanged,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAgreeToggle,
    required this.onSignUp,
    required this.onMaritalStatusChanged,
    required this.onDateChanged,
  });

  @override
  State<Step3Widget> createState() => _Step3WidgetState();
}

class _Step3WidgetState extends State<Step3Widget> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
    );

    if (picked != null) {
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMale =
        widget.gender == 'male'.tr(context) || widget.gender == 'Male';

    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 32),
            children: [
              const SizedBox(height: 30),
              CustomDropdownField(
                hintText: 'marital_status'.tr(context),
                items: [
                  "single".tr(context),
                  "married".tr(context),
                  "divorced".tr(context),
                  "widowed".tr(context),
                ],
                value: widget.maritalStatus,
                onChanged: (value) {
                  if (value != null) {
                    widget.onMaritalStatusChanged(value);
                  }
                },
              ),
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
                            style: const TextStyle(
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
                    isSelected: widget.isSmoke == true,
                    onTap: () => widget.onSmokeChanged(true),
                  ),
                  const SizedBox(width: 10),
                  SelectableCircle(
                    icon: Icons.close,
                    isSelected: widget.isSmoke == false,
                    selectedColor: Colors.red,
                    onTap: () => widget.onSmokeChanged(false),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // --- Date of Birth Field ---
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.selectedDate == null
                          ? 'select_your_birth'.tr(context)
                          : DateFormat(
                              'dd-MM-yyyy',
                            ).format(widget.selectedDate!),
                      style: TextStyle(
                        color: widget.selectedDate == null
                            ? AppColors.textFieldColor
                            : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // --- Bottom Section: Terms & Button ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
          child: Column(
            children: [
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
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
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
                          TextSpan(
                            text: 'read_and_agree_conditions'.tr(context),
                          ),
                          TextSpan(
                            text: 'terms_conditions'.tr(context),
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(
                                context,
                                TermsAndConditionsScreen.routeName,
                              ),
                          ),
                          TextSpan(text: ' ${"and".tr(context)} '),
                          TextSpan(
                            text: 'privacy_policy'.tr(context),
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(
                                context,
                                PrivacyPolicyScreen.routeName,
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // --- Sign Up Button with Loading State ---
              widget.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColors,
                      ),
                    )
                  : SecondryButton(
                      text: 'sign_up'.tr(context),
                      onPressed: widget.onSignUp,
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
