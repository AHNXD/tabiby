import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/symptom_model.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/view_models/diagnosis_cubit.dart';

class QuestionIntroCard extends StatelessWidget {
  const QuestionIntroCard({
    super.key,
    required this.bodyPartLabel,
    required this.selectedCount,
    required this.totalCount,
  });

  final String bodyPartLabel;
  final int selectedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.quiz_outlined,
                        color: AppColors.primaryColors,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    _QuestionInfoBadge(
                      icon: Icons.location_on_outlined,
                      text: bodyPartLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'questions_title'.tr(context),
                  style: const TextStyle(
                    color: Color(0xFF1F2C28),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _QuestionStatCard(
                          icon: Icons.checklist_rounded,
                          value: selectedCount.toString(),
                          accentColor: AppColors.primaryColors,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuestionStatCard(
                          icon: Icons.monitor_heart_outlined,
                          value: totalCount.toString(),
                          accentColor: const Color(0xFFE7A423),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  const SymptomCard({
    super.key,
    required this.symptom,
    required this.symptomIndex,
  });

  final Symptom symptom;
  final int symptomIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: symptom.isSelected
              ? AppColors.primaryColors.withValues(alpha: 0.45)
              : Colors.grey.shade200,
          width: symptom.isSelected ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: symptom.isSelected
                ? AppColors.primaryColors.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => context
                  .read<DiagnosisCubit>()
                  .toggleSymptomSelection(symptomIndex, !symptom.isSelected),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: symptom.isSelected
                          ? AppColors.primaryColors
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: symptom.isSelected
                            ? AppColors.primaryColors
                            : Colors.grey.shade400,
                        width: 1.6,
                      ),
                    ),
                    child: symptom.isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      symptom.labelAr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2C28),
                      ),
                    ),
                  ),
                  if (symptom.questions.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.tune_rounded,
                            size: 14,
                            color: AppColors.primaryColors,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            symptom.questions.length.toString(),
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (symptom.isSelected && symptom.questions.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAF8),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primaryColors.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: List<Widget>.generate(symptom.questions.length, (
                    int qIndex,
                  ) {
                    final SymptomQuestion question = symptom.questions[qIndex];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: qIndex == symptom.questions.length - 1 ? 0 : 14,
                      ),
                      child: QuestionInput(
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
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class QuestionInput extends StatelessWidget {
  const QuestionInput({
    super.key,
    required this.question,
    required this.onChanged,
  });

  final SymptomQuestion question;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    final String type = question.type.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.labelAr,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2C28),
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primaryColors,
                inactiveTrackColor: AppColors.primaryColors.withValues(
                  alpha: 0.15,
                ),
                thumbColor: AppColors.primaryColors,
                overlayColor: AppColors.primaryColors.withValues(alpha: 0.12),
              ),
              child: Slider(
                value: currentValue,
                min: min,
                max: max,
                divisions: diff > 0 ? diff : null,
                label: currentValue.round().toString(),
                onChanged: (double value) => onChanged(value.round()),
              ),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              currentValue.round().toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primaryColors,
              ),
            ),
          ),
        ],
      ),
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
          selectedColor: AppColors.primaryColors.withValues(alpha: 0.14),
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? AppColors.primaryColors : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primaryColors : Colors.grey.shade700,
            fontWeight: FontWeight.w700,
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
      isExpanded: true,
      borderRadius: BorderRadius.circular(16),
      menuMaxHeight: 280,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey.shade600,
      ),
      selectedItemBuilder: (BuildContext context) {
        return question.options
            .map(
              (String option) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  option,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList();
      },
      items: question.options
          .map(
            (String option) => DropdownMenuItem<String>(
              value: option,
              child: Text(option, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (String? value) => onChanged(value),
      style: const TextStyle(
        color: Color(0xFF1F2C28),
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryColors),
        ),
      ),
    );
  }
}

class QuestionSubmitBar extends StatelessWidget {
  const QuestionSubmitBar({
    super.key,
    required this.selectedCount,
    required this.child,
  });

  final int selectedCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    color: AppColors.primaryColors,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedCount.toString(),
                    style: const TextStyle(
                      color: Color(0xFF1F2C28),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _QuestionInfoBadge extends StatelessWidget {
  const _QuestionInfoBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.primaryColors.withValues(alpha: 0.16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryColors, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primaryColors,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionStatCard extends StatelessWidget {
  const _QuestionStatCard({
    required this.icon,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2C28),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
