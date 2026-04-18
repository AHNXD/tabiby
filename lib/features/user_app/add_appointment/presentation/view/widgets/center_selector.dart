import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import '../../../../../../core/utils/app_localizations.dart';
import '../../../data/models/centers_appointment_model.dart';

class CenterSelector extends StatelessWidget {
  final List<Centers> centers;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  const CenterSelector({
    super.key,
    required this.centers,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemCount: centers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final center = centers[index];
          final isSelected = selectedId == center.id;

          return Material(
            color: AppColors.transparentColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                if (center.id != null) {
                  onSelect(center.id!);
                }
              },
              child: Ink(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 272,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        isSelected
                            ? AppColors.primaryColors.withValues(alpha: 0.16)
                            : AppColors.whiteColor,
                        isSelected
                            ? AppColors.sageSurfaceSelectedColor
                            : AppColors.sageSurfacePageColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColors.withValues(alpha: 0.55)
                          : AppColors.sageSurfaceAltColor,
                      width: isSelected ? 1.8 : 1.2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primaryColors.withValues(alpha: 0.16)
                            : AppColors.blackColor.withValues(alpha: 0.04),
                        blurRadius: isSelected ? 18 : 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColors
                                  : AppColors.sageSurfaceSoftColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.local_hospital_outlined,
                              color: isSelected
                                  ? AppColors.whiteColor
                                  : AppColors.primaryColors,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  center.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? AppColors.forestTextColor
                                        : AppColors.black87Color,
                                    fontSize: 16,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 15,
                                      color: AppColors.grey500Color,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        center.address ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.grey600Color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primaryColors
                                  : AppColors.whiteColor,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColors
                                    : AppColors.grey300Color,
                                width: 1.8,
                              ),
                            ),
                            child: Icon(
                              isSelected
                                  ? Icons.check_rounded
                                  : Icons.add_rounded,
                              size: 16,
                              color: isSelected
                                  ? AppColors.whiteColor
                                  : AppColors.grey500Color,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColors
                                  : AppColors.sageSurfaceCardColor,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              "${center.price} ${"sy".tr(context)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.forestTextSoftAltColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 220),
                            opacity: isSelected ? 1 : 0,
                            child: Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: AppColors.primaryColors,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
