import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/enums.dart';
import '../../../../../../core/utils/validation.dart';
import '../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../auth/presentation/views/sign_up/view/widgets/custom_dropdown_field.dart';
import '../../../../../auth/presentation/views/sign_up/view/widgets/number_of_children_field.dart';
import '../../../../../auth/presentation/views/sign_up/view/widgets/selectable_circle.dart';

class ProfileForm extends StatelessWidget {
  static const List<String> _bloodTypeOptions = <String>[
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final TextEditingController fnController;
  final TextEditingController lnController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController residenceController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController chronicDiseasesController;
  final TextEditingController permanentMedicationsController;
  final TextEditingController foodAllergiesController;
  final TextEditingController favoriteFoodsController;
  final TextEditingController dislikedFoodsController;
  final TextEditingController digestionIssuesController;
  final String? gender;
  final String? maritalStatus;
  final String? bloodType;
  final bool? hasChildren;
  final bool? isSmoke;
  final int numberOfChildren;
  final DateTime? birthDate;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<bool?> onSmokeChanged;
  final ValueChanged<bool?> onChildrenChanged;
  final ValueChanged<String?> onMaritalStatusChanged;
  final ValueChanged<String?> onBloodTypeChanged;
  final VoidCallback onBirthDateTap;
  final VoidCallback onIncrementChildren;
  final VoidCallback onDecrementChildren;

  const ProfileForm({
    super.key,
    required this.fnController,
    required this.lnController,
    required this.emailController,
    required this.phoneController,
    required this.residenceController,
    required this.heightController,
    required this.weightController,
    required this.chronicDiseasesController,
    required this.permanentMedicationsController,
    required this.foodAllergiesController,
    required this.favoriteFoodsController,
    required this.dislikedFoodsController,
    required this.digestionIssuesController,
    required this.gender,
    required this.maritalStatus,
    required this.bloodType,
    required this.hasChildren,
    required this.isSmoke,
    required this.numberOfChildren,
    required this.birthDate,
    required this.onGenderChanged,
    required this.onSmokeChanged,
    required this.onChildrenChanged,
    required this.onMaritalStatusChanged,
    required this.onBloodTypeChanged,
    required this.onBirthDateTap,
    required this.onIncrementChildren,
    required this.onDecrementChildren,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMale = gender == 'male';

    return Column(
      children: [
        _ProfileSectionCard(
          title: 'basic_information'.tr(context),
          icon: Icons.person_outline_rounded,
          child: Column(
            children: [
              CustomTextField(
                hintText: 'first_name'.tr(context),
                controller: fnController,
                suffixIcon: Icons.person_outline_rounded,
                validator: (val) =>
                    Validator.validate(val, ValidationState.normal, context),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'last_name'.tr(context),
                controller: lnController,
                suffixIcon: Icons.badge_outlined,
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
                validator: (val) => Validator.validate(
                  val,
                  ValidationState.phoneNumber,
                  context,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'address'.tr(context),
                controller: residenceController,
                suffixIcon: Icons.location_on_outlined,
                validator: (val) =>
                    Validator.validate(val, ValidationState.normal, context),
              ),
              const SizedBox(height: 16),
              CustomDropdownField(
                hintText: 'gender'.tr(context),
                value: gender,
                items: ['male', 'female'],
                prefixIcon: Icons.wc_rounded,
                onChanged: onGenderChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_select_gender'.tr(context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomDropdownField(
                hintText: 'marital_status'.tr(context),
                value: maritalStatus,
                items: ['single', 'married', 'divorced', 'widowed'],
                prefixIcon: Icons.people_outline_rounded,
                onChanged: onMaritalStatusChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_select_marital_status'.tr(context);
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _ProfileSectionCard(
          title: 'health_lifestyle'.tr(context),
          icon: Icons.favorite_outline_rounded,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'height'.tr(context),
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      suffixIcon: Icons.height,
                      validator: (val) => Validator.validate(
                        val,
                        ValidationState.price,
                        context,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      hintText: 'weight'.tr(context),
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      suffixIcon: Icons.monitor_weight,
                      validator: (val) => Validator.validate(
                        val,
                        ValidationState.price,
                        context,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomDropdownField(
                hintText: 'blood_type'.tr(context),
                value: bloodType,
                items: _bloodTypeOptions,
                prefixIcon: Icons.bloodtype_outlined,
                onChanged: onBloodTypeChanged,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: onBirthDateTap,
                borderRadius: BorderRadius.circular(30),
                child: _buildChoiceField(
                  icon: Icons.cake_outlined,
                  label: birthDate == null
                      ? 'select_your_birth'.tr(context)
                      : DateFormat('dd-MM-yyyy').format(birthDate!),
                  isPlaceholder: birthDate == null,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceField(
                      icon: Icons.smoking_rooms_outlined,
                      label: 'are_you_a_smoker'.tr(context),
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
              const SizedBox(height: 16),
              Opacity(
                opacity: isMale ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: isMale,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildChoiceField(
                          icon: Icons.child_care_outlined,
                          label: 'have_children'.tr(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SelectableCircle(
                        icon: Icons.check,
                        isSelected: hasChildren == true,
                        onTap: () => onChildrenChanged(true),
                      ),
                      const SizedBox(width: 10),
                      SelectableCircle(
                        icon: Icons.close,
                        isSelected: hasChildren == false,
                        selectedColor: Colors.red,
                        onTap: () => onChildrenChanged(false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: isMale ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: isMale,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildChoiceField(
                          icon: Icons.family_restroom_outlined,
                          label: 'number_of_children'.tr(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      NumberOfChildrenField(
                        enabled: hasChildren == true,
                        value: numberOfChildren,
                        onIncrement: onIncrementChildren,
                        onDecrement: onDecrementChildren,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _ProfileSectionCard(
          title: 'nutrition_history'.tr(context),
          icon: Icons.restaurant_menu_rounded,
          child: Column(
            children: [
              _buildListField(
                context,
                controller: chronicDiseasesController,
                title: 'chronic_diseases'.tr(context),
                suffixIcon: Icons.health_and_safety_outlined,
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: permanentMedicationsController,
                title: 'permanent_medications'.tr(context),
                suffixIcon: Icons.medication_outlined,
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: foodAllergiesController,
                title: 'food_allergies'.tr(context),
                suffixIcon: Icons.error_outline_rounded,
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: favoriteFoodsController,
                title: 'favorite_foods'.tr(context),
                suffixIcon: Icons.favorite_border_rounded,
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: dislikedFoodsController,
                title: 'disliked_foods'.tr(context),
                suffixIcon: Icons.thumb_down_alt_outlined,
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: digestionIssuesController,
                title: 'digestion_issues'.tr(context),
                suffixIcon: Icons.sick_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceField({
    required IconData icon,
    required String label,
    bool isPlaceholder = false,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFA),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textFieldColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isPlaceholder
                    ? AppColors.textFieldColor
                    : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListField(
    BuildContext context, {
    required TextEditingController controller,
    required String title,
    required IconData suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3E4A46),
            ),
          ),
        ),
        CustomTextField(
          hintText: 'list_input_hint'.tr(context),
          controller: controller,
          maxLines: 3,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryColors, AppColors.secColors],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColors.withValues(alpha: 0.16),
                      AppColors.secColors.withValues(alpha: 0.12),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.primaryColors),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
