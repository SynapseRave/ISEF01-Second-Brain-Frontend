import 'package:flutter/widgets.dart';

/// Responsive Breakpoints des Second Brain Design Systems.
///
/// Verwendung:
/// ```dart
/// if (AppBreakpoints.isDesktop(context)) { ... }
/// ```
abstract final class AppBreakpoints {
  static const double mobile  =  600; // < 600 → Mobile
  static const double tablet  = 1024; // 600–1023 → Tablet
  // ≥ 1024 → Desktop

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}
