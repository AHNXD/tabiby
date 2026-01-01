import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../../../core/utils/functions.dart';
import '../../view_model/end_appointment_cubit/end_appointment_cubit.dart';
import '../../view_model/end_appointment_cubit/end_appointment_state.dart';

class EndAppointmentDialog extends StatefulWidget {
  final Color primaryColor;
  final int appointmentId;

  const EndAppointmentDialog({
    super.key,
    required this.primaryColor,
    required this.appointmentId,
  });

  @override
  State<EndAppointmentDialog> createState() => _EndAppointmentDialogState();
}

class _EndAppointmentDialogState extends State<EndAppointmentDialog> {
  final TextEditingController notesController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    prescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Transparent Dialog Wrapper
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: BlocListener<EndAppointmentCubit, EndAppointmentState>(
        listener: (context, state) {
          if (state is EndAppointmentSuccess) {
            messages(context, state.message, Colors.green);
            Navigator.of(context).pop(true);
          } else if (state is EndAppointmentFailure) {
            messages(context, state.error, Colors.red);
          }
        },
        // 2. Main Content Container
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'complete_appointment'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: widget.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // -- Notes Section --
                _buildSectionHeader(
                  context,
                  icon: Icons.note_alt_rounded,
                  title: 'notes'.tr(context),
                ),
                const SizedBox(height: 12),
                _buildStyledTextField(
                  context,
                  controller: notesController,
                  hint: 'hint_add_clinical_notes'.tr(context),
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // -- Prescription Section --
                _buildSectionHeader(
                  context,
                  icon: Icons.medication_rounded,
                  title: 'prescription'.tr(context),
                ),
                const SizedBox(height: 12),
                _buildStyledTextField(
                  context,
                  controller: prescriptionController,
                  hint: 'add_prescription'.tr(context),
                  maxLines: 3,
                ),

                const SizedBox(height: 32),

                // -- Action Buttons --
                BlocBuilder<EndAppointmentCubit, EndAppointmentState>(
                  builder: (context, state) {
                    if (state is EndAppointmentLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: widget.primaryColor,
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Optional: Add validation here if needed
                              context
                                  .read<EndAppointmentCubit>()
                                  .endAppointment(
                                    widget.appointmentId,
                                    notesController.text,
                                    prescriptionController.text,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primaryColor,
                              elevation: 4,
                              shadowColor: widget.primaryColor.withOpacity(0.4),
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

                        const SizedBox(height: 12),

                        // Cancel Button
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'cancel'.tr(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper 1: Section Header with Icon ---
  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: widget.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- Helper 2: Styled Text Field ---
  Widget _buildStyledTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          // Subtle border when focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: widget.primaryColor.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
