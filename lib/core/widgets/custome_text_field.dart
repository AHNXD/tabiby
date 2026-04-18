import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.obscureText = false,
    this.textInputAction,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextInputType effectiveKeyboardType =
        maxLines > 1 &&
            textInputAction == TextInputAction.newline &&
            keyboardType == TextInputType.text
        ? TextInputType.multiline
        : keyboardType;

    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: effectiveKeyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onTap: onTap,
      cursorColor: Theme.of(
        context,
      ).primaryColor, // Matches your app's main color
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        // Softened the hint text so the actual input stands out more
        hintStyle: TextStyle(
          color: AppColors.textFieldColor.withValues(alpha: 0.6),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(
          0xFFFAFAFA,
        ), // A slightly lighter, crisper white/grey
        contentPadding: const EdgeInsets.symmetric(
          vertical:
              18.0, // Slightly taller for a more breathable, pill-like feel
          horizontal: 24.0,
        ),

        // --- Added Interactive Borders ---

        // 1. Default resting state (Subtle crisp border)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: AppColors.grey300Color, width: 1.0),
        ),

        // 2. Focused state (Pops out with your theme's primary color)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),

        // 3. Error state (Turns red if validation fails)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: AppColors.errorAccentColor,
            width: 1.5,
          ),
        ),

        // 4. Focused Error state (Red and bold when typing an invalid field)
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: AppColors.errorAccentColor,
            width: 2.0,
          ),
        ),

        // --- Icons ---
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(prefixIcon, color: AppColors.textFieldColor),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(suffixIcon, color: AppColors.textFieldColor),
              )
            : null,
      ),
    );
  }
}
