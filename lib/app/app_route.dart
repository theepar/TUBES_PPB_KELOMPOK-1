import 'package:flutter/material.dart';

class AppRoute<T> extends PageRouteBuilder<T> {
  AppRoute({required WidgetBuilder builder})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
}
