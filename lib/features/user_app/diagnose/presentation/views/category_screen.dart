import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';

import '../view_models/diagnosis_cubit.dart';
import 'question_screen.dart';
import 'widgets/body_part_catalog.dart';
import 'widgets/category_sections.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/DiagnosisCategories';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  BodySide _currentSide = BodySide.front;
  String? _selectedPartKey;

  @override
  void initState() {
    super.initState();
    _selectedPartKey = context.read<DiagnosisCubit>().state.selectedBodyPartKey;
  }

  void _selectPart(BodyPartDescriptor part) {
    setState(() {
      _selectedPartKey = part.id;
    });

    context.read<DiagnosisCubit>().selectBodyPart(
      partKey: part.id,
      partLabel: part.backendValue,
    );
  }

  void _openSymptomsStep() {
    final BodyPartDescriptor? selected = findBodyPartById(_selectedPartKey);
    if (selected == null) {
      messages(
        context,
        'select_body_part_first'.tr(context),
        AppColors.orangeColor,
      );
      return;
    }

    context.read<DiagnosisCubit>().fetchSymptomsForSelectedPart();
    Navigator.of(context).pushNamed(QuestionScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final BodyPartDescriptor? selected = findBodyPartById(_selectedPartKey);
    final List<BodyPartDescriptor> visibleParts = bodyPartCatalog
        .where((part) => part.side == _currentSide)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'diagnose_category'.tr(context)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: CategoryHeroCard(selectedPart: selected),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverToBoxAdapter(
                      child: CategorySideToggle(
                        currentSide: _currentSide,
                        onSideChanged: (side) {
                          setState(() {
                            _currentSide = side;
                          });
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    CategoryBodyPartsGrid(
                      parts: visibleParts,
                      selectedPartKey: _selectedPartKey,
                      onPartTap: _selectPart,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SafeArea(
                top: false,
                child: PrimaryButton(
                  text: 'next'.tr(context),
                  onPressed: _openSymptomsStep,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
