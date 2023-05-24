import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';


class AppDivider extends StatelessWidget {
  String label;
   AppDivider({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width/2.8,
          child: Divider(
            color: AppColors.bodyTextColor,
            thickness: 1,
          ),
        ),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.bodyTextColor)),
        SizedBox(
          width:MediaQuery.of(context).size.width/2.8,
          child: Divider(
            thickness: 1,
            color: AppColors.bodyTextColor,
          ),
        ),
      ],
    );
  }
}
