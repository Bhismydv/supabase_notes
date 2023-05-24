import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/app_colors.dart';

class AppRoundedTextField extends StatelessWidget {

  final String? initialValue;
  final String? hintText;
  final Function(String) onChanged;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool? obsureText, readOnly;
  final Function()? onTap;
  final TextEditingController? controller;
  final List<TextInputFormatter> formatters;
  final int? maxLength, maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final IconData? prefixIconData;
  final double? radius, width;
  final Color? borderColor;
  final Function()? onTapShowPassVisibility;

  AppRoundedTextField(
      {
        this.borderColor,
        required this.onChanged,
        this.hintText,
        this.initialValue,
        this.textInputType = TextInputType.text,
        this.validator,
        this.onTap,
        this.width,
        this.controller,
        this.maxLines,
        this.onTapShowPassVisibility,
        this.contentPadding,
        this.prefixIconData,
        this.formatters = const [],
        this.obsureText = false,
        this.maxLength,
        this.radius,
        this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: textInputType,
        validator: validator,
        controller: controller,
        obscureText: obsureText ?? false,
        readOnly: readOnly ?? false,
        onTap: onTap,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        inputFormatters: formatters,
        //textCapitalization: TextCapitalization.characters,
        cursorColor: borderColor ?? AppColors.accentColor,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:  BorderSide(
                  color: borderColor ?? AppColors.accentColor,
                  width: 1),
            ),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius?? 10.0),
              borderSide:  BorderSide(color: AppColors.bodyTextColor,width: 1)
            ),
            prefixIcon: prefixIconData != null ? Icon(prefixIconData) : null,
            filled: true,
            /*label: Text(
              label,
            )*/
            suffixIcon: onTapShowPassVisibility != null
                ? GestureDetector(
                onTap: onTapShowPassVisibility,
                child: Icon(obsureText! ? Icons.visibility_off : Icons.visibility, color: borderColor ?? AppColors.primaryColor,))
                : null,
            alignLabelWithHint: true,
            contentPadding: contentPadding,
            hintStyle: TextStyle(color: Colors.grey[400]),
            hintText: hintText,
            fillColor: AppColors.backgroundColor),
      ),
    );
  }
}