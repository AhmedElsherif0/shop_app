import 'package:flutter/material.dart';

class EditTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color onPrimary;

  const EditTextButton(
      {@required this.onPressed, @required this.text, this.onPrimary});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
          onPrimary: onPrimary,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),

      child: Text(text),
    );
  }
}
