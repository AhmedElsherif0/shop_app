import 'package:flutter/material.dart';

enum Dialogs { yes, no }

class CustomShowDialog {
  static Future<bool> alertDialog({
    String message,
    String title,
    BuildContext context,
    VoidCallback buttonYes,
    VoidCallback buttonNo,
    VoidCallback buttonOk,
  }) async {
    final action = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titleTextStyle: TextStyle(color: Colors.black),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: buttonYes,
              child: buttonYes != null ? const Text('Yes') : null),
          TextButton(
              onPressed: buttonNo,
              child: buttonNo != null ? const Text('No') : null),
          TextButton(
              onPressed: buttonOk,
              child: buttonOk != null ? const Text('Ok') : null),
        ],
      ),
    );
    return (action != null) ? action : Dialogs.no;
  }
}
