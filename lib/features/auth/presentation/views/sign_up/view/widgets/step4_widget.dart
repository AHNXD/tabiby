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
    required this.favoriteFoodsCtrl,
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
  final TextEditingController favoriteFoodsCtrl;
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
    required IconData suffixIcon,
  }) {
    return CustomTextField(
      hintText: title,
      controller: controller,
      textInputAction: TextInputAction.next,
      suffixIcon: suffixIcon,
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
                suffixIcon: Icons.health_and_safety_outlined,
              ),
              const SizedBox(height: 14),
              _buildListField(
                context,
                title: 'permanent_medications'.tr(context),
                controller: permanentMedicationsCtrl,
                suffixIcon: Icons.medication_outlined,
              ),
              const SizedBox(height: 14),
              _buildListField(
                context,
                title: 'food_allergies'.tr(context),
                controller: foodAllergiesCtrl,
                suffixIcon: Icons.error_outline_rounded,
              ),
              const SizedBox(height: 14),
              _buildListField(
                context,
                title: 'favorite_foods'.tr(context),
                controller: favoriteFoodsCtrl,
                suffixIcon: Icons.favorite_border_rounded,
              ),
              const SizedBox(height: 14),
              _buildListField(
                context,
                title: 'disliked_foods'.tr(context),
                controller: dislikedFoodsCtrl,
                suffixIcon: Icons.thumb_down_alt_outlined,
              ),
              const SizedBox(height: 14),
              _buildListField(
                context,
                title: 'digestion_issues'.tr(context),
                controller: digestionIssuesCtrl,
                suffixIcon: Icons.sick_outlined,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColors.withValues(alpha: 0.10),
                      AppColors.secColors.withValues(alpha: 0.08),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryColors.withValues(alpha: 0.16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColors.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primaryColors,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'list_input_hint'.tr(context),
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
