import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/core/widgets/no_data.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/result_screen.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/body_part_catalog.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/question_sections.dart';

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
                            localizedBodyPartLabel(
                              context,
                              partKey: state.selectedBodyPartKey,
                              fallbackLabel: state.selectedBodyPartLabel,
                            ),
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
                        return SymptomCard(
                          symptom: state.symptoms[index],
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
