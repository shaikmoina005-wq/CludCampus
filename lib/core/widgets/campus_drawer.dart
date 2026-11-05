import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../../features/auth/auth_controller.dart';
import 'full_name_text.dart';

class CampusDrawer extends ConsumerWidget {
  const CampusDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final student = MockData.student;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final displayName =
        auth.demoName.isNotEmpty ? auth.demoName : student.name;
    DemoRoleProfile? demoProfile;
    for (final r in MockData.demoRoles) {
      if (r.name == auth.demoName) {
        demoProfile = r;
        break;
      }
    }
    final initials = demoProfile?.initials ??
        (displayName == student.name
            ? student.initials
            : displayName
                .split(' ')
                .where((p) => p.isNotEmpty)
                .take(2)
                .map((p) => p[0].toUpperCase())
                .join());

    void go(String route) {
      Navigator.of(context).pop();
      if (route.startsWith('/home') ||
          route == '/attendance' ||
          route == '/timetable' ||
          route == '/notices' ||
          route == '/more') {
        context.go(route);
      } else {
        context.push(route);
      }
    }

    Widget item(IconData icon, String label, String route) {
      return ListTile(
        leading: Icon(icon, color: navy),
        title: Text(
          label,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: navy),
        ),
        onTap: () => go(route),
      );
    }

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        isDark ? AppColors.darkElevated : AppColors.elevated,
                    child: Text(
                      initials,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: navy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FullNameText(
                          displayName,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1.25,
                            color: navy,
                          ),
                        ),
                        Text(
                          demoProfile?.detail ??
                              '${auth.role.label} · ${student.programmeLine}',
                          style: GoogleFonts.inter(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            item(Icons.home_outlined, 'Home', '/home'),
            item(Icons.fact_check_outlined, 'Attendance', '/attendance'),
            item(Icons.schedule_outlined, 'Timetable', '/timetable'),
            item(Icons.article_outlined, 'Notices', '/notices'),
            item(Icons.grid_view_outlined, 'More', '/more'),
            const Divider(),
            item(Icons.person_outline, 'Profile', '/profile'),
          ],
        ),
      ),
    );
  }
}
