import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isef01_second_brain_frontend/app/router.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/core/widgets/app_loading_indicator.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_cubit.dart';

class ServiceOAuthCallbackPage extends StatefulWidget {
  const ServiceOAuthCallbackPage({
    super.key,
    required this.service,
  });

  final ServiceType service;

  @override
  State<ServiceOAuthCallbackPage> createState() =>
      _ServiceOAuthCallbackPageState();
}

class _ServiceOAuthCallbackPageState extends State<ServiceOAuthCallbackPage> {
  bool _handled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handled) return;
    _handled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleCallback());
  }

  Future<void> _handleCallback() async {
    final failure = await context.read<SettingsCubit>().completeConnectionCallback(
      widget.service,
      Uri.base,
    );
    if (!mounted) return;

    final message = failure?.message ?? '${_labelFor(widget.service)} verbunden.';
    AppToast.show(
      context,
      message: message,
      type: failure == null ? ToastType.success : ToastType.error,
    );
    context.go(AppRoutes.settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.px24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLoadingIndicator(),
                const SizedBox(height: AppSpacing.px24),
                Text(
                  'Verbindung wird abgeschlossen',
                  style: AppTypography.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.px8),
                Text(
                  '${_labelFor(widget.service)} wird mit dem Backend verknüpft.',
                  style: AppTypography.bodyBase.copyWith(
                    color: AppColors.slate500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _labelFor(ServiceType service) => switch (service) {
    ServiceType.googleCalendar => 'Google Calendar',
    ServiceType.oneNote => 'Microsoft OneNote',
    _ => service.name,
  };
}
