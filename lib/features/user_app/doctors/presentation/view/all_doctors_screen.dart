import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/no_data.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/buttom_loader.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../center_details/data/models/centers_model.dart';
import '../../../centers/data/models/centers_query_params.dart';
import '../../../centers/data/repos/centers_repo.dart';
import '../../data/models/doctors_query_params.dart';
import '../../data/repos/doctors_repo.dart';
import '../../../specialties/data/models/specialties_model.dart';
import '../../../specialties/data/repos/user_repo.dart';
import '../view_model/doctor_cubit.dart';
import 'widgets/doctor_card.dart';

class AllDoctorsScreen extends StatefulWidget {
  static const String routeName = "/doctors";

  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final DoctorsCubit _doctorsCubit;

  bool _didLoadInitialData = false;
  int? centerID;
  int? specialtyID;

  @override
  void initState() {
    super.initState();
    _doctorsCubit = DoctorsCubit(getit.get<DoctorsRepo>());
    _searchController.addListener(_handleSearchTextChanged);

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_doctorsCubit.isRefreshing) {
        _doctorsCubit.getDoctors(centerID, specialtyID, loadMore: true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didLoadInitialData) {
      return;
    }

    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args = arguments is Map<String, dynamic>
        ? arguments
        : <String, dynamic>{};

    centerID = args['centerID'] as int?;
    specialtyID = args['specialtyID'] as int?;
    _didLoadInitialData = true;

    _doctorsCubit.getDoctors(centerID, specialtyID);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchTextChanged)
      ..dispose();
    _controller.dispose();
    _doctorsCubit.close();
    super.dispose();
  }

  void _handleSearchTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submitSearch() async {
    FocusScope.of(context).unfocus();
    await _doctorsCubit.getDoctors(
      centerID,
      specialtyID,
      queryParams: _doctorsCubit.currentQuery.copyWith(
        search: _searchController.text,
      ),
    );
  }

  Future<void> _clearSearch() async {
    if (_searchController.text.isEmpty &&
        !_doctorsCubit.currentQuery.hasActiveSearch) {
      return;
    }

    _searchController.clear();
    FocusScope.of(context).unfocus();

    await _doctorsCubit.getDoctors(
      centerID,
      specialtyID,
      queryParams: _doctorsCubit.currentQuery.copyWith(search: null),
    );
  }

  Future<void> _openFiltersSheet() async {
    final DoctorsQueryParams? updatedFilters =
        await showModalBottomSheet<DoctorsQueryParams>(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.transparentColor,
          builder: (BuildContext context) {
            return _DoctorsFiltersSheet(
              initialQuery: _doctorsCubit.currentQuery,
              showSpecialtyFilter: specialtyID == null,
              showCenterFilter: centerID == null,
            );
          },
        );

    if (!mounted || updatedFilters == null) {
      return;
    }

    await _doctorsCubit.getDoctors(
      centerID,
      specialtyID,
      queryParams: updatedFilters.copyWith(search: _searchController.text),
    );
  }

  Future<void> _clearFilters() async {
    await _doctorsCubit.getDoctors(
      centerID,
      specialtyID,
      queryParams: _doctorsCubit.currentQuery.clearFilters(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorsCubit>.value(
      value: _doctorsCubit,
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: CustomAppbar(title: "all_popular_doctors".tr(context)),
        body: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            final DoctorsQueryParams currentQuery = _doctorsCubit.currentQuery;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: _DoctorsSearchCard(
                    controller: _searchController,
                    activeFilterCount: currentQuery.activeFilterCount,
                    onSearch: () {
                      _submitSearch();
                    },
                    onClearSearch: () {
                      _clearSearch();
                    },
                    onOpenFilters: () {
                      _openFiltersSheet();
                    },
                  ),
                ),
                Expanded(
                  child: _buildContent(
                    context: context,
                    state: state,
                    currentQuery: currentQuery,
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
    required DoctorsState state,
    required DoctorsQueryParams currentQuery,
  }) {
    if (state is DoctorsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColors),
      );
    }

    if (state is DoctorsError) {
      return CustomErrorWidget(
        textColor: AppColors.textButtonColors,
        errorMessage: state.errorMsg,
        onRetry: () {
          _doctorsCubit.getDoctors(centerID, specialtyID);
        },
      );
    }

    if (state is! DoctorsSuccess) {
      return const SizedBox.shrink();
    }

    Future<void> onRefresh() async {
      await _doctorsCubit.refreshDoctors(centerID, specialtyID);
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
              child: _DoctorsOverviewCard(count: state.totalCount),
            ),
          ),
          if (currentQuery.hasActiveFilters)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: _AppliedDoctorFilters(
                  query: currentQuery,
                  onClearFilters: () {
                    _clearFilters();
                  },
                ),
              ),
            ),
          if (state.doctors.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _DoctorsEmptyState(
                hasActiveQuery:
                    currentQuery.hasActiveSearch ||
                    currentQuery.hasActiveFilters,
                onClearFilters: currentQuery.hasActiveFilters
                    ? () {
                        _clearFilters();
                      }
                    : null,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return DoctorCard(doctor: state.doctors[index]);
                }, childCount: state.doctors.length),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
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

