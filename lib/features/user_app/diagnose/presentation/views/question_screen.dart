import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/result_screen.dart';

import '../../../../../core/widgets/no_data.dart';
import '../view_models/diagnosis_cubit.dart';

class QuestionScreen extends StatelessWidget {
  static const routeName = '/questions';
  const QuestionScreen({super.key});

  void _submit(BuildContext context) {
    context.read<DiagnosisCubit>().submitDiagnosis("ar");
    Navigator.of(context).pushNamed(ResultScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Light grey background
      appBar: CustomAppbar(title: 'questions_title'.tr(context)),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.questionState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMessage.tr(context),
                onRetry: () {
                  Navigator.of(context).pop();
                },
              );
            case ViewState.success:
              if (state.questions.isEmpty) {
                return NoDataWidget(
                  title: "no_data_title".tr(context),
                  subtitle: "no_data_subtitle".tr(context),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      itemCount: state.questions.length,
                      separatorBuilder: (ctx, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (ctx, index) {
                        final question = state.questions[index];
                        final int? currentAnswer = state.answers[question.id];
                        // 1 = Yes, 0 = No
                        final bool isYesSelected = currentAnswer == 1;
                        final bool isNoSelected = currentAnswer == 0;

                        return _buildQuestionCard(
                          context,
                          index: index,
                          questionText: question.question,
                          isYesSelected: isYesSelected,
                          isNoSelected: isNoSelected,
                          onAnswer: (bool isYes) {
                            context.read<DiagnosisCubit>().answerQuestion(
                              question.id,
                              isYes,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: PrimaryButton(
                        text: 'get_diagnosis'.tr(context),

                        onPressed: () {
                          _submit(context);
                        },
                      ),
                    ),
                  ),
                ],
              );
            default:
              return const LoadingView();
          }
        },
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context, {
    required int index,
    required String questionText,
    required bool isYesSelected,
    required bool isNoSelected,
    required Function(bool) onAnswer,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColors,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  questionText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Answer Row
          Row(
            children: [
              Expanded(
                child: _buildOptionButton(
                  context,
                  label: 'yes'.tr(context),
                  isSelected: isYesSelected,
                  icon: Icons.check_circle_outline_rounded,
                  color: Colors.green, // Positive Color
                  onTap: () => onAnswer(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOptionButton(
                  context,
                  label: 'no'.tr(context),
                  isSelected: isNoSelected,
                  icon: Icons.cancel_outlined,
                  color: Colors.red, // Negative Color
                  onTap: () => onAnswer(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? icon : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected ? color : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
