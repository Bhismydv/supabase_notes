import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';


class AppRoundedButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final bool iconVisible;
  final double? width;
  final Color? bagColor, txtColor, iconColor;
  final IconData? svgPicture;
  final MainAxisAlignment? mainAxisAlignment;
  const AppRoundedButton(
      {Key? key, required this.label, required this.onPressed,
        this.txtColor, this.width, this.bagColor, this.svgPicture, this.mainAxisAlignment, this.iconColor, this.iconVisible =false, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: bagColor ?? AppColors.accentColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(1,5),
                color: Color(0xFFE0E0E0),
              ),
              BoxShadow(
                blurRadius: 10,
                offset: Offset(5,1),
                color: Color(0xFFE0E0E0),
              ),
              BoxShadow(
                blurRadius: 10,
                offset: Offset(2,1),
                color: Color(0xFFE0E0E0),
              )
            ]

          ),
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: mainAxisAlignment != null? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Visibility(
                   visible: iconVisible,
                   child: Icon(svgPicture, color: iconColor,)),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: txtColor ?? Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
