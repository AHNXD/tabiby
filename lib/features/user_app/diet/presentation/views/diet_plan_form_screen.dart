import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/ai_usage/ai_usage_cubit.dart';
import 'package:tabiby/core/models/ai_usage_models.dart';
import 'package:tabiby/features/auth/data/models/user_model.dart';
import 'package:tabiby/features/user_app/diet/data/models/diet_request_data.dart';
import 'package:tabiby/features/user_app/diet/presentation/view_models/diet_cubit.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/diet_result_screen.dart';
import 'package:tabiby/features/user_app/diet/presentation/views/widgets/diet_form_sections.dart';
import 'package:tabiby/features/user_app/user/presentation/view-model/user_cubit/user_cubit.dart';

class DietPlanFormScreen extends StatefulWidget {
  const DietPlanFormScreen({
    super.key,
    required this.isSpecialist,
    this.initialRequest,
  });

  final bool isSpecialist;
  final DietRequestData? initialRequest;

  @override
  State<DietPlanFormScreen> createState() => _DietPlanFormScreenState();
}

class _DietPlanFormScreenState extends State<DietPlanFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _genderController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _jobNatureController;
  late final TextEditingController _goalController;
  late final TextEditingController _chronicDiseasesController;
  late final TextEditingController _medicationsController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _digestionIssuesController;
  late final TextEditingController _mealsPerDayController;
  late final TextEditingController _sweetsFrequencyController;
  late final TextEditingController _sodaFrequencyController;
  late final TextEditingController _eatingOutFrequencyController;
  late final TextEditingController _exerciseController;
  late final TextEditingController _sleepHoursController;
  late final TextEditingController _insomniaController;
  late final TextEditingController _emotionalEatingController;
  late final TextEditingController _eatingSpeedController;
  late final TextEditingController _dietTypeController;
  late final TextEditingController _macroDistributionController;
  late final TextEditingController _specialistNotesController;

  bool _didPrefillUserData = false;
  bool _didApplyLocalizedDefaults = false;
  bool _didApplyRequestData = false;

  @override
  void initState() {
    super.initState();
    _initControllers();

    final DietRequestData? cachedRequest =
        widget.initialRequest ?? context.read<DietCubit>().state.currentRequest;
    if (cachedRequest != null &&
        cachedRequest.isSpecialist == widget.isSpecialist) {
      _applyRequestData(cachedRequest);
      _didApplyRequestData = true;
    }

    final userState = context.read<UserCubit>().state;
    _prefillFromUserState(userState, canReplaceLocalizedDefaults: false);
    if (userState is! UserSuccess) {
      context.read<UserCubit>().getProfile();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyLocalizedDefaultsIfNeeded();
  }

  void _initControllers() {
    _nameController = TextEditingController();
    _ageController = TextEditingController(text: '30');
    _genderController = TextEditingController();
    _heightController = TextEditingController(text: '170');
    _weightController = TextEditingController(text: '75');
    _jobNatureController = TextEditingController();
    _goalController = TextEditingController();
    _chronicDiseasesController = TextEditingController();
    _medicationsController = TextEditingController();
    _allergiesController = TextEditingController();
    _digestionIssuesController = TextEditingController();
    _mealsPerDayController = TextEditingController(text: '3');
    _sweetsFrequencyController = TextEditingController();
    _sodaFrequencyController = TextEditingController();
    _eatingOutFrequencyController = TextEditingController();
    _exerciseController = TextEditingController();
    _sleepHoursController = TextEditingController(text: '7');
    _insomniaController = TextEditingController();
    _emotionalEatingController = TextEditingController();
    _eatingSpeedController = TextEditingController();
    _dietTypeController = TextEditingController();
    _macroDistributionController = TextEditingController();
    _specialistNotesController = TextEditingController();
  }

  void _applyLocalizedDefaultsIfNeeded() {
    if (_didApplyLocalizedDefaults) {
      return;
    }

    _setIfEmpty(_jobNatureController, 'diet_default_job_nature'.tr(context));
    _setIfEmpty(_goalController, 'diet_default_goal'.tr(context));
    _setIfEmpty(
      _chronicDiseasesController,
      'diet_default_none_value'.tr(context),
    );
    _setIfEmpty(_medicationsController, 'diet_default_none_value'.tr(context));
    _setIfEmpty(_allergiesController, 'diet_default_none_value'.tr(context));
    _setIfEmpty(
      _digestionIssuesController,
      'diet_default_none_value'.tr(context),
    );
    _setIfEmpty(
      _sweetsFrequencyController,
      'diet_default_sweets_frequency'.tr(context),
    );
    _setIfEmpty(
      _sodaFrequencyController,
      'diet_default_soda_frequency'.tr(context),
    );
    _setIfEmpty(
      _eatingOutFrequencyController,
      'diet_default_eating_out_frequency'.tr(context),
    );
    _setIfEmpty(_exerciseController, 'diet_default_exercise'.tr(context));
    _setIfEmpty(_insomniaController, 'no'.tr(context));
    _setIfEmpty(_emotionalEatingController, 'no'.tr(context));
    _setIfEmpty(
      _eatingSpeedController,
      'diet_default_eating_speed'.tr(context),
    );

    _didApplyLocalizedDefaults = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _jobNatureController.dispose();
    _goalController.dispose();
    _chronicDiseasesController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _digestionIssuesController.dispose();
    _mealsPerDayController.dispose();
    _sweetsFrequencyController.dispose();
    _sodaFrequencyController.dispose();
    _eatingOutFrequencyController.dispose();
    _exerciseController.dispose();
    _sleepHoursController.dispose();
    _insomniaController.dispose();
    _emotionalEatingController.dispose();
    _eatingSpeedController.dispose();
    _dietTypeController.dispose();
    _macroDistributionController.dispose();
    _specialistNotesController.dispose();
    super.dispose();
  }

  void _applyRequestData(DietRequestData request) {
    _nameController.text = request.name;
    _ageController.text = request.age.toString();
    _genderController.text = request.gender;
    _heightController.text = request.height.toString();
    _weightController.text = request.weight.toString();
    _jobNatureController.text = request.jobNature;
    _goalController.text = request.goal;
    _chronicDiseasesController.text = request.chronicDiseases;
    _medicationsController.text = request.medications;
    _allergiesController.text = request.allergies;
    _digestionIssuesController.text = request.digestionIssues;
    _mealsPerDayController.text = request.mealsPerDay.toString();
    _sweetsFrequencyController.text = request.sweetsFrequency;
    _sodaFrequencyController.text = request.sodaFrequency;
    _eatingOutFrequencyController.text = request.eatingOutFrequency;
    _exerciseController.text = request.exercise;
    _sleepHoursController.text = request.sleepHours.toString();
    _insomniaController.text = request.insomnia;
    _emotionalEatingController.text = request.emotionalEating;
    _eatingSpeedController.text = request.eatingSpeed;
    _dietTypeController.text = request.dietType ?? '';
    _macroDistributionController.text = request.macroDistribution ?? '';
    _specialistNotesController.text = request.specialistNotes ?? '';
  }

  void _prefillFromUserState(
    UserState state, {
    bool canReplaceLocalizedDefaults = true,
  }) {
    if (_didPrefillUserData || _didApplyRequestData || state is! UserSuccess) {
      return;
    }

    final UserModel user = state.user;
    final String fullName =
        '${user.mainData?.firstName ?? ''} ${user.mainData?.lastName ?? ''}'
            .trim();
    final String? birthDate = user.moreData?.birthDate;
    final int? age = _calculateAge(birthDate);

    _setProfileValue(_nameController, fullName);
    if (age != null) {
      _setProfileValue(_ageController, age.toString(), defaultValues: ['30']);
    }

    _setProfileValue(_genderController, user.moreData?.gender ?? '');
    _setProfileValue(
      _heightController,
      user.moreData?.height ?? '',
      defaultValues: ['170'],
    );
    _setProfileValue(
      _weightController,
      user.moreData?.weight ?? '',
      defaultValues: ['75'],
    );
    _setProfileValue(
      _chronicDiseasesController,
      user.moreData?.chronicDiseases ?? '',
      defaultValues: canReplaceLocalizedDefaults
          ? [_localizedDefaultNoneValue]
          : const <String>[],
    );
    _setProfileValue(
      _medicationsController,
      user.moreData?.permanentMedications ?? '',
      defaultValues: canReplaceLocalizedDefaults
          ? [_localizedDefaultNoneValue]
          : const <String>[],
    );
    _setProfileValue(
      _allergiesController,
      user.moreData?.foodAllergies ?? '',
      defaultValues: canReplaceLocalizedDefaults
          ? [_localizedDefaultNoneValue]
          : const <String>[],
    );
    _setProfileValue(
      _digestionIssuesController,
      user.moreData?.digestionIssues ?? '',
      defaultValues: canReplaceLocalizedDefaults
          ? [_localizedDefaultNoneValue]
          : const <String>[],
    );

    _didPrefillUserData = true;
  }

  void _setIfEmpty(TextEditingController controller, String value) {
    if (controller.text.trim().isEmpty && value.trim().isNotEmpty) {
      controller.text = value;
    }
  }

  String get _localizedDefaultNoneValue {
    return 'diet_default_none_value'.tr(context);
  }

  void _setProfileValue(
    TextEditingController controller,
    String value, {
    List<String> defaultValues = const [],
  }) {
    final String trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return;
    }

    final String currentValue = controller.text.trim();
    final bool canReplaceCurrentValue =
        currentValue.isEmpty ||
        defaultValues.any(
          (defaultValue) => defaultValue.trim() == currentValue,
        );

    if (canReplaceCurrentValue) {
      controller.text = trimmedValue;
    }
  }

  int? _calculateAge(String? birthDate) {
    if (birthDate == null || birthDate.trim().isEmpty) {
      return null;
    }

    final DateTime? parsed = DateTime.tryParse(birthDate);
    if (parsed == null) {
      return null;
    }

    final now = DateTime.now();
    int years = now.year - parsed.year;
    if (DateTime(now.year, parsed.month, parsed.day).isAfter(now)) {
      years -= 1;
    }

    return years < 0 ? null : years;
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'this_field_is_required'.tr(context);
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = DietRequestData(
      name: _nameController.text.trim(),
      age: _parseInt(_ageController.text, 30),
      gender: _genderController.text.trim(),
      height: _parseDouble(_heightController.text, 170),
      weight: _parseDouble(_weightController.text, 75),
      jobNature: _jobNatureController.text.trim(),
      goal: _goalController.text.trim(),
      chronicDiseases: _chronicDiseasesController.text.trim(),
      medications: _medicationsController.text.trim(),
      allergies: _allergiesController.text.trim(),
      digestionIssues: _digestionIssuesController.text.trim(),
      mealsPerDay: _parseInt(_mealsPerDayController.text, 3),
      sweetsFrequency: _sweetsFrequencyController.text.trim(),
      sodaFrequency: _sodaFrequencyController.text.trim(),
      eatingOutFrequency: _eatingOutFrequencyController.text.trim(),
      exercise: _exerciseController.text.trim(),
      sleepHours: _parseDouble(_sleepHoursController.text, 7),
      insomnia: _insomniaController.text.trim(),
      emotionalEating: _emotionalEatingController.text.trim(),
      eatingSpeed: _eatingSpeedController.text.trim(),
      isSpecialist: widget.isSpecialist,
      dietType: _dietTypeController.text.trim(),
      macroDistribution: _macroDistributionController.text.trim(),
      specialistNotes: _specialistNotesController.text.trim(),
    );

    context.read<DietCubit>().generateDietPlan(request);
  }

  int _parseInt(String value, int fallback) {
    return int.tryParse(value.trim()) ?? fallback;
  }

  double _parseDouble(String value, double fallback) {
    return double.tryParse(value.trim()) ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            _prefillFromUserState(state);
          },
        ),
        BlocListener<DietCubit, DietState>(
          listenWhen: (previous, current) =>
              previous.submitStatus != current.submitStatus,
          listener: (context, state) {
            if (state.submitStatus == DietAsyncStatus.loading) {
              messages(
                context,
                'diet_form_loading_toast'.tr(context),
                AppColors.primaryColors,
                msgTime: 4,
              );
            }

            if (state.submitStatus == DietAsyncStatus.error) {
              messages(
                context,
                state.errorMessage.tr(context),
                AppColors.redColor,
              );
            }

            if (state.submitStatus == DietAsyncStatus.success &&
                state.plan != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DietResultScreen()),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppbar(
          title: widget.isSpecialist
              ? 'diet_form_title_advanced'.tr(context)
              : 'diet_form_title_basic'.tr(context),
        ),
        body: BlocBuilder<DietCubit, DietState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.isGenerating)
                    DietFormLoadingBanner(
                      text: 'diet_form_loading_banner'.tr(context),
                    ),
                  DietFormIntroCard(
                    title: widget.isSpecialist
                        ? 'diet_form_title_advanced'.tr(context)
                        : 'diet_form_title_basic'.tr(context),
                    subtitle: widget.isSpecialist
                        ? 'diet_mode_advanced_subtitle'.tr(context)
                        : 'diet_mode_basic_subtitle'.tr(context),
                    icon: widget.isSpecialist
                        ? Icons.medical_services_outlined
                        : Icons.person_outline_rounded,
                  ),
                  DietFormSectionCard(
                    child: Column(
                      children: [
                        DietFormSectionTitle(
                          title: 'diet_form_section_basic'.tr(context),
                          icon: Icons.badge_outlined,
                        ),
                        DietLabeledCustomField(
                          controller: _nameController,
                          label: 'diet_form_name'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _ageController,
                          label: 'diet_form_age'.tr(context),
                          keyboardType: TextInputType.number,
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _genderController,
                          label: 'diet_form_gender'.tr(context),
                          validator: _required,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DietLabeledCustomField(
                                controller: _heightController,
                                label: 'diet_form_height_cm'.tr(context),
                                keyboardType: TextInputType.number,
                                validator: _required,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DietLabeledCustomField(
                                controller: _weightController,
                                label: 'diet_form_weight_kg'.tr(context),
                                keyboardType: TextInputType.number,
                                validator: _required,
                              ),
                            ),
                          ],
                        ),
                        DietLabeledCustomField(
                          controller: _jobNatureController,
                          label: 'diet_form_job_nature'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _goalController,
                          label: 'diet_form_goal'.tr(context),
                          validator: _required,
                        ),
                      ],
                    ),
                  ),
                  DietFormSectionCard(
                    child: Column(
                      children: [
                        DietFormSectionTitle(
                          title: 'diet_form_section_health'.tr(context),
                          icon: Icons.favorite_border_rounded,
                        ),
                        DietLabeledCustomField(
                          controller: _chronicDiseasesController,
                          label: 'diet_form_chronic_diseases'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _medicationsController,
                          label: 'diet_form_medications'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _allergiesController,
                          label: 'diet_form_allergies'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _digestionIssuesController,
                          label: 'diet_form_digestion_issues'.tr(context),
                          validator: _required,
                        ),
                      ],
                    ),
                  ),
                  DietFormSectionCard(
                    child: Column(
                      children: [
                        DietFormSectionTitle(
                          title: 'diet_form_section_habits'.tr(context),
                          icon: Icons.self_improvement_outlined,
                        ),
                        DietLabeledCustomField(
                          controller: _mealsPerDayController,
                          label: 'diet_form_meals_per_day'.tr(context),
                          keyboardType: TextInputType.number,
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _sweetsFrequencyController,
                          label: 'diet_form_sweets_frequency'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _sodaFrequencyController,
                          label: 'diet_form_soda_frequency'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _eatingOutFrequencyController,
                          label: 'diet_form_eating_out_frequency'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _exerciseController,
                          label: 'diet_form_exercise'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _sleepHoursController,
                          label: 'diet_form_sleep_hours'.tr(context),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _insomniaController,
                          label: 'diet_form_insomnia'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _emotionalEatingController,
                          label: 'diet_form_emotional_eating'.tr(context),
                          validator: _required,
                        ),
                        DietLabeledCustomField(
                          controller: _eatingSpeedController,
                          label: 'diet_form_eating_speed'.tr(context),
                          validator: _required,
                        ),
                      ],
                    ),
                  ),
                  if (widget.isSpecialist) ...[
                    DietFormSectionCard(
                      child: Column(
                        children: [
                          DietFormSectionTitle(
                            title: 'diet_form_section_specialist'.tr(context),
                            icon: Icons.tune_rounded,
                          ),
                          DietLabeledCustomField(
                            controller: _dietTypeController,
                            label: 'diet_form_diet_type'.tr(context),
                            validator: _required,
                          ),
                          DietLabeledCustomField(
                            controller: _macroDistributionController,
                            label: 'diet_form_macro_distribution'.tr(context),
                            validator: _required,
                          ),
                          DietLabeledCustomField(
                            controller: _specialistNotesController,
                            label: 'diet_form_specialist_notes'.tr(context),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withValues(alpha: 0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: BlocBuilder<AiUsageCubit, AiUsageState>(
                      builder: (context, usageState) {
                        final usage = usageState
                            .remainingByFeature[AiFeatureType.programDiet];

                        final String usageText = usage == null
                            ? ''
                            : '${'ai_usage_used'.tr(context)}: ${usage.used}/${usage.limit} • ${'ai_usage_remaining'.tr(context)}: ${usage.remaining}';

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (usageText.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  usageText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.grey800Color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            PrimaryButton(
                              text: state.isGenerating
                                  ? 'diet_form_generating'.tr(context)
                                  : 'diet_form_generate_button'.tr(context),
                              fontSize: 20,
                              onPressed: state.isGenerating
                                  ? null
                                  : () {
                                      _submit();
                                    },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
