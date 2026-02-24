import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';

import '../view_models/diagnosis_cubit.dart';
import 'question_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/DiagnosisCategories';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static const List<_BodyPartDescriptor> _bodyParts = [
    _BodyPartDescriptor(
      id: 'head',
      backendValue: 'Head',
      labelEn: 'Head',
      labelAr: 'الرأس',
      icon: Icons.face_rounded,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'neck',
      backendValue: 'Neck',
      labelEn: 'Neck',
      labelAr: 'الرقبة',
      icon: Icons.accessibility_new,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'leftChest',
      backendValue: 'Left Chest',
      labelEn: 'Left Chest',
      labelAr: 'الصدر الأيسر',
      icon: Icons.favorite_border,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'chest',
      backendValue: 'Chest',
      labelEn: 'Chest',
      labelAr: 'الصدر',
      icon: Icons.monitor_heart_outlined,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'abdomen',
      backendValue: 'Abdomen',
      labelEn: 'Abdomen',
      labelAr: 'البطن',
      icon: Icons.airline_seat_flat,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'leftArm',
      backendValue: 'Left Arm',
      labelEn: 'Left Arm',
      labelAr: 'الذراع الأيسر',
      icon: Icons.pan_tool_alt_outlined,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'rightArm',
      backendValue: 'Right Arm',
      labelEn: 'Right Arm',
      labelAr: 'الذراع الأيمن',
      icon: Icons.pan_tool_alt_outlined,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'leftLeg',
      backendValue: 'Left Leg',
      labelEn: 'Left Leg',
      labelAr: 'الساق اليسرى',
      icon: Icons.directions_walk,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'rightLeg',
      backendValue: 'Right Leg',
      labelEn: 'Right Leg',
      labelAr: 'الساق اليمنى',
      icon: Icons.directions_walk,
      side: _BodySide.front,
    ),
    _BodyPartDescriptor(
      id: 'lowerBack',
      backendValue: 'Lower Back',
      labelEn: 'Lower Back',
      labelAr: 'أسفل الظهر',
      icon: Icons.airline_seat_recline_normal,
      side: _BodySide.back,
    ),
    _BodyPartDescriptor(
      id: 'upperBack',
      backendValue: 'Upper Back',
      labelEn: 'Upper Back',
      labelAr: 'أعلى الظهر',
      icon: Icons.airline_seat_recline_extra,
      side: _BodySide.back,
    ),
    _BodyPartDescriptor(
      id: 'leftShoulderBack',
      backendValue: 'Left Shoulder',
      labelEn: 'Left Shoulder (Back)',
      labelAr: 'خلف الكتف الأيسر',
      icon: Icons.accessibility,
      side: _BodySide.back,
    ),
    _BodyPartDescriptor(
      id: 'rightShoulderBack',
      backendValue: 'Right Shoulder',
      labelEn: 'Right Shoulder (Back)',
      labelAr: 'خلف الكتف الأيمن',
      icon: Icons.accessibility,
      side: _BodySide.back,
    ),
    _BodyPartDescriptor(
      id: 'leftHip',
      backendValue: 'Left Hip',
      labelEn: 'Left Hip',
      labelAr: 'الورك الأيسر',
      icon: Icons.accessibility_new,
      side: _BodySide.back,
    ),
    _BodyPartDescriptor(
      id: 'rightHip',
      backendValue: 'Right Hip',
      labelEn: 'Right Hip',
      labelAr: 'الورك الأيمن',
      icon: Icons.accessibility_new,
      side: _BodySide.back,
    ),
    _BodyPartDescriptor(
      id: 'leftCalf',
      backendValue: 'Left Calf',
      labelEn: 'Left Calf',
      labelAr: 'ربلة الساق اليسرى',
      icon: Icons.directions_walk,
      side: _BodySide.back,
    ),
    _BodyPartDescriptor(
      id: 'rightCalf',
      backendValue: 'Right Calf',
      labelEn: 'Right Calf',
      labelAr: 'ربلة الساق اليمنى',
      icon: Icons.directions_walk,
      side: _BodySide.back,
    ),
  ];

  _BodySide _currentSide = _BodySide.front;
  String? _selectedPartKey;

  @override
  void initState() {
    super.initState();
    _selectedPartKey = context.read<DiagnosisCubit>().state.selectedBodyPartKey;
  }

  void _selectPart(_BodyPartDescriptor part) {
    setState(() {
      _selectedPartKey = part.id;
    });
    context.read<DiagnosisCubit>().selectBodyPart(
      partKey: part.id,
      partLabel: part.backendValue,
    );
  }

  void _openSymptomsStep() {
    final _BodyPartDescriptor? selected = _bodyParts
        .where((item) => item.id == _selectedPartKey)
        .firstOrNull;

    if (selected == null) {
      messages(context, 'select_body_part_first'.tr(context), Colors.orange);
      return;
    }

    context.read<DiagnosisCubit>().fetchSymptomsForSelectedPart();
    Navigator.of(context).pushNamed(QuestionScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final _BodyPartDescriptor? selected = _bodyParts
        .where((item) => item.id == _selectedPartKey)
        .firstOrNull;

    final List<_BodyPartDescriptor> visibleParts = _bodyParts
        .where((part) => part.side == _currentSide)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppbar(
        title: 'diagnose_category'.tr(context),
        showBackButton: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  'select_body_part_instruction'.tr(context),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _SideButton(
                      label: 'front_side'.tr(context),
                      selected: _currentSide == _BodySide.front,
                      onTap: () =>
                          setState(() => _currentSide = _BodySide.front),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SideButton(
                      label: 'back_side'.tr(context),
                      selected: _currentSide == _BodySide.back,
                      onTap: () =>
                          setState(() => _currentSide = _BodySide.back),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: visibleParts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    final part = visibleParts[index];
                    final bool isSelected = part.id == _selectedPartKey;
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _selectPart(part),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColors
                                : Colors.grey.shade200,
                            width: isSelected ? 1.8 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              part.icon,
                              color: isSelected
                                  ? AppColors.primaryColors
                                  : Colors.grey.shade700,
                              size: 26,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isArabic ? part.labelAr : part.labelEn,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isSelected
                                    ? AppColors.primaryColors
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: selected == null
                          ? Colors.grey.shade400
                          : AppColors.primaryColors,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selected == null
                            ? 'no_body_part_selected'.tr(context)
                            : (isArabic ? selected.labelAr : selected.labelEn),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected == null
                              ? Colors.grey.shade500
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'next'.tr(context),
                onPressed: _openSymptomsStep,
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _BodySide { front, back }

class _BodyPartDescriptor {
  final String id;
  final String backendValue;
  final String labelEn;
  final String labelAr;
  final IconData icon;
  final _BodySide side;

  const _BodyPartDescriptor({
    required this.id,
    required this.backendValue,
    required this.labelEn,
    required this.labelAr,
    required this.icon,
    required this.side,
  });
}

class _SideButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SideButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? AppColors.primaryColors.withValues(alpha: 0.14)
              : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primaryColors : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? AppColors.primaryColors : Colors.grey.shade700,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNullX<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