class _DoctorsSearchCard extends StatelessWidget {
  const _DoctorsSearchCard({
    required this.controller,
    required this.activeFilterCount,
    required this.onSearch,
    required this.onClearSearch,
    required this.onOpenFilters,
  });

  final TextEditingController controller;
  final int activeFilterCount;
  final VoidCallback onSearch;
  final VoidCallback onClearSearch;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    final bool hasSearchText = controller.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                hintText: 'doctor_search_hint'.tr(context),
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
          ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: AppColors.primaryColors.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onOpenFilters,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.tune_rounded,
                      color: AppColors.primaryColors,
                    ),
                  ),
                ),
              ),
              if (activeFilterCount > 0)
                Positioned(
                  top: -6,
                  right: -4,
                  child: Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.errorAccentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$activeFilterCount',
                      style: const TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppliedDoctorFilters extends StatelessWidget {
  const _AppliedDoctorFilters({
    required this.query,
    required this.onClearFilters,
  });

  final DoctorsQueryParams query;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.softBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'doctor_filters_title'.tr(context),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.titleColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClearFilters,
                child: Text('clear_filters'.tr(context)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (query.selectedSpecialtyId != null)
                _DoctorFilterChip(
                  icon: Icons.medical_services_outlined,
                  label:
                      '${'specialty'.tr(context)}: ${query.normalizedSelectedSpecialtyName ?? query.selectedSpecialtyId}',
                ),
              if (query.selectedCenterId != null)
                _DoctorFilterChip(
                  icon: Icons.local_hospital_outlined,
                  label:
                      '${'center'.tr(context)}: ${query.normalizedSelectedCenterName ?? query.selectedCenterId}',
                ),
              if (query.normalizedCenterName != null)
                _DoctorFilterChip(
                  icon: Icons.apartment_rounded,
                  label:
                      '${'center_name'.tr(context)}: ${query.normalizedCenterName!}',
                ),
              if (query.experienceYears != null)
                _DoctorFilterChip(
                  icon: Icons.timeline_rounded,
                  label:
                      '${'years_of_experience'.tr(context)}: ${query.experienceYears} ${'years'.tr(context)}',
                ),
              if (query.experienceYears == null &&
                  (query.minExperience != null || query.maxExperience != null))
                _DoctorFilterChip(
                  icon: Icons.stacked_line_chart_rounded,
                  label: _buildRangeLabel(context, query),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildRangeLabel(BuildContext context, DoctorsQueryParams query) {
    if (query.minExperience != null && query.maxExperience != null) {
      return '${'experience_range'.tr(context)}: ${query.minExperience}-${query.maxExperience} ${'years'.tr(context)}';
    }

    if (query.minExperience != null) {
      return '${'minimum_experience'.tr(context)}: ${query.minExperience} ${'years'.tr(context)}';
    }

    return '${'maximum_experience'.tr(context)}: ${query.maxExperience} ${'years'.tr(context)}';
  }
}

class _DoctorFilterChip extends StatelessWidget {
  const _DoctorFilterChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColors.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
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

class _DoctorsEmptyState extends StatelessWidget {
  const _DoctorsEmptyState({required this.hasActiveQuery, this.onClearFilters});

  final bool hasActiveQuery;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NoDataWidget(
              title: hasActiveQuery
                  ? 'no_matching_doctors_title'.tr(context)
                  : 'no_data_title'.tr(context),
              subtitle: hasActiveQuery
                  ? 'no_matching_doctors_subtitle'.tr(context)
                  : 'no_data_subtitle'.tr(context),
            ),
            if (onClearFilters != null) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: onClearFilters,
                child: Text('clear_filters'.tr(context)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _DoctorExperienceFilterMode { exact, range }

enum _DoctorCenterFilterMode { select, name }

class _DoctorsFiltersSheet extends StatefulWidget {
  const _DoctorsFiltersSheet({
    required this.initialQuery,
    required this.showSpecialtyFilter,
    required this.showCenterFilter,
  });

  final DoctorsQueryParams initialQuery;
  final bool showSpecialtyFilter;
  final bool showCenterFilter;

  @override
  State<_DoctorsFiltersSheet> createState() => _DoctorsFiltersSheetState();
}

class _DoctorsFiltersSheetState extends State<_DoctorsFiltersSheet> {
  late final TextEditingController _centerNameController;
  late final TextEditingController _exactExperienceController;
  late final TextEditingController _minExperienceController;
  late final TextEditingController _maxExperienceController;
  late _DoctorExperienceFilterMode _selectedMode;
  late _DoctorCenterFilterMode _centerFilterMode;
  int? _selectedSpecialtyId;
  int? _selectedCenterId;
  List<SpecializationModel> _specialties = const <SpecializationModel>[];
  List<Centers> _centers = const <Centers>[];
  bool _isLoadingFilterOptions = false;
  String? _filterOptionsError;

  @override
  void initState() {
    super.initState();
    _selectedSpecialtyId = widget.initialQuery.selectedSpecialtyId;
    _selectedCenterId = widget.initialQuery.selectedCenterId;
    _centerFilterMode =
        widget.initialQuery.selectedCenterId != null ||
            widget.initialQuery.normalizedCenterName == null
        ? _DoctorCenterFilterMode.select
        : _DoctorCenterFilterMode.name;
    _centerNameController = TextEditingController(
      text: widget.initialQuery.centerName ?? '',
    );
    _exactExperienceController = TextEditingController(
      text: widget.initialQuery.experienceYears?.toString() ?? '',
    );
    _minExperienceController = TextEditingController(
      text: widget.initialQuery.minExperience?.toString() ?? '',
    );
    _maxExperienceController = TextEditingController(
      text: widget.initialQuery.maxExperience?.toString() ?? '',
    );
    _selectedMode =
        widget.initialQuery.experienceYears != null ||
            (widget.initialQuery.minExperience == null &&
                widget.initialQuery.maxExperience == null)
        ? _DoctorExperienceFilterMode.exact
        : _DoctorExperienceFilterMode.range;
    _loadFilterOptions();
  }

  @override
  void dispose() {
    _centerNameController.dispose();
    _exactExperienceController.dispose();
    _minExperienceController.dispose();
    _maxExperienceController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    _centerNameController.clear();
    _exactExperienceController.clear();
    _minExperienceController.clear();
    _maxExperienceController.clear();
    setState(() {
      _selectedMode = _DoctorExperienceFilterMode.exact;
      _centerFilterMode = _DoctorCenterFilterMode.select;
      _selectedSpecialtyId = null;
      _selectedCenterId = null;
    });
  }

  Future<void> _loadFilterOptions() async {
    if (!widget.showSpecialtyFilter && !widget.showCenterFilter) {
      return;
    }

    setState(() {
      _isLoadingFilterOptions = true;
      _filterOptionsError = null;
    });

    try {
      final List<SpecializationModel> specialties = widget.showSpecialtyFilter
          ? await _fetchSpecialties()
          : const <SpecializationModel>[];
      final List<Centers> centers = widget.showCenterFilter
          ? await _fetchCenters()
          : const <Centers>[];

      if (!mounted) {
        return;
      }

      setState(() {
        _specialties = specialties;
        _centers = centers;
        _isLoadingFilterOptions = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _filterOptionsError = error.toString();
        _isLoadingFilterOptions = false;
      });
    }
  }

  Future<List<SpecializationModel>> _fetchSpecialties() async {
    final result = await getit.get<SpecialtiesRepo>().getSpecialties();

    return result.fold((failure) => throw failure.message, (specialties) {
      return (specialties.specializations ?? <SpecializationModel>[])
          .where((specialty) => specialty.id != null)
          .toList();
    });
  }

  Future<List<Centers>> _fetchCenters() async {
    final CentersRepo repo = getit.get<CentersRepo>();
    final List<Centers> allCenters = <Centers>[];
    int page = 1;

    while (true) {
      final result = await repo.getCenters(page, CentersQueryParams.empty);
      final CentersModel data = result.fold(
        (failure) => throw failure.message,
        (centers) => centers,
      );

      allCenters.addAll(
        (data.centers ?? <Centers>[]).where((center) => center.id != null),
      );

      final pageInfo = data.pageInfo;
      if (pageInfo == null || pageInfo.currentPage >= pageInfo.lastPage) {
        break;
      }

      page++;
    }

    return allCenters;
  }

  void _applyFilters() {
    final int? exactExperience = _parseInt(_exactExperienceController.text);
    final int? minExperience = _parseInt(_minExperienceController.text);
    final int? maxExperience = _parseInt(_maxExperienceController.text);

    if (_hasInvalidNumber(_exactExperienceController.text, exactExperience) ||
        _hasInvalidNumber(_minExperienceController.text, minExperience) ||
        _hasInvalidNumber(_maxExperienceController.text, maxExperience)) {
      messages(context, 'enter_valid_number'.tr(context), AppColors.errorColor);
      return;
    }

    if (_selectedMode == _DoctorExperienceFilterMode.range &&
        minExperience != null &&
        maxExperience != null &&
        minExperience > maxExperience) {
      messages(
        context,
        'experience_range_invalid'.tr(context),
        AppColors.errorColor,
      );
      return;
    }

    Navigator.pop(
      context,
      widget.initialQuery.copyWith(
        centerName:
            widget.showCenterFilter &&
                _centerFilterMode == _DoctorCenterFilterMode.name
            ? _centerNameController.text
            : null,
        selectedCenterId:
            widget.showCenterFilter &&
                _centerFilterMode == _DoctorCenterFilterMode.select
            ? _selectedCenterId
            : null,
        selectedCenterName:
            widget.showCenterFilter &&
                _centerFilterMode == _DoctorCenterFilterMode.select
            ? _centerNameFor(_selectedCenterId)
            : null,
        selectedSpecialtyId: widget.showSpecialtyFilter
            ? _selectedSpecialtyId
            : null,
        selectedSpecialtyName: widget.showSpecialtyFilter
            ? _specialtyNameFor(_selectedSpecialtyId)
            : null,
        experienceYears: _selectedMode == _DoctorExperienceFilterMode.exact
            ? exactExperience
            : null,
        minExperience: _selectedMode == _DoctorExperienceFilterMode.range
            ? minExperience
            : null,
        maxExperience: _selectedMode == _DoctorExperienceFilterMode.range
            ? maxExperience
            : null,
      ),
    );
  }

  String? _centerNameFor(int? centerId) {
    if (centerId == null) {
      return null;
    }

    for (final Centers center in _centers) {
      if (center.id == centerId) {
        return center.name;
      }
    }

    return null;
  }

  String? _specialtyNameFor(int? specialtyId) {
    if (specialtyId == null) {
      return null;
    }

    for (final SpecializationModel specialty in _specialties) {
      if (specialty.id == specialtyId) {
        return specialty.name;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Material(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(32),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'doctor_filters_title'.tr(context),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'doctor_filters_subtitle'.tr(context),
                style: const TextStyle(
                  color: AppColors.mutedTextColor,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              if (_isLoadingFilterOptions) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 18),
              ] else if (_filterOptionsError != null) ...[
                _FilterOptionsErrorCard(
                  message: _filterOptionsError!,
                  onRetry: _loadFilterOptions,
                ),
                const SizedBox(height: 18),
              ] else ...[
                if (widget.showSpecialtyFilter) ...[
                  _FilterFieldLabel(label: 'specialty'.tr(context)),
                  const SizedBox(height: 10),
                  _BottomSheetDropdownField(
                    value: _dropdownValue(
                      _selectedSpecialtyId,
                      _specialties.map((specialty) => specialty.id).toList(),
                    ),
                    hintText: 'all_specialties'.tr(context),
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text('all_specialties'.tr(context)),
                      ),
                      ..._specialties.map(
                        (specialty) => DropdownMenuItem<int>(
                          value: specialty.id!,
                          child: Text(specialty.name ?? '--'),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecialtyId = value == 0 ? null : value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                ],
                if (widget.showCenterFilter) ...[
                  _FilterFieldLabel(label: 'center'.tr(context)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ChoiceChip(
                        label: Text('select_center_from_list'.tr(context)),
                        selected:
                            _centerFilterMode == _DoctorCenterFilterMode.select,
                        onSelected: (_) {
                          setState(() {
                            _centerFilterMode = _DoctorCenterFilterMode.select;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: Text('write_center_name'.tr(context)),
                        selected:
                            _centerFilterMode == _DoctorCenterFilterMode.name,
                        onSelected: (_) {
                          setState(() {
                            _centerFilterMode = _DoctorCenterFilterMode.name;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_centerFilterMode == _DoctorCenterFilterMode.select)
                    _BottomSheetDropdownField(
                      value: _dropdownValue(
                        _selectedCenterId,
                        _centers.map((center) => center.id).toList(),
                      ),
                      hintText: 'all_centers'.tr(context),
                      items: <DropdownMenuItem<int>>[
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Text('all_centers'.tr(context)),
                        ),
                        ..._centers.map(
                          (center) => DropdownMenuItem<int>(
                            value: center.id!,
                            child: Text(center.name ?? '--'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCenterId = value == 0 ? null : value;
                        });
                      },
                    )
                  else
                    _BottomSheetTextField(
                      controller: _centerNameController,
                      hintText: 'doctor_center_name_hint'.tr(context),
                    ),
                  const SizedBox(height: 18),
                ],
              ],
              _FilterFieldLabel(label: 'years_of_experience'.tr(context)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ChoiceChip(
                    label: Text('exact_experience'.tr(context)),
                    selected:
                        _selectedMode == _DoctorExperienceFilterMode.exact,
                    onSelected: (_) {
                      setState(() {
                        _selectedMode = _DoctorExperienceFilterMode.exact;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text('experience_range'.tr(context)),
                    selected:
                        _selectedMode == _DoctorExperienceFilterMode.range,
                    onSelected: (_) {
                      setState(() {
                        _selectedMode = _DoctorExperienceFilterMode.range;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (_selectedMode == _DoctorExperienceFilterMode.exact)
                _BottomSheetTextField(
                  controller: _exactExperienceController,
                  hintText: 'exact_experience_hint'.tr(context),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _BottomSheetTextField(
                        controller: _minExperienceController,
                        hintText: 'minimum_experience'.tr(context),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BottomSheetTextField(
                        controller: _maxExperienceController,
                        hintText: 'maximum_experience'.tr(context),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text('reset_filters'.tr(context)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColors,
                        foregroundColor: AppColors.backgroundColor,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text('apply_filters'.tr(context)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _dropdownValue(int? selectedId, List<int?> ids) {
    if (selectedId == null) {
      return 0;
    }

    return ids.contains(selectedId) ? selectedId : 0;
  }

  bool _hasInvalidNumber(String rawValue, int? parsedValue) {
    return rawValue.trim().isNotEmpty && parsedValue == null;
  }

  int? _parseInt(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    return int.tryParse(trimmed);
  }
}

class _BottomSheetTextField extends StatelessWidget {
  const _BottomSheetTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.appBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _BottomSheetDropdownField extends StatelessWidget {
  const _BottomSheetDropdownField({
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  final int value;
  final String hintText;
  final List<DropdownMenuItem<int>> items;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      key: ValueKey<String>('$hintText-$value-${items.length}'),
      initialValue: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.appBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _FilterOptionsErrorCard extends StatelessWidget {
  const _FilterOptionsErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.errorColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message.tr(context),
              style: const TextStyle(
                color: AppColors.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text('try_again'.tr(context))),
        ],
      ),
    );
  }
}

class _FilterFieldLabel extends StatelessWidget {
  const _FilterFieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: AppColors.titleColor,
      ),
    );
  }
}

class _DoctorsOverviewCard extends StatelessWidget {
  const _DoctorsOverviewCard({required this.count});

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
            color: AppColors.shadowColor.withValues(alpha: 0.04),
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
                        Icons.medical_services_outlined,
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
                        color: AppColors.backgroundColor,
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
                  'all_popular_doctors'.tr(context),
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'doctor_results_subtitle'.tr(context),
                  style: const TextStyle(
                    color: AppColors.subduedTextColor,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _OverviewChip(
                      icon: Icons.star_outline_rounded,
                      label: 'rate'.tr(context),
                    ),
                    _OverviewChip(
                      icon: Icons.verified_user_outlined,
                      label: 'available'.tr(context),
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

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.softBorderColor),
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
