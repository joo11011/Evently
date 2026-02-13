import 'package:flutter/material.dart';

class AppDialogs {
  static void showMessage(
    BuildContext context,
    String message, {
    DialogType type = DialogType.success,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: type == DialogType.success ? Colors.green : Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

enum DialogType { success, error }
