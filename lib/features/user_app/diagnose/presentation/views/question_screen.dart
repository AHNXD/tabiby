import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/core/widgets/no_data.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/symptom_model.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/result_screen.dart';

import '../view_models/diagnosis_cubit.dart';

class QuestionScreen extends StatelessWidget {
  static const routeName = '/questions';
  const QuestionScreen({super.key});

  void _submit(BuildContext context, DiagnosisState state) {
    if (state.selectedSymptoms.isEmpty) {
      messages(context, 'no_symptom_selected'.tr(context), Colors.orange);
      return;
    }

    context.read<DiagnosisCubit>().submitDiagnosis();
    Navigator.of(context).pushNamed(ResultScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppbar(title: 'questions_title'.tr(context)),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.symptomsState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMessage.tr(context),
                onRetry: () => context
                    .read<DiagnosisCubit>()
                    .fetchSymptomsForSelectedPart(),
              );
            case ViewState.success:
              if (state.symptoms.isEmpty) {
                return NoDataWidget(
                  title: 'no_data_title'.tr(context),
                  subtitle: 'no_symptom'.tr(context),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primaryColors,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            state.selectedBodyPartLabel ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      itemCount: state.symptoms.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final Symptom symptom = state.symptoms[index];
                        return _SymptomCard(
                          symptom: symptom,
                          symptomIndex: index,
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: PrimaryButton(
                        text: 'get_diagnosis'.tr(context),
                        fontSize: 20,
                        onPressed: () => _submit(context, state),
                      ),
                    ),
                  ),
                ],
              );
            case ViewState.idle:
              return const LoadingView();
          }
        },
      ),
    );
  }
}

class _SymptomCard extends StatelessWidget {
  final Symptom symptom;
  final int symptomIndex;

  const _SymptomCard({required this.symptom, required this.symptomIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: symptom.isSelected
              ? AppColors.primaryColors.withValues(alpha: 0.45)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: symptom.isSelected,
                  activeColor: AppColors.primaryColors,
                  onChanged: (bool? value) {
                    context.read<DiagnosisCubit>().toggleSymptomSelection(
                      symptomIndex,
                      value ?? false,
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    symptom.labelAr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (symptom.isSelected && symptom.questions.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...List<Widget>.generate(symptom.questions.length, (int qIndex) {
                final SymptomQuestion question = symptom.questions[qIndex];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: qIndex == symptom.questions.length - 1 ? 0 : 12,
                  ),
                  child: _QuestionInput(
                    question: question,
                    onChanged: (dynamic answer) {
                      context.read<DiagnosisCubit>().answerQuestion(
                        symptomIndex,
                        qIndex,
                        answer,
                      );
                    },
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuestionInput extends StatelessWidget {
  final SymptomQuestion question;
  final ValueChanged<dynamic> onChanged;

  const _QuestionInput({required this.question, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final String type = question.type.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.labelAr,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (type == 'slider') _buildSlider(context),
        if (type == 'chips_choice') _buildChoiceChips(),
        if (type == 'dropdown') _buildDropdown(),
        if (type != 'slider' && type != 'chips_choice' && type != 'dropdown')
          _buildDropdown(),
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    final double min = question.min;
    final double max = question.max;
    final double currentValue = question.answer is num
        ? (question.answer as num).toDouble().clamp(min, max)
        : min;
    final int diff = (max - min).round();

    return Row(
      children: [
        Expanded(
          child: Slider(
            value: currentValue,
            min: min,
            max: max,
            divisions: diff > 0 ? diff : null,
            activeColor: AppColors.primaryColors,
            label: currentValue.round().toString(),
            onChanged: (double value) => onChanged(value.round()),
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            currentValue.round().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChips() {
    if (question.options.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: question.options.map((String option) {
        final bool isSelected = question.answer?.toString() == option;

        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          selectedColor: AppColors.primaryColors.withValues(alpha: 0.2),
          backgroundColor: Colors.grey.shade100,
          side: BorderSide(
            color: isSelected ? AppColors.primaryColors : Colors.grey.shade300,
          ),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primaryColors : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) => onChanged(option),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown() {
    if (question.options.isEmpty) {
      return const SizedBox.shrink();
    }

    final String? currentValue = question.options.contains(question.answer)
        ? question.answer as String
        : null;

    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      items: question.options
          .map(
            (String option) =>
                DropdownMenuItem<String>(value: option, child: Text(option)),
          )
          .toList(),
      onChanged: (String? value) => onChanged(value),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
