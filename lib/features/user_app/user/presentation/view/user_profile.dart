import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/auth/data/models/user_model.dart';
import 'package:tabiby/features/user_app/medical_files/presentation/view/show_medical_files_screen.dart';
import 'package:tabiby/features/user_app/user/presentation/view-model/user_cubit/user_cubit.dart';

import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../shared/settings/view/settings_screen.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_form.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = "/user_profile";
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fnController;
  late TextEditingController _lnController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _chronicDiseasesController;
  late TextEditingController _permanentMedicationsController;
  late TextEditingController _foodAllergiesController;
  late TextEditingController _favoriteFoodsController;
  late TextEditingController _dislikedFoodsController;
  late TextEditingController _digestionIssuesController;

  String? _gender;
  String? _maritalStatus;
  String? _bloodType;
  bool? _hasChildren;
  bool? _isSmoke;
  int _numberOfChildren = 0;
  DateTime? _birthDate;

  bool _isInitialDataLoaded = false;
  bool _showInformationSection = false;
  File? _pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fnController = TextEditingController();
    _lnController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _chronicDiseasesController = TextEditingController();
    _permanentMedicationsController = TextEditingController();
    _foodAllergiesController = TextEditingController();
    _favoriteFoodsController = TextEditingController();
    _dislikedFoodsController = TextEditingController();
    _digestionIssuesController = TextEditingController();
    _gender = null;
    _maritalStatus = null;
    _bloodType = null;
    _hasChildren = null;
    _isSmoke = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final UserState currentState = context.read<UserCubit>().state;
      if (currentState is UserSuccess) {
        _fillFormWithUser(currentState.user);
      } else {
        context.read<UserCubit>().getProfile();
      }
    });
  }

  @override
  void dispose() {
    _fnController.dispose();
    _lnController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _chronicDiseasesController.dispose();
    _permanentMedicationsController.dispose();
    _foodAllergiesController.dispose();
    _favoriteFoodsController.dispose();
    _dislikedFoodsController.dispose();
    _digestionIssuesController.dispose();
    super.dispose();
  }

  void _onSaveChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> registerData = {
        'first_name': _fnController.text,
        'last_name': _lnController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'gender': _gender?.toLowerCase(),
        'weight': _weightController.text,
        'height': _heightController.text,
        'marital_status': _maritalStatus?.toLowerCase(),
        'has_children': _hasChildren == true ? '1' : '0',
        'number_of_children': _numberOfChildren.toString(),
        'birth_date': _birthDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(_birthDate!),
        'is_smoke': _isSmoke == true ? '1' : '0',
        'chronic_diseases': _chronicDiseasesController.text.trim(),
        'permanent_medications': _permanentMedicationsController.text.trim(),
        'food_allergies': _foodAllergiesController.text.trim(),
        'favorite_foods': _favoriteFoodsController.text.trim(),
        'disliked_foods': _dislikedFoodsController.text.trim(),
        'digestion_issues': _digestionIssuesController.text.trim(),
        '_method': 'PUT',
      };

      if (_bloodType != null && _bloodType!.isNotEmpty) {
        registerData['blood_type'] = _bloodType;
      }

      if (_pickedImage != null) {
        registerData['profile_image'] = _pickedImage;
      }

      context.read<UserCubit>().updateProfile(registerData);
    } else {
      messages(context, 'fix_form_error'.tr(context), AppColors.redColor);
    }
  }

  Future<void> _pickBirthDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
    );

    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _fillFormWithUser(UserModel user) {
    if (_isInitialDataLoaded) {
      return;
    }

    _fnController.text = user.mainData?.firstName ?? '';
    _lnController.text = user.mainData?.lastName ?? '';
    _emailController.text = user.mainData?.email ?? '';
    _phoneController.text = user.mainData?.phone ?? '';
    _addressController.text = user.moreData?.address ?? '';
    _heightController.text = user.moreData?.height?.toString() ?? '';
    _weightController.text = user.moreData?.weight?.toString() ?? '';
    _chronicDiseasesController.text = user.moreData?.chronicDiseases ?? '';
    _permanentMedicationsController.text =
        user.moreData?.permanentMedications ?? '';
    _foodAllergiesController.text = user.moreData?.foodAllergies ?? '';
    _favoriteFoodsController.text = user.moreData?.favoriteFoods ?? '';
    _dislikedFoodsController.text = user.moreData?.dislikedFoods ?? '';
    _digestionIssuesController.text = user.moreData?.digestionIssues ?? '';

    setState(() {
      _gender = user.moreData?.gender;
      _maritalStatus = user.moreData?.maritalStatus;
      _bloodType = user.moreData?.bloodType;
      _hasChildren = user.moreData?.hasChildren;
      _numberOfChildren =
          int.tryParse(user.moreData?.numberOfChildren ?? '') ?? 0;
      _birthDate = DateTime.tryParse(user.moreData?.birthDate ?? '');
      _isSmoke = user.moreData?.isSmoke;
      _isInitialDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(
        title: "my_profile".tr(context),
        showBackButton: Navigator.of(context).canPop(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.whiteColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserSuccess) {
            _fillFormWithUser(state.user);
          }
        },
        builder: (context, state) {
          if (state is UserSuccess) {
            final String? currentImageUrl = state.user.mainData?.image;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(state, currentImageUrl),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileActionCard(
                            icon: Icons.person_outline_rounded,
                            title: _showInformationSection
                                ? 'save_changes'.tr(context)
                                : 'user_information'.tr(context),
                            subtitle: _showInformationSection
                                ? 'user_information'.tr(context)
                                : 'update_profile_info'.tr(context),
                            accentColor: AppColors.primaryColors,
                            isActive: _showInformationSection,
                            onTap: () {
                              setState(() {
                                _showInformationSection =
                                    !_showInformationSection;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ProfileActionCard(
                            icon: Icons.folder_open_rounded,
                            title: 'medical_files'.tr(context),
                            subtitle: 'all_files'.tr(context),
                            accentColor: AppColors.primaryColors,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShowMedicalFilesScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedCrossFade(
                      firstChild: _buildCollapsedHint(context),
                      secondChild: Column(
                        children: [
                          ProfileForm(
                            fnController: _fnController,
                            lnController: _lnController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            residenceController: _addressController,
                            heightController: _heightController,
                            weightController: _weightController,
                            chronicDiseasesController:
                                _chronicDiseasesController,
                            permanentMedicationsController:
                                _permanentMedicationsController,
                            foodAllergiesController: _foodAllergiesController,
                            favoriteFoodsController: _favoriteFoodsController,
                            dislikedFoodsController: _dislikedFoodsController,
                            digestionIssuesController:
                                _digestionIssuesController,
                            gender: _gender,
                            maritalStatus: _maritalStatus,
                            bloodType: _bloodType,
                            hasChildren: _hasChildren,
                            isSmoke: _isSmoke,
                            numberOfChildren: _numberOfChildren,
                            birthDate: _birthDate,
                            onGenderChanged: (v) {
                              setState(() {
                                _gender = v;
                                if (v == 'male') {
                                  _hasChildren = false;
                                  _numberOfChildren = 0;
                                }
                              });
                            },
                            onMaritalStatusChanged: (v) =>
                                setState(() => _maritalStatus = v),
                            onBloodTypeChanged: (v) =>
                                setState(() => _bloodType = v),
                            onChildrenChanged: (v) {
                              setState(() {
                                _hasChildren = v;
                                if (v != true) {
                                  _numberOfChildren = 0;
                                }
                              });
                            },
                            onSmokeChanged: (val) =>
                                setState(() => _isSmoke = val),
                            onBirthDateTap: _pickBirthDate,
                            onIncrementChildren: () =>
                                setState(() => _numberOfChildren++),
                            onDecrementChildren: () {
                              if (_numberOfChildren > 0) {
                                setState(() => _numberOfChildren--);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildSavePanel(context),
                        ],
                      ),
                      crossFadeState: _showInformationSection
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 220),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserError) {
            return Center(
              child: CustomErrorWidget(
                errorMessage: state.errorMsg.tr(context),
                textColor: AppColors.blackColor,
                onRetry: () {
                  context.read<UserCubit>().getProfile();
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserSuccess state, String? currentImageUrl) {
    final String fullName =
        '${state.user.mainData?.firstName ?? ''} ${state.user.mainData?.lastName ?? ''}'
            .trim();
    final String email = state.user.mainData?.email ?? '';
    final String phone = state.user.mainData?.phone ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ProfileAvatar(
                pickedImageFile: _pickedImage,
                currentImageUrl: currentImageUrl,
                onTap: _pickImage,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isEmpty ? 'my_profile'.tr(context) : fullName,
                      style: const TextStyle(
                        color: AppColors.titleColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email.isEmpty ? '--' : email,
                      style: TextStyle(
                        color: AppColors.grey700Color,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _pickImage,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColors,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                      label: Text(
                        _pickedImage == null
                            ? 'choose_image'.tr(context)
                            : 'change_selected_image'.tr(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildCompactInfoChip(
                icon: Icons.phone_outlined,
                text: phone.isEmpty ? '--' : phone,
              ),
              if ((_bloodType ?? '').isNotEmpty)
                _buildCompactInfoChip(
                  icon: Icons.bloodtype_outlined,
                  text: _displayRawValue(_bloodType),
                ),
              if ((_gender ?? '').isNotEmpty)
                _buildCompactInfoChip(
                  icon: Icons.wc_rounded,
                  text: _displayTranslatedValue(_gender, context),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.profileSurfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryColors, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.titleColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedHint(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: AppColors.primaryColors,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'update_profile_info'.tr(context),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavePanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: PrimaryButton(
        text: "save_changes".tr(context),
        onPressed: () => _onSaveChanges(context),
      ),
    );
  }

  String _displayRawValue(String? value) {
    final String normalized = (value ?? '').trim();
    return normalized;
  }

  String _displayTranslatedValue(String? value, BuildContext context) {
    final String normalized = (value ?? '').trim();
    return normalized.isEmpty ? '' : normalized.tr(context);
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isActive
                  ? accentColor.withValues(alpha: 0.28)
                  : AppColors.grey200Color,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: accentColor),
                  ),
                  const Spacer(),
                  Icon(
                    isActive
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.arrow_forward_rounded,
                    color: accentColor,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: AppColors.grey700Color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
