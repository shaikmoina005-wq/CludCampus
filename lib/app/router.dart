import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/models/models.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/auth/auth_controller.dart';
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
import '../features/oversight/faculty_leave_screen.dart';
import '../features/oversight/low_attendance_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/tech_news/tech_news_screen.dart';
import '../features/timetable/timetable_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthListenable(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      if (!auth.initialized) return null;
      final loc = state.matchedLocation;
      final onSplash = loc == '/';
      final onLogin = loc == '/login';
      final onCover = loc == '/cover';
      final onAuthFlow = onSplash || onLogin || onCover;

      if (!auth.isLoggedIn) {
        if (onSplash || onLogin) return null;
        return '/login';
      }

      if (onAuthFlow) return '/home';

      // The attendance branch is the student's own record.
      if (!auth.role.isStudent && loc.startsWith('/attendance')) {
        return '/home';
      }
      final onFees = loc == '/fees' || loc == '/more/fees';
      if (onFees && !auth.role.isStudent && !auth.role.reviewsFeeDesk) {
        return '/home';
      }
      final onWatch =
          loc == '/low-attendance' ||
          loc == '/more/low-attendance' ||
          loc == '/faculty-leave' ||
          loc == '/more/faculty-leave';
      if (onWatch && !auth.role.watchesCampus) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/cover', redirect: (_, _) => '/login'),
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
                    builder: (_, state) =>
                        NoticeDetailScreen(id: state.pathParameters['id']!),
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
                  GoRoute(path: 'fees', builder: (_, __) => const FeesScreen()),
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
                    path: 'low-attendance',
                    builder: (_, __) => const LowAttendanceScreen(),
                  ),
                  GoRoute(
                    path: 'faculty-leave',
                    builder: (_, __) => const FacultyLeaveScreen(),
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
      GoRoute(path: '/friday-skill', redirect: (_, __) => '/more/friday-skill'),
      GoRoute(path: '/fees', redirect: (_, __) => '/more/fees'),
      GoRoute(path: '/leave', redirect: (_, __) => '/more/leave'),
      GoRoute(path: '/awards', redirect: (_, __) => '/more/awards'),
      GoRoute(path: '/profile', redirect: (_, __) => '/more/profile'),
      GoRoute(path: '/notes', redirect: (_, __) => '/more/notes'),
      GoRoute(path: '/calendar', redirect: (_, __) => '/more/calendar'),
      GoRoute(path: '/gallery', redirect: (_, __) => '/more/gallery'),
      GoRoute(path: '/tech-news', redirect: (_, __) => '/more/tech-news'),
      GoRoute(path: '/examinations', redirect: (_, __) => '/more/examinations'),
      GoRoute(
        path: '/staff-feedback',
        redirect: (_, __) => '/more/staff-feedback',
      ),
      GoRoute(path: '/faculty', redirect: (_, __) => '/more/faculty'),
      GoRoute(path: '/college', redirect: (_, __) => '/more/college'),
      GoRoute(
        path: '/low-attendance',
        redirect: (_, __) => '/more/low-attendance',
      ),
      GoRoute(
        path: '/faculty-leave',
        redirect: (_, __) => '/more/faculty-leave',
      ),
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
