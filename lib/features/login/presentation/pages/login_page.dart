import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_cubit.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_state.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/core/widgets/app_loading_indicator.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.px32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Logo(),
                    const SizedBox(height: AppSpacing.px48),
                    Text(
                      'Willkommen zurück',
                      style: AppTypography.h2.copyWith(
                        color: AppColors.slate900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.px8),
                    Text(
                      'Melde dich mit deinem Keycloak-Account an.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.slate500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.px40),
                    if (state is AuthLoading)
                      const AppLoadingIndicator()
                    else
                      AppButton(
                        label: 'Anmelden',
                        onPressed: () => context.read<AuthCubit>().login(),
                        size: AppButtonSize.large,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: const Icon(
          Icons.psychology_rounded,
          color: AppColors.white,
          size: 40,
        ),
      ),
    );
  }
}
