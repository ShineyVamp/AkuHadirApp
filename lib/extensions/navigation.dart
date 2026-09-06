import 'package:flutter/material.dart';

extension ExtendedNavigator on BuildContext {
  Future<T?> push<T extends Object?>(Widget page, {String? name}) async {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: name ?? page.runtimeType.toString()),
      ),
    );
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    String? name,
    TO? result,
  }) async {
    return Navigator.pushReplacement<T, TO>(
      this,
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: name ?? page.runtimeType.toString()),
      ),
      result: result,
    );
  }

  Future<T?> pushAndRemoveAll<T extends Object?>(Widget page, {String? name}) async {
    return Navigator.pushAndRemoveUntil<T>(
      this,
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: name ?? page.runtimeType.toString()),
      ),
      (route) => false,
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
