import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
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

  String? _maritalStatus;
  bool? _isSmoke;

  bool _isInitialDataLoaded = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "my_profile".tr(context),
        showBackButton: false,
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
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ProfileAvatar(
                      pickedImageFile: _pickedImage,
                      currentImageUrl: currentImageUrl,
                      onTap: _pickImage,
                    ),
                    const SizedBox(height: 24),
                    ProfileForm(
                      fnController: _fnController,
                      lnController: _lnController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      residenceController: _addressController,
                      heightController: _heightController,
                      weightController: _weightController,
                      maritalStatus: _maritalStatus,
                      isSmoke: _isSmoke,
                      onMaritalStatusChanged: (v) =>
                          setState(() => _maritalStatus = v),
                      onSmokeChanged: (val) => setState(() => _isSmoke = val),
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      text: "save_changes".tr(context),
                      onPressed: () => _onSaveChanges(context),
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
}
