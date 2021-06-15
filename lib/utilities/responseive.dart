import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

double dynamicTextSize(BuildContext context, double size) {
  final screenHeight = MediaQuery.of(context).size.height;

  if (screenHeight >= 500 && screenHeight < 550) {
    return size * 0.7;
  } else if (screenHeight >= 550 && screenHeight < 600) {
    return size * 0.75;
  } else if (screenHeight >= 600 && screenHeight < 650) {
    return size * 0.8;
  } else if (screenHeight >= 650 && screenHeight < 700) {
    return size * 0.85;
  } else if (screenHeight >= 700 && screenHeight < 750) {
    return size * 0.9;
  } else if (screenHeight >= 750 && screenHeight < 800) {
    return size * 0.95;
  } else if (screenHeight >= 800 && screenHeight < 850) {
    return size * 1;
  } else if (screenHeight >= 850 && screenHeight < 900) {
    return size * 1.05;
  } else if (screenHeight >= 900 && screenHeight < 950) {
    return size * 1.1;
  } else {
    return size * 1.25;
  }
}

Widget kTxt(BuildContext context, String txt, double size, Color color,
    {FontWeight fontWeight,
    double fontHeight,
    TextAlign align,
    String font,
    int maxLines,
    double letterSpace,
    double height}) {
  return AutoSizeText((txt.trim().trim()),minFontSize: 1,
      textAlign: align ?? TextAlign.center,
      maxLines: maxLines ?? null,
      style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.normal,
          height: fontHeight ?? 1,
          fontSize: dynamicTextSize(context, size),
          fontFamily: font ?? "l",
          letterSpacing: letterSpace ?? 2,
          color: color ?? Colors.white));
}
