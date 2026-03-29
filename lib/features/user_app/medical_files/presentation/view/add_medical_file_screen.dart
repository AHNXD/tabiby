import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custome_text_field.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/user_app/medical_files/data/models/medical_file_model.dart';
import 'package:tabiby/features/user_app/medical_files/presentation/view_model/medical_files_cubit.dart';

class AddMedicalFileScreen extends StatefulWidget {
  static const String routeName = '/add_medical_file';

  const AddMedicalFileScreen({super.key});

  @override
  State<AddMedicalFileScreen> createState() => _AddMedicalFileScreenState();
}

class _AddMedicalFileScreenState extends State<AddMedicalFileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  MedicalFileType? _selectedType;
  DateTime? _selectedDate;
  File? _selectedImage;

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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = File(image.path);
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

    if (_selectedImage == null) {
      messages(
        context,
        'please_upload_medical_image'.tr(context),
        Colors.orange,
      );
      return;
    }

    context.read<MedicalFilesCubit>().addMedicalFile(
      CreateMedicalFileRequest(
        title: _titleController.text,
        type: _selectedType!,
        fileDate: _selectedDate!,
        imageFile: _selectedImage!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'medical_file_form_hint'.tr(context),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                child: Text(type.labelKey.tr(context)),
                              ),
                        )
                        .toList(),
                    onChanged: (MedicalFileType? value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'medical_file_title'.tr(context),
                    controller: _titleController,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'medical_file_title_required'.tr(context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'medical_file_date'.tr(context),
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'please_select_file_date'.tr(context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _ImagePickerCard(
                    selectedImage: _selectedImage,
                    onTap: _pickImage,
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child:
                        state.submissionStatus ==
                            MedicalFileSubmissionStatus.submitting
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'save_medical_file'.tr(context),
                            onPressed: _saveMedicalFile,
                            fontSize: 22,
                          ),
                  ),
                ],
              ),
            ),
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
    );
  }
}

class _ImagePickerCard extends StatelessWidget {
  const _ImagePickerCard({required this.selectedImage, required this.onTap});

  final File? selectedImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = selectedImage != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'upload_medical_image'.tr(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              if (hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    selectedImage!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: Theme.of(context).primaryColor,
                        size: 36,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'tap_to_upload_image'.tr(context),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                hasImage
                    ? 'change_selected_image'.tr(context)
                    : 'choose_image'.tr(context),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
