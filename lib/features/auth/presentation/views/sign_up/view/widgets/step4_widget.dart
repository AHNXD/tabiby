import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custome_text_field.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
import 'package:tabiby/features/shared/privacy_policy/presentation/view/privacy_policy_screen.dart';
import 'package:tabiby/features/shared/terms_and_condition/presentation/view/terms_and_conditions_screen.dart';

class Step4Widget extends StatelessWidget {
  const Step4Widget({
    super.key,
    required this.chronicDiseasesCtrl,
    required this.permanentMedicationsCtrl,
    required this.foodAllergiesCtrl,
    required this.preferredFoodsCtrl,
    required this.dislikedFoodsCtrl,
    required this.digestionIssuesCtrl,
    required this.agreeToTerms,
    required this.isLoading,
    required this.onAgreeToggle,
    required this.onSignUp,
  });

  final TextEditingController chronicDiseasesCtrl;
  final TextEditingController permanentMedicationsCtrl;
  final TextEditingController foodAllergiesCtrl;
  final TextEditingController preferredFoodsCtrl;
  final TextEditingController dislikedFoodsCtrl;
  final TextEditingController digestionIssuesCtrl;
  final bool agreeToTerms;
  final bool isLoading;
  final VoidCallback onAgreeToggle;
  final VoidCallback onSignUp;

  Widget _buildListField(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: title,
          controller: controller,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'list_input_hint'.tr(context),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textFieldColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            children: [
              const SizedBox(height: 30),
              _buildListField(
                context,
                title: 'chronic_diseases'.tr(context),
                controller: chronicDiseasesCtrl,
              ),
              const SizedBox(height: 20),
              _buildListField(
                context,
                title: 'permanent_medications'.tr(context),
                controller: permanentMedicationsCtrl,
              ),
              const SizedBox(height: 20),
              _buildListField(
                context,
                title: 'food_allergies'.tr(context),
                controller: foodAllergiesCtrl,
              ),
              const SizedBox(height: 20),
              _buildListField(
                context,
                title: 'preferred_foods'.tr(context),
                controller: preferredFoodsCtrl,
              ),
              const SizedBox(height: 20),
              _buildListField(
                context,
                title: 'disliked_foods'.tr(context),
                controller: dislikedFoodsCtrl,
              ),
              const SizedBox(height: 20),
              _buildListField(
                context,
                title: 'digestion_issues'.tr(context),
                controller: digestionIssuesCtrl,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onAgreeToggle,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: agreeToTerms
                            ? AppColors.primaryColors
                            : Colors.transparent,
                        border: Border.all(
                          color: agreeToTerms
                              ? AppColors.primaryColors
                              : AppColors.textColor,
                          width: 1.5,
                        ),
                      ),
                      child: agreeToTerms
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
                            style: const TextStyle(
                              fontFamily: 'cocon-next-arabic',
                            ),
                          ),
                          TextSpan(
                            text: " ${'terms_conditions'.tr(context)}",
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              decoration: TextDecoration.underline,
                              fontFamily: 'cocon-next-arabic',
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(
                                context,
                                TermsAndConditionsScreen.routeName,
                              ),
                          ),
                          TextSpan(
                            text: ' ${"and".tr(context)} ',
                            style: const TextStyle(
                              fontFamily: 'cocon-next-arabic',
                            ),
                          ),
                          TextSpan(
                            text: 'privacy_policy'.tr(context),
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              decoration: TextDecoration.underline,
                              fontFamily: 'cocon-next-arabic',
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
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColors,
                      ),
                    )
                  : SecondryButton(
                      text: 'sign_up'.tr(context),
                      onPressed: onSignUp,
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
