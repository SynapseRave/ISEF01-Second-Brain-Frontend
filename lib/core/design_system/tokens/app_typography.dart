import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';

/// Typografie-Tokens des Second Brain Design Systems.
///
/// Nutze ausschliesslich diese Stile — keine hardcodierten fontSize-Werte
/// in Widgets, damit Anpassungen zentral bleiben.
abstract final class AppTypography {
  // ── Schriftgrößen ─────────────────────────────────────────────────────────
  static const double _size2xl = 24;
  static const double _sizeXl = 20;
  static const double _sizeLg = 18;
  static const double _sizeMd = 16; // text-base
  static const double _sizeSm = 14;
  static const double _sizeXs = 12;
  static const double _size11 = 11;
  static const double _size10 = 10;

  // ── Headings ──────────────────────────────────────────────────────────────
  static const TextStyle h1 = TextStyle(
    fontSize: _size2xl,
    fontWeight: FontWeight.w500,
    color: AppColors.slate900,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: _sizeXl,
    fontWeight: FontWeight.w500,
    color: AppColors.slate900,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: _sizeLg,
    fontWeight: FontWeight.w500,
    color: AppColors.slate900,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: _sizeMd,
    fontWeight: FontWeight.w500,
    color: AppColors.slate900,
    height: 1.4,
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  static const TextStyle bodyBase = TextStyle(
    fontSize: _sizeMd,
    fontWeight: FontWeight.w400,
    color: AppColors.slate700,
    height: 1.5,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: _sizeSm,
    fontWeight: FontWeight.w400,
    color: AppColors.slate700,
    height: 1.5,
  );

  static const TextStyle bodyXs = TextStyle(
    fontSize: _sizeXs,
    fontWeight: FontWeight.w400,
    color: AppColors.slate500,
    height: 1.4,
  );

  static const TextStyle body11 = TextStyle(
    fontSize: _size11,
    fontWeight: FontWeight.w400,
    color: AppColors.slate500,
    height: 1.4,
  );

  static const TextStyle body10 = TextStyle(
    fontSize: _size10,
    fontWeight: FontWeight.w400,
    color: AppColors.slate400,
    height: 1.4,
  );

  // ── Labels / UI ───────────────────────────────────────────────────────────
  static const TextStyle labelSm = TextStyle(
    fontSize: _sizeSm,
    fontWeight: FontWeight.w500,
    color: AppColors.slate700,
    height: 1.2,
  );

  static const TextStyle labelXs = TextStyle(
    fontSize: _sizeXs,
    fontWeight: FontWeight.w500,
    color: AppColors.slate500,
    height: 1.2,
  );

  static const TextStyle timestamp = TextStyle(
    fontSize: _sizeXs,
    fontWeight: FontWeight.w400,
    color: AppColors.slate400,
    height: 1.2,
  );
}
