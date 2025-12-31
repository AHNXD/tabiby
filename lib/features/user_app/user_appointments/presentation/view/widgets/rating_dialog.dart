import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';

import '../../../data/models/rating_status_model.dart';
import '../../view-model/rating/rating_cubit.dart';

class AppointmentRatingDialog extends StatefulWidget {
  final int appointmentId;

  const AppointmentRatingDialog({super.key, required this.appointmentId});

  @override
  State<AppointmentRatingDialog> createState() =>
      _AppointmentRatingDialogState();
}

class _AppointmentRatingDialogState extends State<AppointmentRatingDialog> {
  int _currentRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RatingCubit>().checkAppointment(widget.appointmentId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using a transparent background for the dialog itself to let our rounded shape shine
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<RatingCubit, RatingState>(
          listener: (context, state) {
            if (state is RatingSuccess) {
              Navigator.pop(context);
              messages(
                context,
                'rating_submitted_successfully'.tr(context),
                Colors.green,
              );
            } else if (state is RatingError) {
              Navigator.pop(context);
              messages(context, state.errorMsg, Colors.red);
            }
          },
          builder: (context, state) {
            // 1. Loading Check
            if (state is RatingCheckLoading) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    "checking".tr(context),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              );
            }

            // 2. Error Checking
            if (state is RatingCheckError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red.shade400,
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMsg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('close'.tr(context)),
                  ),
                ],
              );
            }

            // 3. Data Loaded (Show Form or Result)
            if (state is RatingCheckLoaded) {
              return _buildRatingContent(context, state.ratingStatus);
            }

            // 4. Submission Loading
            if (state is RatingLoading) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    "submitting".tr(context),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildRatingContent(BuildContext context, RatingStatus status) {
    bool hasRated = status.hasRated ?? false;
    bool canRate = status.canRate ?? false;

    // A. View Existing Rating
    if (hasRated && status.rating != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "your_feedback".tr(context),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColors,
            ),
          ),
          const SizedBox(height: 24),
          // Use the prettier static star display
          _StarDisplay(value: status.rating!.rating ?? 0, size: 44),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              status.rating!.comment != null &&
                      status.rating!.comment!.isNotEmpty
                  ? status.rating!.comment!
                  : "no_comment".tr(context),
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 15,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'close'.tr(context),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    }

    // B. Add New Rating
    if (canRate) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "rate_experience".tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColors,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "tap_stars_to_rate".tr(
              context,
            ), // Add this key to your localization
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // NEW Beautiful Star Selector
          _AnimatedStarRatingSelector(
            rating: _currentRating,
            onRatingChanged: (rating) {
              setState(() => _currentRating = rating);
            },
          ),

          // Helper text based on rating
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _getRatingLabel(_currentRating, context),
                key: ValueKey<int>(_currentRating),
                style: TextStyle(
                  color: _currentRating > 0
                      ? AppColors.primaryColors
                      : Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // NEW Beautiful Comment Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "write_comment_here".tr(context),
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none, // Remove default harsh border
                contentPadding: const EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primaryColors.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _currentRating > 0
                  ? () {
                      context.read<RatingCubit>().addRate(
                        widget.appointmentId,
                        _currentRating,
                        _commentController.text,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColors,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: _currentRating > 0 ? 4 : 0,
                shadowColor: AppColors.primaryColors.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'submit'.tr(context),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // C. Cannot Rate (Edge case)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.block_rounded, color: Colors.grey.shade400, size: 50),
        const SizedBox(height: 16),
        Text(
          "cannot_rate_appointment".tr(context),
          style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
        ),
        const SizedBox(height: 24),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
          onPressed: () => Navigator.pop(context),
          child: Text(
            'close'.tr(context),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  String _getRatingLabel(int rating, BuildContext context) {
    switch (rating) {
      case 1:
        return "terrible".tr(context);
      case 2:
        return "bad".tr(context);
      case 3:
        return "average".tr(context);
      case 4:
        return "good".tr(context);
      case 5:
        return "excellent".tr(context);
      default:
        return ""; // Or some instruction like "Tap stars to rate"
    }
  }
}

// --- Helper Widgets for Stars ---

// 1. NEW Animated Interactive Star Selector
class _AnimatedStarRatingSelector extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;
  // Warmer gold color
  final Color starColor = AppColors.primaryColors;

  const _AnimatedStarRatingSelector({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isSelected = index < rating;
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                // Add a bouncy scale transition
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.elasticOut,
                  ),
                  child: child,
                );
              },
              child: Icon(
                // Use rounded icons for a softer feel
                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                key: ValueKey<bool>(
                  isSelected,
                ), // Important for AnimatedSwitcher
                color: isSelected ? starColor : Colors.grey.shade300,
                size: 44,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// 2. Static Star Display (Updated with rounded icons)
class _StarDisplay extends StatelessWidget {
  final int value;
  final double size;
  final Color starColor = AppColors.primaryColors;

  const _StarDisplay({required this.value, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star_rounded : Icons.star_outline_rounded,
          color: index < value ? starColor : Colors.grey.shade300,
          size: size,
        );
      }),
    );
  }
}
