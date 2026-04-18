import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';

import '../view_models/diagnosis_cubit.dart';
import 'models/loading_view.dart';
import 'widgets/xray_sections.dart';

class ChestXrayResultScreen extends StatelessWidget {
  const ChestXrayResultScreen({super.key});

  void _retry(BuildContext context) {
    context.read<DiagnosisCubit>().analyzeSelectedXray();
  }

  void _startOver(BuildContext context) {
    context.read<DiagnosisCubit>().resetXrayDiagnosis();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'xray_result_title'.tr(context)),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.xrayState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return CustomErrorWidget(
                textColor: AppColors.blackColor,
                errorMessage: state.errorMessage.tr(context),
                onRetry: () => _retry(context),
              );
            case ViewState.success:
              final result = state.xrayDiagnosisResult;
              if (result == null) {
                return XrayNoResultView(onStartOver: () => _startOver(context));
              }

              return SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: XrayDiagnosisResultContent(
                    result: result,
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
