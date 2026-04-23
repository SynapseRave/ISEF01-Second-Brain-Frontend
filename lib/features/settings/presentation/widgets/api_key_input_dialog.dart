import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

/// Dialog zur Eingabe von API-Keys / Tokens für Dienste ohne OAuth-Flow.
///
/// - Notion & Todoist: ein Feld (api_token)
/// - Obsidian: zwei Felder (api_key + base_url mit Default)
///
/// Gibt `null` zurück wenn der User abbricht, sonst die Credentials-Map
/// die direkt an den Backend-Endpunkt übergeben werden kann.
class ApiKeyInputDialog extends StatefulWidget {
  const ApiKeyInputDialog._({required this.service});

  final ServiceType service;

  /// Öffnet den Dialog und liefert die eingegebenen Credentials,
  /// oder `null` wenn der User abbricht.
  static Future<Map<String, dynamic>?> show(
    BuildContext context,
    ServiceType service,
  ) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ApiKeyInputDialog._(service: service),
    );
  }

  @override
  State<ApiKeyInputDialog> createState() => _ApiKeyInputDialogState();
}

class _ApiKeyInputDialogState extends State<ApiKeyInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _urlController = TextEditingController(
    text: 'http://localhost:27123',
  );

  bool _obscureToken = true;

  @override
  void dispose() {
    _tokenController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final credentials = switch (widget.service) {
      ServiceType.notion || ServiceType.todoist => {
        'api_token': _tokenController.text.trim(),
      },
      ServiceType.obsidian => {
        'api_key': _tokenController.text.trim(),
        'base_url': _urlController.text.trim().isEmpty
            ? 'http://localhost:27123'
            : _urlController.text.trim(),
      },
      _ => <String, dynamic>{},
    };

    Navigator.of(context).pop(credentials);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.px24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Row(
                  children: [
                    ServiceAvatar(service: widget.service, size: 36),
                    const SizedBox(width: AppSpacing.px12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titleFor(widget.service),
                            style: AppTypography.h4,
                          ),
                          Text(
                            _subtitleFor(widget.service),
                            style: AppTypography.bodyXs.copyWith(
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.px20),

                // ── Token / API-Key Feld ─────────────────────────────────────
                Text(_tokenLabelFor(widget.service), style: AppTypography.labelSm),
                const SizedBox(height: AppSpacing.px6),
                TextFormField(
                  controller: _tokenController,
                  obscureText: _obscureToken,
                  style: AppTypography.bodySm,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: _tokenHintFor(widget.service),
                    hintStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.slate400,
                    ),
                    filled: true,
                    fillColor: AppColors.slate50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.px12,
                      vertical: AppSpacing.px10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.slate200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: AppColors.indigo600,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureToken
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: AppColors.slate400,
                      ),
                      onPressed: () =>
                          setState(() => _obscureToken = !_obscureToken),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
                ),

                // ── Obsidian: zweites Feld (Server-URL) ──────────────────────
                if (widget.service == ServiceType.obsidian) ...[
                  const SizedBox(height: AppSpacing.px16),
                  Text('Server-URL', style: AppTypography.labelSm),
                  const SizedBox(height: AppSpacing.px6),
                  TextFormField(
                    controller: _urlController,
                    style: AppTypography.bodySm,
                    decoration: InputDecoration(
                      hintText: 'http://localhost:27123',
                      hintStyle: AppTypography.bodySm.copyWith(
                        color: AppColors.slate400,
                      ),
                      helperText:
                          'URL des Obsidian Local REST API Plugins',
                      helperStyle: AppTypography.bodyXs.copyWith(
                        color: AppColors.slate400,
                      ),
                      filled: true,
                      fillColor: AppColors.slate50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.px12,
                        vertical: AppSpacing.px10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: const BorderSide(color: AppColors.slate200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: const BorderSide(
                          color: AppColors.indigo600,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final uri = Uri.tryParse(v.trim());
                      if (uri == null || !uri.hasScheme) {
                        return 'Ungültige URL (z. B. http://localhost:27123)';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: AppSpacing.px24),

                // ── Buttons ───────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      label: 'Abbrechen',
                      variant: AppButtonVariant.ghost,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppSpacing.px8),
                    AppButton(
                      label: 'Verbinden',
                      icon: Icons.link_rounded,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _titleFor(ServiceType service) => switch (service) {
    ServiceType.notion => 'Notion verbinden',
    ServiceType.todoist => 'Todoist verbinden',
    ServiceType.obsidian => 'Obsidian verbinden',
    _ => 'Dienst verbinden',
  };

  static String _subtitleFor(ServiceType service) => switch (service) {
    ServiceType.notion =>
      'Integration Token aus den Notion-Einstellungen',
    ServiceType.todoist =>
      'API Token aus den Todoist-Einstellungen → Integrationen',
    ServiceType.obsidian =>
      'API Key des Obsidian Local REST API Plugins',
    _ => '',
  };

  static String _tokenLabelFor(ServiceType service) => switch (service) {
    ServiceType.obsidian => 'API Key',
    _ => 'API Token',
  };

  static String _tokenHintFor(ServiceType service) => switch (service) {
    ServiceType.notion => 'secret_xxxxxxxxxxxxxxxxxxxxxxxx',
    ServiceType.todoist => 'deine Todoist API Token',
    ServiceType.obsidian => 'dein Obsidian REST-Plugin API Key',
    _ => '',
  };
}
