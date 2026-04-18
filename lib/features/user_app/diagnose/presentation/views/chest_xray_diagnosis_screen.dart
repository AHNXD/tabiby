import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';

import '../view_models/diagnosis_cubit.dart';
import 'chest_xray_result_screen.dart';
import 'xray_medical_file_picker_screen.dart';
import 'widgets/xray_sections.dart';

class ChestXrayDiagnosisScreen extends StatelessWidget {
  const ChestXrayDiagnosisScreen({super.key});

  static const routeName = '/diagnose-xray';

  void _submit(BuildContext context, DiagnosisState state) {
    if (!state.hasSelectedXrayImage) {
      messages(
        context,
        'xray_select_image_first'.tr(context),
        AppColors.orangeColor,
      );
      return;
    }

    context.read<DiagnosisCubit>().analyzeSelectedXray();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ChestXrayResultScreen()));
  }

  Future<void> _pickFromMedicalFiles(BuildContext context) async {
    final DiagnosisCubit cubit = context.read<DiagnosisCubit>();
    final List<MedicalFile> files = await cubit.loadAvailableXrayMedicalFiles();

    if (!context.mounted) {
      return;
    }

    if (files.isEmpty) {
      messages(
        context,
        'no_xray_records_available'.tr(context),
        AppColors.orangeColor,
      );
      return;
    }

    final MedicalFile? selectedFile = await Navigator.of(context)
        .push<MedicalFile>(
          MaterialPageRoute(
            builder: (_) => XrayMedicalFilePickerScreen(files: files),
          ),
        );

    if (selectedFile == null || !context.mounted) {
      return;
    }

    await cubit.selectMedicalFileForXray(selectedFile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiagnosisCubit, DiagnosisState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage.isNotEmpty,
      listener: (context, state) {
        messages(context, state.errorMessage.tr(context), AppColors.redColor);
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: CustomAppbar(title: 'xray_diagnosis_title'.tr(context)),
        body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
          builder: (context, state) {
            final bool isLoadingMedicalFiles =
                state.xrayMedicalFilesState == ViewState.loading &&
                state.xrayState != ViewState.loading;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                XrayHeroCard(
                  hasSelectedImage: state.hasSelectedXrayImage,
                  hasResult: state.xrayDiagnosisResult != null,
                ),
                const SizedBox(height: 16),
                if (isLoadingMedicalFiles)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.grey200Color),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.2),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'xray_loading_saved_files'.tr(context),
                            style: TextStyle(
                              color: AppColors.grey700Color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                XrayUploadCard(
                  imagePath: state.selectedXrayImagePath,
                  selectedTitle: state.selectedXrayTitle,
                  onPick: () => showXrayImageSourceSheet(
                    context,
                    context.read<DiagnosisCubit>().pickXrayImage,
                  ),
                  onClear: state.hasSelectedXrayImage
                      ? context.read<DiagnosisCubit>().clearSelectedXrayImage
                      : null,
                ),
                const SizedBox(height: 16),
                SecondryButton(
                  text: 'xray_pick_from_medical_files'.tr(context),
                  fontSize: 18,
                  onPressed: isLoadingMedicalFiles
                      ? () {}
                      : () => _pickFromMedicalFiles(context),
                ),
                const SizedBox(height: 24),
                XrayAnalyzeButton(
                  isLoading: state.xrayState == ViewState.loading,
                  isEnabled:
                      state.hasSelectedXrayImage &&
                      state.xrayState != ViewState.loading &&
                      !isLoadingMedicalFiles,
                  onPressed: () => _submit(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
