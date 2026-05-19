import 'package:flutter/widgets.dart';

typedef LoginSuccessAction = void Function();
typedef ShowLoginOverlay = void Function({LoginSuccessAction? onLoginSuccess});

class LoginOverlayScope extends InheritedWidget {
  final bool isLoggedIn;
  final ShowLoginOverlay showLoginOverlay;

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
