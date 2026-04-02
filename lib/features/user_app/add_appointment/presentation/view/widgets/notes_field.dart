import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class NotesField extends StatelessWidget {
  const NotesField({super.key, required this.noteController});
  final TextEditingController noteController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 3,
      maxLines: 5,
      controller: noteController,
      decoration: InputDecoration(
        hintText: 'hint_for_center_or_doctor'.tr(context),
        hintStyle: TextStyle(color: Colors.grey.shade500, height: 1.4),
        filled: true,
        fillColor: const Color(0xFFF8FBF9),
        contentPadding: const EdgeInsets.all(18),
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 16,
            top: 16,
            end: 12,
          ),
          child: Icon(
            Icons.edit_note_rounded,
            color: AppColors.primaryColors.withValues(alpha: 0.8),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFE1E9E4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFE1E9E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
