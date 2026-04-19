import 'package:flutter/material.dart';

/// Alle Farb-Tokens des Second Brain Design Systems.
///
/// Nutze ausschliesslich diese Konstanten — keine hardcodierten Hex-Werte
/// in Widgets, damit spätere Theme-Anpassungen zentral bleiben.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color indigo600 = Color(0xFF4F46E5); // Primary CTA, aktive Nav
  static const Color indigo500 = Color(0xFF6366F1); // Hover, Icons
  static const Color violet600 = Color(0xFF7C3AED); // Gradient, AI-Elemente

  // ── Neutrals / Slate ─────────────────────────────────────────────────────
  static const Color slate950 = Color(0xFF020617); // Sidebar-Hintergrund
  static const Color slate900 = Color(0xFF0F172A); // Primärer Titel-Text
  static const Color slate800 = Color(0xFF1E293B); // Dunkle Texte
  static const Color slate700 = Color(0xFF334155); // Sekundärer Inhalt-Text
  static const Color slate600 = Color(0xFF475569); // Gedeckter Sekundär-Text
  static const Color slate500 = Color(0xFF64748B); // Tertiärer Hilfs-Text
  static const Color slate400 = Color(0xFF94A3B8); // Placeholder, Timestamps
  static const Color slate300 = Color(0xFFCBD5E1); // Trennlinien
  static const Color slate200 = Color(0xFFE2E8F0); // Disabled-Hintergründe
  static const Color slate100 = Color(0xFFF1F5F9); // App-Hintergrund
  static const Color slate50 = Color(0xFFF8FAFC); // Card-Hintergrund (leicht)

  // ── Semantisch ───────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ── Service-Farben ───────────────────────────────────────────────────────
  static const Color notion = Color(0xFF000000);
  static const Color todoist = Color(0xFFDB4035);
  static const Color obsidian = Color(0xFF7C3AED);
  static const Color oneNote = Color(0xFF7719AA);
  static const Color kalender = Color(0xFF1A73E8);

  // ── Surface / Background ─────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = slate100;

  // ── Gradienten ───────────────────────────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    colors: [indigo600, violet600],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient sidebarGradient = LinearGradient(
    colors: [slate950, slate800],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
