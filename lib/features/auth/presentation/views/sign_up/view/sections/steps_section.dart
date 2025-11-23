import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

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
  String? gender;
  String? marialStatus;
  bool? hasChildren;
  bool? isSmoke;
  int numberOfChildren = 0;
  bool agreeToTerms = false;

  void goToStep(int step) {
    setState(() {
      currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goToNext() {
    if (currentStep < 2) goToStep(currentStep + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressSection(currentStep: currentStep, onStepTapped: goToStep),
        const SizedBox(height: 20),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Step1Widget(onNext: goToNext),
              Step2Widget(
                onNext: goToNext,
                onGenderChanged: (val) => setState(() => gender = val),
              ),
              Step3Widget(
                gender: gender ?? 'female'.tr(context),
                hasChildren: gender == 'male'.tr(context) ? false : hasChildren,
                isSmoke: isSmoke,
                onSmokeChanged: (val) {
                  setState(() {
                    isSmoke = val;
                  });
                },
                onMaritalStatusChanged: (val) =>
                    setState(() => marialStatus = val),
                numberOfChildren: gender == 'male'.tr(context)
                    ? 0
                    : numberOfChildren,
                agreeToTerms: agreeToTerms,
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
                  if (gender != 'male'.tr(context) && numberOfChildren > 0) {
                    setState(() => numberOfChildren--);
                  }
                },
                onAgreeToggle: () =>
                    setState(() => agreeToTerms = !agreeToTerms),
                onSignUp: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
