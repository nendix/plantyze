import 'package:flutter/material.dart';

class NavigationService {
  static Future<dynamic> push(
    BuildContext context,
    Widget page, {
    bool rootNavigator = false,
  }) {
    return Navigator.of(context, rootNavigator: rootNavigator).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }
}
