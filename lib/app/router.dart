import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/cover_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/awards/awards_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/college/college_screen.dart';
import '../features/course_papers/course_papers_screen.dart';
import '../features/examinations/examinations_screen.dart';
import '../features/faculty/faculty_screen.dart';
import '../features/fees/fees_screen.dart';
import '../features/feedback/staff_feedback_screen.dart';
import '../features/friday_skill/friday_skill_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/get_app/get_app_screen.dart';
import '../features/home/home_screen.dart';
import '../features/leave/leave_screen.dart';
import '../features/more/more_screen.dart';
import '../features/notes/notes_screen.dart';
import '../features/notices/notices_screen.dart';
import '../features/notifications/notification_settings_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/tech_news/tech_news_screen.dart';
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
      final onSplash = loc == '/';
      final onCover = loc == '/cover';
      final onLogin = loc == '/login';
      final onAuthFlow = onSplash || onCover || onLogin;

      if (!auth.isLoggedIn) {
        if (onSplash || onCover) return null;
        if (onLogin) {
          if (!auth.hasCollege) return '/cover';
          return null;
        }
        return auth.hasCollege ? '/login' : '/cover';
      }

      if (auth.isLoggedIn && onAuthFlow) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/cover', builder: (_, __) => const CoverScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/attendance',
                builder: (_, __) => const AttendanceScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/timetable',
                builder: (_, __) => const TimetableScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notices',
                builder: (_, __) => const NoticesScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => NoticeDetailScreen(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (_, __) => const MoreScreen(),
                routes: [
                  GoRoute(
                    path: 'friday-skill',
                    builder: (_, __) => const FridaySkillScreen(),
                  ),
                  GoRoute(
                    path: 'notes',
                    builder: (_, __) => const NotesScreen(),
                  ),
                  GoRoute(
                    path: 'calendar',
                    builder: (_, __) => const CalendarScreen(),
                  ),
                  GoRoute(
                    path: 'gallery',
                    builder: (_, __) => const GalleryScreen(),
                  ),
                  GoRoute(
                    path: 'fees',
                    builder: (_, __) => const FeesScreen(),
                  ),
                  GoRoute(
                    path: 'leave',
                    builder: (_, __) => const LeaveScreen(),
                  ),
                  GoRoute(
                    path: 'tech-news',
                    builder: (_, __) => const TechNewsScreen(),
                  ),
                  GoRoute(
                    path: 'examinations',
                    builder: (_, __) => const ExaminationsScreen(),
                  ),
                  GoRoute(
                    path: 'awards',
                    builder: (_, __) => const AwardsScreen(),
                  ),
                  GoRoute(
                    path: 'staff-feedback',
                    builder: (_, __) => const StaffFeedbackScreen(),
                  ),
                  GoRoute(
                    path: 'faculty',
                    builder: (_, __) => const FacultyScreen(),
                  ),
                  GoRoute(
                    path: 'college',
                    builder: (_, __) => const CollegeScreen(),
                  ),
                  GoRoute(
                    path: 'course-papers',
                    builder: (_, __) => const CoursePapersScreen(),
                  ),
                  GoRoute(
                    path: 'notification-settings',
                    builder: (_, __) => const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'get-app',
                    builder: (_, __) => const GetAppScreen(),
                  ),
                  GoRoute(
                    path: 'profile',
                    builder: (_, __) => const ProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Absolute aliases so home deep-links keep working.
      GoRoute(
        path: '/friday-skill',
        redirect: (_, __) => '/more/friday-skill',
      ),
      GoRoute(path: '/fees', redirect: (_, __) => '/more/fees'),
      GoRoute(path: '/leave', redirect: (_, __) => '/more/leave'),
      GoRoute(path: '/awards', redirect: (_, __) => '/more/awards'),
      GoRoute(path: '/profile', redirect: (_, __) => '/more/profile'),
      GoRoute(path: '/notes', redirect: (_, __) => '/more/notes'),
      GoRoute(path: '/calendar', redirect: (_, __) => '/more/calendar'),
      GoRoute(path: '/gallery', redirect: (_, __) => '/more/gallery'),
      GoRoute(path: '/tech-news', redirect: (_, __) => '/more/tech-news'),
      GoRoute(
        path: '/examinations',
        redirect: (_, __) => '/more/examinations',
      ),
      GoRoute(
        path: '/staff-feedback',
        redirect: (_, __) => '/more/staff-feedback',
      ),
      GoRoute(path: '/faculty', redirect: (_, __) => '/more/faculty'),
      GoRoute(path: '/college', redirect: (_, __) => '/more/college'),
      GoRoute(
        path: '/course-papers',
        redirect: (_, __) => '/more/course-papers',
      ),
      GoRoute(
        path: '/notification-settings',
        redirect: (_, __) => '/more/notification-settings',
      ),
      GoRoute(path: '/get-app', redirect: (_, __) => '/more/get-app'),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this.ref) {
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
  final Ref ref;
}
