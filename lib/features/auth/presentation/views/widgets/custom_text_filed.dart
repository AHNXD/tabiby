import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/constats.dart';
import '../../../../../core/utils/styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.borderColor,
    required this.text,
    required this.isPassword,
    this.maxLine = 1,
    required this.controller,
    this.validatorFun,
    this.keyboardType,
    this.onChange,
  });
  final String text;
  final bool isPassword;
  final int maxLine;
  final TextEditingController controller;
  final String? Function(String?)? validatorFun;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final void Function(String?)? onChange;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  bool showPassowrd = false;
  FocusNode focusNode = FocusNode();
  Color fillColor = AppColors.authFieldFillColor;
  Color labelTextColor = AppColors.greyColor;
  Color passwordIconColor = AppColors.black87Color;
  Color textColor = AppColors.black87Color;
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          fillColor = AppColors.transparentColor;
          labelTextColor = AppColors.whiteColor;
          passwordIconColor = AppColors.primaryColors;
          textColor = AppColors.whiteColor;
        });
      } else {
        setState(() {
          fillColor = AppColors.authFieldFillColor;
          passwordIconColor = AppColors.black87Color;
          labelTextColor = AppColors.greyColor;
          textColor = AppColors.black87Color;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      padding: EdgeInsets.only(top: 8),
      margin: EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        style: Styles.textStyle16.copyWith(color: textColor),
        onChanged: widget.onChange,
        keyboardType: widget.keyboardType,
        textInputAction: TextInputAction.next,
        validator: widget.validatorFun,
        controller: widget.controller,
        focusNode: focusNode,
        maxLines: widget.maxLine,
        obscureText: widget.isPassword ? !showPassowrd : false,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor == null
                  ? AppColors.authFieldBorderColor
                  : widget.borderColor!,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(color: labelTextColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.borderColor == null
                  ? AppColors.authFieldBorderColor
                  : widget.borderColor!,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          labelText: widget.text,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    showPassowrd ? Icons.visibility : Icons.visibility_off,
                    color: passwordIconColor,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassowrd = !showPassowrd;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide.none,
          ),
          fillColor: fillColor,
          filled: true,
        ),
      ),
    );
  }
}
