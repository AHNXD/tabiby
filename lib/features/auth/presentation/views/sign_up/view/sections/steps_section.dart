import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/features/user_app/home/presentation/view/home_screen.dart';

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
    if (currentStep < 2) goToStep(currentStep + 1);
  }

  void _onSignUpPressed(BuildContext context) {
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        } else if (state is RegisterError) {
          messages(context, state.errorMsg, Colors.red);
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
                  // Pass controllers down
                  Step1Widget(
                    onNext: goToNext,
                    firstNameCtrl: firstNameCtrl,
                    lastNameCtrl: lastNameCtrl,
                    phoneCtrl: phoneCtrl,
                    emailCtrl: emailCtrl,
                    passwordCtrl: passwordCtrl,
                  ),
                  Step2Widget(
                    onNext: goToNext,
                    housingCtrl: addressCtrl,
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
                    isLoading:
                        state is RegisterLoading, // Handle loading state in UI
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
