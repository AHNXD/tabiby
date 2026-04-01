import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custome_text_field.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/presentation/view_model/medical_files_cubit.dart';

class AddMedicalFileScreen extends StatefulWidget {
  static const String routeName = '/add_medical_file';

  const AddMedicalFileScreen({super.key});

  @override
  State<AddMedicalFileScreen> createState() => _AddMedicalFileScreenState();
}

class _AddMedicalFileScreenState extends State<AddMedicalFileScreen> {
  static const int _maxFileSizeInBytes = 5 * 1024 * 1024;
  static const Set<String> _allowedExtensions = <String>{
    'jpg',
    'jpeg',
    'png',
    'pdf',
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  MedicalFileType? _selectedType;
  DateTime? _selectedDate;
  File? _selectedFile;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    });
  }

  Future<void> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: _allowedExtensions.toList(),
    );

    final String? selectedPath = result?.files.single.path;
    if (selectedPath == null) {
      return;
    }

    final File selectedFile = File(selectedPath);
    final String extension = _fileExtension(selectedFile);
    final int fileSize = await selectedFile.length();

    if (!_allowedExtensions.contains(extension)) {
      if (!mounted) {
        return;
      }
      messages(
        context,
        'unsupported_medical_file_type'.tr(context),
        Colors.orange,
      );
      return;
    }

    if (fileSize > _maxFileSizeInBytes) {
      if (!mounted) {
        return;
      }
      messages(context, 'medical_file_too_large'.tr(context), Colors.orange);
      return;
    }

    setState(() {
      _selectedFile = selectedFile;
    });
  }

  void _saveMedicalFile() {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      messages(context, 'fix_form_error'.tr(context), Colors.red);
      return;
    }

    if (_selectedType == null) {
      messages(context, 'please_select_file_type'.tr(context), Colors.orange);
      return;
    }

    if (_selectedDate == null) {
      messages(context, 'please_select_file_date'.tr(context), Colors.orange);
      return;
    }

    if (_selectedFile == null) {
      messages(
        context,
        'please_upload_medical_file'.tr(context),
        Colors.orange,
      );
      return;
    }

    context.read<MedicalFilesCubit>().addMedicalFile(
      CreateMedicalFileRequest(
        title: _titleController.text,
        type: _selectedType!,
        fileDate: _selectedDate!,
        file: _selectedFile!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(title: 'add_medical_file'.tr(context)),
      ),
      body: BlocConsumer<MedicalFilesCubit, MedicalFilesState>(
        listener: (BuildContext context, MedicalFilesState state) {
          if (state.submissionStatus == MedicalFileSubmissionStatus.failure) {
            messages(context, state.errorMessage, Colors.red);
            context.read<MedicalFilesCubit>().clearSubmissionStatus();
          }

          if (state.submissionStatus == MedicalFileSubmissionStatus.success) {
            messages(
              context,
              'medical_file_added_successfully'.tr(context),
              Colors.green,
            );
            context.read<MedicalFilesCubit>().clearSubmissionStatus();
            Navigator.of(context).pop(true);
          }
        },
        builder: (BuildContext context, MedicalFilesState state) {
          final bool isSubmitting =
              state.submissionStatus == MedicalFileSubmissionStatus.submitting;

          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _PageIntroCard(
                          title: 'add_medical_file'.tr(context),
                          subtitle: 'medical_file_form_hint'.tr(context),
                        ),
                        const SizedBox(height: 18),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _FieldLabel(
                                icon: Icons.category_rounded,
                                label: 'select_file_type'.tr(context),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<MedicalFileType>(
                                initialValue: _selectedType,
                                decoration: _inputDecoration(
                                  context,
                                  'select_file_type'.tr(context),
                                ),
                                items: MedicalFileType.values
                                    .map(
                                      (MedicalFileType type) =>
                                          DropdownMenuItem<MedicalFileType>(
                                            value: type,
                                            child: Text(
                                              type.labelKey.tr(context),
                                            ),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (MedicalFileType? value) {
                                  setState(() {
                                    _selectedType = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 18),
                              _FieldLabel(
                                icon: Icons.drive_file_rename_outline_rounded,
                                label: 'medical_file_title'.tr(context),
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                hintText: 'medical_file_title'.tr(context),
                                controller: _titleController,
                                validator: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'medical_file_title_required'.tr(
                                      context,
                                    );
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              _FieldLabel(
                                icon: Icons.calendar_month_rounded,
                                label: 'medical_file_date'.tr(context),
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                hintText: 'medical_file_date'.tr(context),
                                controller: _dateController,
                                readOnly: true,
                                suffixIcon: Icons.calendar_today_rounded,
                                onTap: _pickDate,
                                validator: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'please_select_file_date'.tr(
                                      context,
                                    );
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _FilePickerCard(
                          selectedFile: _selectedFile,
                          onTap: _pickFile,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _SubmitSection(
                isSubmitting: isSubmitting,
                onPressed: _saveMedicalFile,
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  String _fileExtension(File file) {
    final String lowerPath = file.path.toLowerCase();
    if (!lowerPath.contains('.')) {
      return '';
    }
    return lowerPath.split('.').last;
  }
}

class _FilePickerCard extends StatelessWidget {
  const _FilePickerCard({required this.selectedFile, required this.onTap});

  final File? selectedFile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFile = selectedFile != null;
    final bool isImage = _isImageFile(selectedFile);
    final String? fileName = selectedFile?.path.split('/').last;

    return _SectionCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _FieldLabel(
                  icon: Icons.cloud_upload_rounded,
                  label: 'upload_medical_file'.tr(context),
                ),
                const SizedBox(height: 14),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: hasFile ? 230 : 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: hasFile
                        ? null
                        : LinearGradient(
                            colors: <Color>[
                              AppColors.primaryColors.withValues(alpha: 0.08),
                              AppColors.secColors.withValues(alpha: 0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    border: Border.all(
                      color: hasFile
                          ? Colors.transparent
                          : AppColors.primaryColors.withValues(alpha: 0.2),
                    ),
                  ),
                  child: hasFile
                      ? Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            if (isImage)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.file(
                                  selectedFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(24),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 84,
                                      height: 84,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: const Icon(
                                        Icons.picture_as_pdf_rounded,
                                        color: Color(0xFFD65555),
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      fileName ??
                                          'selected_medical_file'.tr(context),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'pdf_file_selected'.tr(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Positioned(
                              left: 14,
                              right: 14,
                              bottom: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.48),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'change_selected_file'.tr(context),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: AppColors.primaryColors.withValues(
                                      alpha: 0.08,
                                    ),
                                    blurRadius: 22,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.cloud_upload_outlined,
                                color: AppColors.primaryColors,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'tap_to_upload_file'.tr(context),
                              style: const TextStyle(
                                color: AppColors.primaryColors,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.appBackgroundColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        hasFile
                            ? (isImage
                                  ? Icons.photo_library_rounded
                                  : Icons.attach_file_rounded)
                            : Icons.upload_file_rounded,
                        size: 20,
                        color: AppColors.primaryColors,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          hasFile
                              ? 'change_selected_file'.tr(context)
                              : 'choose_file'.tr(context),
                          style: const TextStyle(
                            color: AppColors.primaryColors,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.primaryColors,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isImageFile(File? file) {
    if (file == null) {
      return false;
    }

    final String lowerPath = file.path.toLowerCase();
    return lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png');
  }
}

class _PageIntroCard extends StatelessWidget {
  const _PageIntroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -24,
            right: -10,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -16,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.folder_copy_rounded,
                  color: AppColors.primaryColors,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1F2C28),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryColors.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryColors, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _SubmitSection extends StatelessWidget {
  const _SubmitSection({required this.isSubmitting, required this.onPressed});

  final bool isSubmitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting ? () {} : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColors,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size.fromHeight(55),
              elevation: 5,
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'save_medical_file'.tr(context),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
