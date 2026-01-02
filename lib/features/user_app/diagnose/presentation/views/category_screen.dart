import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/question_screen.dart';
import '../../../../../core/widgets/no_data.dart';
import '../view_models/diagnosis_cubit.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/DiagnosisCategories';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<DiagnosisCubit>().state.categories.isEmpty) {
        context.read<DiagnosisCubit>().fetchCategories();
      }
    });
  }

  void _onCategorySelected(int categoryId) {
    context.read<DiagnosisCubit>().selectCategory(categoryId);
    Navigator.of(context).pushNamed(QuestionScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppbar(
        title: 'diagnose_category'.tr(context),
        showBackButton: false,
      ),
      body: BlocBuilder<DiagnosisCubit, DiagnosisState>(
        builder: (context, state) {
          switch (state.categoryState) {
            case ViewState.loading:
              return const LoadingView();
            case ViewState.error:
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMessage.tr(context),
                onRetry: () => context.read<DiagnosisCubit>().fetchCategories(),
              );
            case ViewState.success:
              if (state.categories.isEmpty) {
                return NoDataWidget(
                  title: "no_data_title".tr(context),
                  subtitle: "no_data_subtitle".tr(context),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio:
                      1.0, // Square shape looks modern for categories
                ),
                itemCount: state.categories.length,
                itemBuilder: (ctx, index) {
                  final category = state.categories[index];
                  return _buildCategoryCard(
                    context,
                    name: category.name,
                    onTap: () => _onCategorySelected(category.id),
                  );
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primaryColors.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Bubble
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForCategory(name),
                    size: 32.0,
                    color: AppColors.primaryColors,
                  ),
                ),

                const SizedBox(height: 16),

                // Text
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String categoryName) {
    // You can expand this list to match more categories from your API
    switch (categoryName.toLowerCase()) {
      case 'head & face':
      case 'head':
        return Icons.face_retouching_natural_rounded;
      case 'skin':
        return Icons.spa_rounded;
      case 'abdomen':
      case 'stomach':
        return Icons.accessibility_new_rounded;
      case 'general':
        return Icons.health_and_safety_rounded;
      case 'chest':
        return Icons.monitor_heart_rounded;
      case 'leg':
      case 'limbs':
        return Icons.directions_walk_rounded;
      default:
        return Icons.medical_services_rounded;
    }
  }
}
