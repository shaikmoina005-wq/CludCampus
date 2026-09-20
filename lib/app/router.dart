import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/awards/awards_screen.dart';
import '../features/fees/fees_screen.dart';
import '../features/friday_skill/friday_skill_screen.dart';
import '../features/home/home_screen.dart';
import '../features/leave/leave_screen.dart';
import '../features/more/more_screen.dart';
import '../features/notices/notices_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/timetable/timetable_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      if (!auth.initialized) return null;
      final loc = state.matchedLocation;
      final loggingIn = loc == '/login' || loc == '/';
      if (!auth.isLoggedIn && !loggingIn) return '/login';
      if (auth.isLoggedIn && (loc == '/login' || loc == '/')) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/attendance',
                builder: (_, _) => const AttendanceScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/timetable',
                builder: (_, _) => const TimetableScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/more', builder: (_, _) => const MoreScreen()),
            ],
          ),
        ],
      ),
      GoRoute(path: '/fees', builder: (_, _) => const FeesScreen()),
      GoRoute(path: '/notices', builder: (_, _) => const NoticesScreen()),
      GoRoute(
        path: '/notices/:id',
        builder: (_, state) =>
            NoticeDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/friday-skill',
        builder: (_, _) => const FridaySkillScreen(),
      ),
      GoRoute(path: '/leave', builder: (_, _) => const LeaveScreen()),
      GoRoute(path: '/awards', builder: (_, _) => const AwardsScreen()),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this.ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
  final Ref ref;
}
