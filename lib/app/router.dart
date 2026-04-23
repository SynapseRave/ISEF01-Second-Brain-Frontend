import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isef01_second_brain_frontend/app/shell/app_shell.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_cubit.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_state.dart';
import 'package:isef01_second_brain_frontend/core/di/injection.dart';
import 'package:isef01_second_brain_frontend/core/utils/go_router_refresh_stream.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/pages/history_page.dart';
import 'package:isef01_second_brain_frontend/features/login/presentation/pages/login_page.dart';
import 'package:isef01_second_brain_frontend/features/search/presentation/pages/search_page.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/pages/settings_page.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/pages/service_oauth_callback_page.dart';
import 'package:isef01_second_brain_frontend/features/user/presentation/bloc/user_cubit.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const dashboard = '/';
  static const search = '/search';
  static const history = '/history';
  static const settings = '/settings';
  static const googleCalendarCallback = '/settings/connect/callback/google-calendar';
  static const oneNoteCallback = '/settings/connect/callback/onenote';
}

/// Erstellt den konfigurierten GoRouter.
/// Erhält den [AuthCubit] damit der redirect-Callback auf Auth-Änderungen
/// reagieren kann (via [GoRouterRefreshStream]).
GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: false,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final isAuthenticated = authCubit.state is AuthAuthenticated;
      final isLoading =
          authCubit.state is AuthInitial || authCubit.state is AuthLoading;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      // Während der Initialisierung keine Umleitung — Login-Seite wartet.
      if (isLoading) return isOnLogin ? null : AppRoutes.login;

      if (!isAuthenticated && !isOnLogin) return AppRoutes.login;
      if (isAuthenticated && isOnLogin) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ChatCubit>()),
            BlocProvider(
              create: (_) => sl<SettingsCubit>()..loadConnections(),
            ),
            BlocProvider(
              create: (_) => sl<UserCubit>()..loadUser(),
            ),
          ],
          child: AppShell(child: child),
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: AppRoutes.history,
            name: 'history',
            builder: (context, state) => const HistoryPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: AppRoutes.googleCalendarCallback,
            name: 'google-calendar-callback',
            builder: (context, state) => const ServiceOAuthCallbackPage(
              service: ServiceType.googleCalendar,
            ),
          ),
          GoRoute(
            path: AppRoutes.oneNoteCallback,
            name: 'onenote-callback',
            builder: (context, state) => const ServiceOAuthCallbackPage(
              service: ServiceType.oneNote,
            ),
          ),
        ],
      ),
    ],
  );
}
