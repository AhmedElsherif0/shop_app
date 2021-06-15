import 'package:flutter/material.dart';

class CustomizedText extends StatelessWidget {
  final String text;

   CustomizedText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w800),
    );
  }
}
