import 'package:flutter/widgets.dart';

class LoginOverlayScope extends InheritedWidget {
  final bool isLoggedIn;
  final VoidCallback showLoginOverlay;

  const LoginOverlayScope({
    super.key,
    required this.isLoggedIn,
    required this.showLoginOverlay,
    required super.child,
  });

  static LoginOverlayScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoginOverlayScope>();
  }

  @override
  bool updateShouldNotify(LoginOverlayScope oldWidget) {
    return isLoggedIn != oldWidget.isLoggedIn ||
        showLoginOverlay != oldWidget.showLoginOverlay;
  }
}
