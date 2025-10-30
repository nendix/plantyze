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

  static Future<dynamic> pushReplacement(
    BuildContext context,
    Widget page, {
    bool rootNavigator = false,
  }) {
    return Navigator.of(context, rootNavigator: rootNavigator)
        .pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<dynamic> pushAndRemoveUntil(
    BuildContext context,
    Widget page,
    RoutePredicate predicate, {
    bool rootNavigator = false,
  }) {
    return Navigator.of(context, rootNavigator: rootNavigator)
        .pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      predicate,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  static void popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.of(context).popUntil(predicate);
  }
}
