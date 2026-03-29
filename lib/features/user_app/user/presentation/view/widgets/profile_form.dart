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
  final TextEditingController chronicDiseasesController;
  final TextEditingController permanentMedicationsController;
  final TextEditingController foodAllergiesController;
  final TextEditingController preferredFoodsController;
  final TextEditingController dislikedFoodsController;
  final TextEditingController digestionIssuesController;
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
    required this.chronicDiseasesController,
    required this.permanentMedicationsController,
    required this.foodAllergiesController,
    required this.preferredFoodsController,
    required this.dislikedFoodsController,
    required this.digestionIssuesController,
    required this.maritalStatus,
    required this.isSmoke,
    required this.onSmokeChanged,
    required this.onMaritalStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                suffixIcon: Icons.home,
                validator: (val) =>
                    Validator.validate(val, ValidationState.normal, context),
              ),
              const SizedBox(height: 16),
              CustomDropdownField(
                hintText: 'marital_status'.tr(context),
                value: maritalStatus,
                items: ['single', 'married', 'divorced', 'widowed'],
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
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: permanentMedicationsController,
                title: 'permanent_medications'.tr(context),
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: foodAllergiesController,
                title: 'food_allergies'.tr(context),
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: preferredFoodsController,
                title: 'preferred_foods'.tr(context),
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: dislikedFoodsController,
                title: 'disliked_foods'.tr(context),
              ),
              const SizedBox(height: 16),
              _buildListField(
                context,
                controller: digestionIssuesController,
                title: 'digestion_issues'.tr(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListField(
    BuildContext context, {
    required TextEditingController controller,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        CustomTextField(
          hintText: 'list_input_hint'.tr(context),
          controller: controller,
          maxLines: 3,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
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
