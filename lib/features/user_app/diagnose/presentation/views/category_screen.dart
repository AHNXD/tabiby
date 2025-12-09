import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/error_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/models/loading_view.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/question_screen.dart';
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
    // Fetch categories when this screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if categories are already loaded to avoid unnecessary fetches
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
    // Use theme data for consistent styling
    final theme = Theme.of(context);

    return Scaffold(
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
              return ErrorView(
                message: state.errorMessage.tr(context),
                onRetry: () => context.read<DiagnosisCubit>().fetchCategories(),
              );
            case ViewState.success:
              // Handle the empty state explicitly
              if (state.categories.isEmpty) {
                return Center(
                  child: Text(
                    'no_symptom'.tr(context),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              // Use a GridView for better scannability
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.1, // Adjust for a slightly taller card
                ),
                itemCount: state.categories.length,
                itemBuilder: (ctx, index) {
                  final category = state.categories[index];

                  // Use Card, InkWell, and better styling
                  return Card(
                    clipBehavior: Clip.antiAlias, // Ensures ripple is rounded
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      onTap: () => _onCategorySelected(category.id),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconForCategory(category.name),
                              size: 48.0,
                              color: AppColors.primaryColors,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              category.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            default:
              return Center(child: Text('wait'.tr(context)));
          }
        },
      ),
    );
  }

  // --- Helper Function ---
  // Ideally, this data (the icon) would come from your API/model.
  // This is a temporary placeholder to show the concept.
  IconData _getIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'head & face':
        return Icons.sentiment_very_dissatisfied;
      case 'skin':
        return Icons.healing;
      case 'abdomen':
        return Icons.sick_outlined;
      case 'general':
        return Icons.person_search;
      default:
        return Icons.local_hospital_outlined;
    }
  }
}
