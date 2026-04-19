import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';

// ── Skeleton Loader ───────────────────────────────────────────────────────────

/// Animierter Platzhalter-Block während Inhalte laden.
/// [width] und [height] definieren die Größe des Blocks.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = AppSpacing.radiusMd,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmer = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_shimmer.value - 0.5).clamp(0.0, 1.0),
                _shimmer.value.clamp(0.0, 1.0),
                (_shimmer.value + 0.5).clamp(0.0, 1.0),
              ],
              colors: const [
                AppColors.slate100,
                AppColors.slate200,
                AppColors.slate100,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Mehrere Skeleton-Zeilen als Textblock-Platzhalter.
class SkeletonLines extends StatelessWidget {
  const SkeletonLines({super.key, this.lines = 3});

  final int lines;

  static const _widths = [1.0, 0.75, 0.9, 0.6, 0.85];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (i) {
        final fraction = _widths[i % _widths.length];
        return Padding(
          padding: EdgeInsets.only(bottom: i < lines - 1 ? AppSpacing.px8 : 0),
          child: FractionallySizedBox(
            widthFactor: fraction,
            child: const SkeletonBox(height: 14),
          ),
        );
      }),
    );
  }
}

// ── Spinner ───────────────────────────────────────────────────────────────────

enum SpinnerSize { small, medium, large }

/// Kreisförmiger Lade-Indikator in Brand-Farben.
class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size = SpinnerSize.medium});

  final SpinnerSize size;

  @override
  Widget build(BuildContext context) {
    final px = switch (size) {
      SpinnerSize.small => 16.0,
      SpinnerSize.medium => 24.0,
      SpinnerSize.large => 32.0,
    };
    final stroke = switch (size) {
      SpinnerSize.small => 1.5,
      SpinnerSize.medium => 2.0,
      SpinnerSize.large => 2.5,
    };

    return SizedBox(
      width: px,
      height: px,
      child: CircularProgressIndicator(
        strokeWidth: stroke,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.indigo600),
      ),
    );
  }
}

// ── Typing Dots ───────────────────────────────────────────────────────────────

/// Animierte drei Punkte, die beim AI-Tippen angezeigt werden.
class TypingDots extends StatefulWidget {
  const TypingDots({super.key, this.label = 'Analysiere'});

  final String label;

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px12,
        vertical: AppSpacing.px6,
      ),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: AppTypography.bodySm.copyWith(color: AppColors.slate500),
          ),
          const SizedBox(width: AppSpacing.px6),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final phase = (i / 3);
                final val = math.sin((_controller.value - phase) * 2 * math.pi);
                final opacity = ((val + 1) / 2).clamp(0.25, 1.0);
                return Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 3 : 0),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.slate400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
