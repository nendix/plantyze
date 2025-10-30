import 'package:flutter/material.dart';

class SnackBarService {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      Icons.check_circle,
      null,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      Icons.error,
      Colors.red,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      Icons.info,
      null,
    );
  }

  static void _show(
    BuildContext context,
    String message,
    IconData icon,
    Color? backgroundColor,
  ) {
    final theme = Theme.of(context);
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.onPrimary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
