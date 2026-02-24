import 'package:flutter/material.dart';

import '../utils/colors.dart';

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      obscureText: !_isPasswordVisible,
      controller: widget.controller,
      cursorColor: Theme.of(context).primaryColor, // Matches your primary theme
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: AppColors.textFieldColor.withOpacity(0.6),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(
          0xFFFAFAFA,
        ), // Matches the CustomTextField background
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18.0, // Matches the breathing room
          horizontal: 24.0,
        ),

        // --- Interactive Borders Matching CustomTextField ---
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),

        // --- Aligned Suffix Icon ---
        suffixIcon: Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ), // Keeps icon from hitting the curved edge
          child: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              // Softened the icon slightly so it doesn't overpower the text
              color: AppColors.textFieldColor.withOpacity(0.8),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
