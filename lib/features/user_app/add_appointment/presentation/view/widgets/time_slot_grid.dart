import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_localizations.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../data/models/times_model.dart';

class TimeSlotGrid extends StatelessWidget {
  final Periods periods;
  final String? selectedSlot;
  final Function(String time, String category) onSelect;

  const TimeSlotGrid({
    super.key,
    required this.periods,
    required this.selectedSlot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (periods.morning?.isNotEmpty ?? false)
          _buildTimeGroup(
            context,
            "morning".tr(context),
            periods.morning!,
            "morning",
          ),

        if (periods.afternoon?.isNotEmpty ?? false)
          _buildTimeGroup(
            context,
            "afternoon".tr(context),
            periods.afternoon!,
            "afternoon",
          ),

        if (periods.evening?.isNotEmpty ?? false)
          _buildTimeGroup(
            context,
            "evening".tr(context),
            periods.evening!,
            "evening",
          ),
      ],
    );
  }

  Widget _buildTimeGroup(
    BuildContext context,
    String label,
    List<TimeSlot> slots,
    String categoryKey,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softSurfaceAltColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.sageBorderSoftColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForCategory(categoryKey),
                    size: 18,
                    color: AppColors.primaryColors,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.forestDeepColor,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(slots.length, (int index) {
                final TimeSlot slot = slots[index];
                final bool isSelected = selectedSlot == slot.time;
                return Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: index == slots.length - 1 ? 0 : 10,
                  ),
                  child: _buildTimeChip(slot.time!, isSelected, categoryKey),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time, bool isSelected, String categoryKey) {
    return InkWell(
      onTap: () => onSelect(time, categoryKey),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              isSelected ? AppColors.primaryColors : AppColors.whiteColor,
              isSelected
                  ? AppColors.forestAccentColor
                  : AppColors.sageSurfaceWhiteColor,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColors
                : AppColors.sageBorderMutedColor,
            width: 1.5,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryColors.withValues(alpha: 0.24)
                  : AppColors.blackColor.withValues(alpha: 0.03),
              blurRadius: isSelected ? 14 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? AppColors.whiteColor : AppColors.black87Color,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String key) {
    switch (key.toLowerCase()) {
      case 'morning':
        return Icons.wb_sunny_outlined;
      case 'afternoon':
        return Icons.wb_twilight_rounded;
      case 'evening':
        return Icons.nights_stay_outlined;
      default:
        return Icons.access_time;
    }
  }
}
