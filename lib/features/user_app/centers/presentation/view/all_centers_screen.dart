import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/no_data.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/buttom_loader.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../center_details/presentation/view/center_details_screen.dart';
import '../../data/repos/centers_repo.dart';
import '../view_model/centers_cubit.dart';
import 'widgets/center_card.dart';

class AllCentersScreen extends StatefulWidget {
  static const String routeName = "/centers";

  const AllCentersScreen({super.key});

  @override
  State<AllCentersScreen> createState() => _AllCentersScreenState();
}

class _AllCentersScreenState extends State<AllCentersScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final CentersCubit _centersCubit;

  @override
  void initState() {
    super.initState();
    _centersCubit = CentersCubit(getit.get<CentersRepo>())..getCenters();
    _searchController.addListener(_handleSearchTextChanged);

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_centersCubit.isRefreshing) {
        _centersCubit.getCenters(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchTextChanged)
      ..dispose();
    _controller.dispose();
    _centersCubit.close();
    super.dispose();
  }

  void _handleSearchTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submitSearch() async {
    FocusScope.of(context).unfocus();
    await _centersCubit.getCenters(
      queryParams: _centersCubit.currentQuery.copyWith(
        search: _searchController.text,
      ),
    );
  }

  Future<void> _clearSearch() async {
    if (_searchController.text.isEmpty &&
        !_centersCubit.currentQuery.hasActiveSearch) {
      return;
    }

    _searchController.clear();
    FocusScope.of(context).unfocus();
    await _centersCubit.getCenters(
      queryParams: _centersCubit.currentQuery.copyWith(search: null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CentersCubit>.value(
      value: _centersCubit,
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: CustomAppbar(title: "all_popular_centers".tr(context)),
        body: BlocBuilder<CentersCubit, CentersState>(
          builder: (context, state) {
            final bool hasActiveSearch =
                _centersCubit.currentQuery.hasActiveSearch;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: _CentersSearchCard(
                    controller: _searchController,
                    onSearch: () {
                      _submitSearch();
                    },
                    onClearSearch: () {
                      _clearSearch();
                    },
                  ),
                ),
                Expanded(
                  child: _buildContent(
                    context: context,
                    state: state,
                    hasActiveSearch: hasActiveSearch,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required CentersState state,
    required bool hasActiveSearch,
  }) {
    if (state is CentersLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColors),
      );
    }

    if (state is CentersError) {
      return CustomErrorWidget(
        textColor: AppColors.blackColor,
        errorMessage: state.errorMsg,
        onRetry: () {
          _centersCubit.getCenters();
        },
      );
    }

    if (state is! CentersSuccess) {
      return const SizedBox.shrink();
    }

    Future<void> onRefresh() async {
      await _centersCubit.refreshCenters();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: _CentersOverviewCard(count: state.totalCount),
            ),
          ),
          if (state.centers.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: NoDataWidget(
                    title: hasActiveSearch
                        ? 'no_matching_centers_title'.tr(context)
                        : 'no_data_title'.tr(context),
                    subtitle: hasActiveSearch
                        ? 'no_matching_centers_subtitle'.tr(context)
                        : 'no_data_subtitle'.tr(context),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final center = state.centers[index];
                  return CenterCard(
                    center: center,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CenterDetailsScreen(centerID: center.id!),
                        ),
                      );
                    },
                  );
                }, childCount: state.centers.length),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
              ),
            ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: BottomLoader(),
              ),
            ),
        ],
      ),
    );
  }
}

class _CentersSearchCard extends StatelessWidget {
  const _CentersSearchCard({
    required this.controller,
    required this.onSearch,
    required this.onClearSearch,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final bool hasSearchText = controller.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: 'center_search_hint'.tr(context),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryColors,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasSearchText)
                IconButton(
                  onPressed: onClearSearch,
                  icon: const Icon(Icons.close_rounded),
                ),
              IconButton(
                onPressed: onSearch,
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
          filled: true,
          fillColor: AppColors.appBackgroundColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _CentersOverviewCard extends StatelessWidget {
  const _CentersOverviewCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: 16,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.local_hospital_outlined,
                        color: AppColors.primaryColors,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primaryColors.withValues(
                            alpha: 0.16,
                          ),
                        ),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: AppColors.primaryColors,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'all_popular_centers'.tr(context),
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'center_results_subtitle'.tr(context),
                  style: TextStyle(color: AppColors.grey700Color, height: 1.45),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _CenterOverviewChip(
                      icon: Icons.location_on_outlined,
                      label: 'center_details'.tr(context),
                    ),
                    _CenterOverviewChip(
                      icon: Icons.apartment_rounded,
                      label: 'all_popular_centers'.tr(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterOverviewChip extends StatelessWidget {
  const _CenterOverviewChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryColors),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
