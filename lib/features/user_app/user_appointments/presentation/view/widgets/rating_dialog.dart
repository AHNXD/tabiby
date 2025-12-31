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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
                  const SizedBox(height: 16),
                  Text("checking".tr(context)),
                ],
              );
            }

            // 2. Error Checking
            if (state is RatingCheckError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Text(state.errorMsg),
                  TextButton(
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
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("submitting".tr(context)),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColors,
            ),
          ),
          const SizedBox(height: 20),
          _StarDisplay(value: status.rating!.rating ?? 0, size: 40),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.rating!.comment ?? "no_comment".tr(context),
              style: const TextStyle(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('close'.tr(context)),
          ),
        ],
      );
    }

    // B. Add New Rating
    if (canRate) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "rate_experience".tr(context),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColors,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Star Selector
          Center(
            child: _StarRatingSelector(
              rating: _currentRating,
              onRatingChanged: (rating) {
                setState(() => _currentRating = rating);
              },
            ),
          ),
          const SizedBox(height: 20),

          // Comment Field
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "write_comment_here".tr(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _currentRating > 0
                  ? () {
                      context.read<RatingCubit>().addRate(
                        widget.appointmentId,
                        _currentRating,
                        _commentController.text,
                      );
                    }
                  : null, // Disable if no stars selected
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColors,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'submit'.tr(context),
                style: const TextStyle(color: Colors.white, fontSize: 16),
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
        const Icon(Icons.block, color: Colors.grey, size: 40),
        const SizedBox(height: 10),
        Text("cannot_rate_appointment".tr(context)),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('close'.tr(context)),
        ),
      ],
    );
  }
}

// --- Helper Widgets for Stars ---

// 1. Interactive Star Selector
class _StarRatingSelector extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  const _StarRatingSelector({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => onRatingChanged(index + 1),
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}

// 2. Static Star Display
class _StarDisplay extends StatelessWidget {
  final int value;
  final double size;
  const _StarDisplay({required this.value, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}
