import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
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
  late TextEditingController _preferredFoodsController;
  late TextEditingController _dislikedFoodsController;
  late TextEditingController _digestionIssuesController;

  String? _maritalStatus;
  bool? _isSmoke;

  bool _isInitialDataLoaded = false;
  bool _showInformationSection = false;
  File? _pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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
    _preferredFoodsController = TextEditingController();
    _dislikedFoodsController = TextEditingController();
    _digestionIssuesController = TextEditingController();
    _maritalStatus = null;
    _isSmoke = null;
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
    _preferredFoodsController.dispose();
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
        'weight': _weightController.text,
        'height': _heightController.text,
        'marital_status': _maritalStatus?.toLowerCase(),
        'is_smoke': _isSmoke == true ? '1' : '0',
        'chronic_diseases': _parseListInput(_chronicDiseasesController.text),
        'permanent_medications': _parseListInput(
          _permanentMedicationsController.text,
        ),
        'food_allergies': _parseListInput(_foodAllergiesController.text),
        'preferred_foods': _parseListInput(_preferredFoodsController.text),
        'disliked_foods': _parseListInput(_dislikedFoodsController.text),
        'digestion_issues': _parseListInput(_digestionIssuesController.text),
        '_method': 'PUT',
      };

      if (_pickedImage != null) {
        registerData['profile_image'] = _pickedImage;
      }

      context.read<UserCubit>().updateProfile(registerData);
    } else {
      messages(context, 'fix_form_error'.tr(context), Colors.red);
    }
  }

  List<String> _parseListInput(String value) {
    return value
        .split(RegExp(r'[\n,]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String _stringifyList(List<String> values) {
    return values.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "my_profile".tr(context),
        showBackButton: Navigator.of(context).canPop(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
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
          if (state is UserSuccess && !_isInitialDataLoaded) {
            _fnController.text = state.user.mainData?.firstName ?? '';
            _lnController.text = state.user.mainData?.lastName ?? '';
            _emailController.text = state.user.mainData?.email ?? '';
            _phoneController.text = state.user.mainData?.phone ?? '';
            _addressController.text = state.user.moreData?.address ?? '';
            _heightController.text =
                state.user.moreData?.height?.toString() ?? '';
            _weightController.text =
                state.user.moreData?.weight?.toString() ?? '';
            _chronicDiseasesController.text = _stringifyList(
              state.user.moreData?.chronicDiseases ?? const <String>[],
            );
            _permanentMedicationsController.text = _stringifyList(
              state.user.moreData?.permanentMedications ?? const <String>[],
            );
            _foodAllergiesController.text = _stringifyList(
              state.user.moreData?.foodAllergies ?? const <String>[],
            );
            _preferredFoodsController.text = _stringifyList(
              state.user.moreData?.preferredFoods ?? const <String>[],
            );
            _dislikedFoodsController.text = _stringifyList(
              state.user.moreData?.dislikedFoods ?? const <String>[],
            );
            _digestionIssuesController.text = _stringifyList(
              state.user.moreData?.digestionIssues ?? const <String>[],
            );

            setState(() {
              _maritalStatus = state.user.moreData?.maritalStatus;
              _isSmoke = state.user.moreData?.isSmoke;
              _isInitialDataLoaded = true;
            });
          }
        },
        builder: (context, state) {
          if (state is UserSuccess) {
            final String? currentImageUrl = state.user.mainData?.image;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(state, currentImageUrl),
                    const SizedBox(height: 24),
                    Text(
                      'quick_actions'.tr(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileActionCard(
                            icon: Icons.person_outline_rounded,
                            title: 'user_information'.tr(context),
                            subtitle: 'update_profile_info'.tr(context),
                            onTap: () {
                              setState(() {
                                _showInformationSection =
                                    !_showInformationSection;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _ProfileActionCard(
                            icon: Icons.folder_open_rounded,
                            title: 'medical_files'.tr(context),
                            subtitle: 'open_saved_medical_files'.tr(context),
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
                    const SizedBox(height: 20),
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
                            preferredFoodsController: _preferredFoodsController,
                            dislikedFoodsController: _dislikedFoodsController,
                            digestionIssuesController:
                                _digestionIssuesController,
                            maritalStatus: _maritalStatus,
                            isSmoke: _isSmoke,
                            onMaritalStatusChanged: (v) =>
                                setState(() => _maritalStatus = v),
                            onSmokeChanged: (val) =>
                                setState(() => _isSmoke = val),
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            text: "save_changes".tr(context),
                            onPressed: () => _onSaveChanges(context),
                          ),
                        ],
                      ),
                      crossFadeState: _showInformationSection
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserError) {
            return Center(
              child: CustomErrorWidget(
                errorMessage: state.errorMsg.tr(context),
                textColor: Colors.black,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColors, AppColors.secColors],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColors.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileAvatar(
            pickedImageFile: _pickedImage,
            currentImageUrl: currentImageUrl,
            onTap: _pickImage,
          ),
          const SizedBox(height: 16),
          Text(
            fullName.isEmpty ? 'my_profile'.tr(context) : fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildHeaderStat(
                  icon: Icons.phone_outlined,
                  label: 'phone'.tr(context),
                  value: phone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHeaderStat(
                  icon: Icons.favorite_outline_rounded,
                  label: 'are_you_a_smoker'.tr(context),
                  value: _isSmoke == true
                      ? 'yes'.tr(context)
                      : 'no'.tr(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '--' : value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedHint(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.touch_app_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'tap_user_information_hint'.tr(context),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
