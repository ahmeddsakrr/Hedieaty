import 'package:flutter/material.dart';

import '../../main.dart';


Future<T?> navigateWithAnimation<T>(
    Widget page, {
      bool replace = false,
    }) {
  final navigator = navigatorKey.currentState!;
  final pageRoute = PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(0.0, 0.1);
      const endOffset = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: beginOffset, end: endOffset)
          .chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );

  if (replace) {
    return navigator.pushReplacement<T, T>(pageRoute);
  } else {
    return navigator.push<T>(pageRoute);
  }
}
