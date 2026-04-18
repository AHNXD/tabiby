// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../../core/utils/constats.dart';
import '../../../../../core/utils/colors.dart';

class CustomPhoneField extends StatefulWidget {
  const CustomPhoneField({
    super.key,
    required this.controller,
    required this.text,
  });
  final PhoneController controller;
  final String text;
  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  final FocusNode fNode = FocusNode();
  bool isFill = true;
  Color fillColor = AppColors.authFieldFillColor;
  Color textColor = AppColors.black87Color;
  Color labelTextColor = AppColors.greyColor;
  @override
  void initState() {
    fNode.addListener(() {
      if (fNode.hasFocus) {
        setState(() {
          fillColor = AppColors.transparentColor;
          labelTextColor = AppColors.whiteColor;

          textColor = AppColors.whiteColor;
        });
      } else {
        setState(() {
          fillColor = AppColors.authFieldFillColor;

          labelTextColor = AppColors.greyColor;
          textColor = AppColors.black87Color;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        padding: EdgeInsets.only(top: 8),
        margin: EdgeInsets.symmetric(vertical: 16),
        child: PhoneFormField(
          controller: widget.controller,
          focusNode: fNode,
          countrySelectorNavigator: CountrySelectorNavigator.dialog(),
          countryButtonStyle: CountryButtonStyle(
            showDialCode: true,
            showIsoCode: true,
            showFlag: false,
            textStyle: TextStyle(color: labelTextColor),
          ),
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.authFieldBorderColor),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            labelStyle: TextStyle(color: labelTextColor),
            hintStyle: const TextStyle(color: AppColors.greyColor),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.authFieldBorderColor),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            filled: true,
            fillColor: fillColor,
            labelText: widget.text,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide.none,
            ),
          ),
          validator: PhoneValidator.compose([
            PhoneValidator.required(context, errorText: "رقم الهاتف مطلوب"),
            PhoneValidator.validMobile(context, errorText: "رقم هاتف غير صالح"),
          ]),
          // onChanged: (phoneNumber) => log(
          //     "+${widget.controller.value.countryCode}${widget.controller.value.nsn}"),
        ),
      ),
    );
  }
}
