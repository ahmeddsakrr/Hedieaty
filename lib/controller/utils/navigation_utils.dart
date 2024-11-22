import 'package:flutter/material.dart';


Future<T?> navigateWithAnimation<T>(
    BuildContext context,
    Widget page, {
      bool replace = false,
    }) {
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
    return Navigator.of(context).pushReplacement<T, T>(pageRoute);
  } else {
    return Navigator.of(context).push<T>(pageRoute);
  }
}
