import 'package:go_router/go_router.dart';
import 'package:isef01_second_brain_frontend/app/shell/app_shell.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/pages/history_page.dart';
import 'package:isef01_second_brain_frontend/features/search/presentation/pages/search_page.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/pages/settings_page.dart';

/// Named-Route-Konstanten — als einzige Referenz in der gesamten App nutzen.
abstract final class AppRoutes {
  static const dashboard = '/';
  static const search = '/search';
  static const history = '/history';
  static const settings = '/settings';
}

/// Zentrale Router-Konfiguration mit GoRouter.
///
/// Alle Seiten liegen innerhalb eines [ShellRoute], der die [AppShell]
/// (Sidebar + Chat-Overlay) persistent hält.
///
/// Route Guards: Platzhalter — `redirect` wird in Phase 2 mit [AuthCubit]
/// ausgebaut; bis dahin sind alle Routen offen.
final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  debugLogDiagnostics: false,
  // ignore: avoid_types_on_closure_parameters
  redirect: (context, state) {
    // Phase 2: Auth-Check hier einfügen.
    // Beispiel: if (!authCubit.isLoggedIn) return '/login';
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
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
      ],
    ),
  ],
);
