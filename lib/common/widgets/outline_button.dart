import 'package:flutter/material.dart';
import 'package:presencepro/common/widgets/reusable_text.dart';

import 'font_style.dart';

class CustomOtlnBtn extends StatelessWidget{

  const CustomOtlnBtn({
    super.key,
    required this.width,
    required this.height,
    required this.buttonColor,
    required this.buttonBorderColor,
    required this.onPress,
    required this.buttonName,
    required this.buttonTextColor});

  final VoidCallback onPress;
  final double width;
  final double height;
  final Color? buttonColor;
  final Color buttonBorderColor;
  final Color buttonTextColor;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 1,color:buttonBorderColor),
        ),
        child: Center(
          child: ReusableText(
              text: buttonName,
              style: fontStyle(16,buttonTextColor,FontWeight.normal)),
        ),
      ),
    );
  }}

