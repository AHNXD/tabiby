import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/view_models/diagnosis_cubit.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/result_sections.dart';
import 'package:tabiby/features/user_app/doctors/presentation/view/all_doctors_screen.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/result';
  const ResultScreen({super.key});

  void _startOver(BuildContext context) {
    context.read<DiagnosisCubit>().resetDiagnosis();
    Navigator.of(context).pop();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _retry(BuildContext context) {
    context.read<DiagnosisCubit>().submitDiagnosis();
  }

  void _findDoctor(BuildContext context) {
    Navigator.pushNamed(context, AllDoctorsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'result_title'.tr(context)),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.resultState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return CustomErrorWidget(
                textColor: AppColors.blackColor,
                errorMessage: state.errorMessage.tr(context),
                onRetry: () => _retry(context),
              );
            case ViewState.success:
              final result = state.diagnosisResult;
              if (result == null) {
                return DiagnosisNoResultView(
                  onStartOver: () => _startOver(context),
                );
              }

              return SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: DiagnosisResultContent(
                    result: result,
                    onFindDoctor: () => _findDoctor(context),
                    onStartOver: () => _startOver(context),
                  ),
                ),
              );
            case ViewState.idle:
              return const LoadingView();
          }
        },
      ),
    );
  }
}
