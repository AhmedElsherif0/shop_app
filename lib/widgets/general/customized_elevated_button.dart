import 'package:flutter/material.dart';

class EditElevatedButton extends StatelessWidget {
  final String text;

  final VoidCallback onPressed;

  final Color onPrimary;

  final Color primary;

  const EditElevatedButton(
      {this.text, this.onPressed, this.onPrimary, this.primary});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
          primary: primary,
          onPrimary: onPrimary),
      child: Text(text),
    );
  }
}
