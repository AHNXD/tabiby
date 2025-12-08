import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/main_screen.dart';

import '../../../../../../user_app/user/presentation/view-model/user_cubit/user_cubit.dart';
import '../../../../view-model/register_cubit/register_cubit.dart';
import '../widgets/step1_widget.dart';
import '../widgets/step2_widget.dart';
import '../widgets/step3_widget.dart';
import 'progress_section.dart';

class StepsSectionWrapper extends StatefulWidget {
  const StepsSectionWrapper({super.key});

  @override
  State<StepsSectionWrapper> createState() => _StepsSectionWrapperState();
}

class _StepsSectionWrapperState extends State<StepsSectionWrapper> {
  final PageController _pageController = PageController();
  int currentStep = 0;
  final GlobalKey<FormState> _step1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2Key = GlobalKey<FormState>();
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();

  String? gender;
  String? maritalStatus;
  bool? hasChildren;
  bool? isSmoke;
  int numberOfChildren = 0;
  bool agreeToTerms = false;
  DateTime? selectedBirthDate;

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    addressCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void goToStep(int step) {
    setState(() => currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goToNext() {
    if (currentStep == 0) {
      if (_step1Key.currentState!.validate()) {
        goToStep(currentStep + 1);
      }
    } else if (currentStep == 1) {
      if (_step2Key.currentState!.validate()) {
        goToStep(currentStep + 1);
      }
    }
  }

  void _onSignUpPressed(BuildContext context) {
    if (maritalStatus == null) {
      messages(context, 'please_select_marital_status'.tr(context), Colors.red);
      return;
    }

    if (isSmoke == null) {
      messages(context, 'please_select_smoking_status'.tr(context), Colors.red);
      return;
    }

    if (selectedBirthDate == null) {
      messages(context, 'select_your_birth'.tr(context), Colors.red);
      return;
    }
    if (!agreeToTerms) {
      messages(context, 'please_agree_terms'.tr(context), Colors.red);
      return;
    }

    final Map<String, dynamic> registerData = {
      'first_name': firstNameCtrl.text,
      'last_name': lastNameCtrl.text,
      'phone': phoneCtrl.text,
      'email': emailCtrl.text,
      'password': passwordCtrl.text,
      'address': addressCtrl.text,
      'gender': gender!.toLowerCase(),
      'weight': weightCtrl.text,
      'height': heightCtrl.text,
      'marital_status': maritalStatus!.toLowerCase(),
      'has_children': hasChildren == true ? '1' : '0',
      'number_of_children': numberOfChildren.toString(),
      'birth_date': selectedBirthDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedBirthDate!)
          : null,
      'is_smoke': isSmoke == true ? '1' : '0',
    };

    context.read<RegisterCubit>().register(registerData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          messages(
            context,
            "registration_successful".tr(context),
            Colors.green,
          );
          context.read<UserCubit>().getProfile();
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainScreen.routeName,
            (route) => false,
          );
        } else if (state is RegisterError) {
          messages(context, state.errorMsg.tr(context), Colors.red);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            ProgressSection(currentStep: currentStep, onStepTapped: goToStep),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1Widget(
                    formKey: _step1Key,
                    onNext: goToNext,
                    firstNameCtrl: firstNameCtrl,
                    lastNameCtrl: lastNameCtrl,
                    phoneCtrl: phoneCtrl,
                    emailCtrl: emailCtrl,
                    passwordCtrl: passwordCtrl,
                  ),
                  Step2Widget(
                    formKey: _step2Key,
                    onNext: goToNext,
                    addressCtrl: addressCtrl,
                    weightCtrl: weightCtrl,
                    heightCtrl: heightCtrl,
                    selectedGender: gender, // Pass current value
                    onGenderChanged: (val) => setState(() => gender = val),
                  ),
                  Step3Widget(
                    gender: gender ?? 'female'.tr(context),
                    hasChildren: gender == 'male'.tr(context)
                        ? false
                        : hasChildren,
                    isSmoke: isSmoke,
                    numberOfChildren: gender == 'male'.tr(context)
                        ? 0
                        : numberOfChildren,
                    agreeToTerms: agreeToTerms,
                    selectedDate: selectedBirthDate,
                    isLoading: state is RegisterLoading,
                    onDateChanged: (val) =>
                        setState(() => selectedBirthDate = val),
                    onSmokeChanged: (val) => setState(() => isSmoke = val),
                    onMaritalStatusChanged: (val) =>
                        setState(() => maritalStatus = val),
                    onChildrenChanged: (val) {
                      if (gender != 'male'.tr(context)) {
                        setState(() {
                          hasChildren = val;
                          if (val == false) numberOfChildren = 0;
                        });
                      }
                    },
                    onIncrement: () {
                      if (gender != 'male'.tr(context)) {
                        setState(() => numberOfChildren++);
                      }
                    },
                    onDecrement: () {
                      if (gender != 'male'.tr(context) &&
                          numberOfChildren > 0) {
                        setState(() => numberOfChildren--);
                      }
                    },
                    onAgreeToggle: () =>
                        setState(() => agreeToTerms = !agreeToTerms),
                    onSignUp: () => _onSignUpPressed(context),
                    maritalStatus: 'single'.tr(context),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
