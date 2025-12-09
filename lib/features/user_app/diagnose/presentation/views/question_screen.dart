import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/error_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/result_screen.dart';

import '../view_models/diagnosis_cubit.dart';

class QuestionScreen extends StatelessWidget {
  static const routeName = '/questions';
  const QuestionScreen({super.key});

  void _submit(BuildContext context) {
    // This logic is correct for your BLoC setup.
    // The Cubit will be told to submit, and the ResultScreen
    // will listen for the new state (e.g., resultState)
    context.read<DiagnosisCubit>().submitDiagnosis("ar");
    Navigator.of(context).pushNamed(ResultScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(title: 'questions_title'.tr(context)),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.questionState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return ErrorView(
                message: state.errorMessage.tr(context),
                onRetry: () {
                  // Go back to the previous screen (categories)
                  Navigator.of(context).pop();
                },
              );
            case ViewState.success:
              if (state.questions.isEmpty) {
                return Center(
                  child: Text(
                    'no_questions'.tr(context),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              // --- CRITICAL UX IMPROVEMENT ---
              // Check if all questions have been answered.
              // We assume an answer is present if it's not null.
              final bool allAnswered = state.questions.every(
                (q) =>
                    state.answers.containsKey(q.id) &&
                    state.answers[q.id] != null,
              );

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount:
                          state.questions.length, // Get questions from state
                      itemBuilder: (ctx, index) {
                        final question = state.questions[index];
                        // Get the current answer from the state's map
                        // We check for 1 (Yes) or 0 (No). Null means unanswered.
                        final int? currentAnswer = state.answers[question.id];
                        final bool isYesSelected = currentAnswer == 1;
                        final bool isNoSelected = currentAnswer == 0;

                        // --- This is the new Question Card UI ---
                        return Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- Progress Counter ---
                                Text(
                                  '${"question".tr(context)} ${index + 1} ${"of".tr(context)} ${state.questions.length}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                // --- The Question Text ---
                                Text(
                                  question.question,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16.0),
                                // --- Yes/No Button Row ---
                                Row(
                                  children: [
                                    _buildAnswerButton(
                                      context: context,
                                      text: 'yes'.tr(context),
                                      isSelected: isYesSelected,
                                      onPressed: () {
                                        context
                                            .read<DiagnosisCubit>()
                                            .answerQuestion(question.id, true);
                                      },
                                    ),
                                    const SizedBox(width: 12.0),
                                    _buildAnswerButton(
                                      context: context,
                                      text: 'no'.tr(context),
                                      isSelected: isNoSelected,
                                      onPressed: () {
                                        context
                                            .read<DiagnosisCubit>()
                                            .answerQuestion(question.id, false);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 16,
                      top: 6,
                    ),
                    child: PrimaryButton(
                      text: allAnswered
                          ? 'get_diagnosis'.tr(context)
                          : 'select_answer'.tr(context),
                      onPressed: () {
                        if (allAnswered) _submit(context);
                      },
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

  Widget _buildAnswerButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: isSelected
          ? PrimaryButton(onPressed: onPressed, text: text)
          : SecondryButton(onPressed: onPressed, text: text),
    );
  }
}
