import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../../features/auth/auth_controller.dart';

/// Demo chrome: college name left, initials avatar right.
class AppPageHeader extends ConsumerWidget {
  const AppPageHeader({
    super.key,
    this.title,
    this.showBrand = true,
    this.onMenu,
  });

  final String? title;
  final bool showBrand;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navy = AppColors.primaryTextOf(context);
    final faint = AppColors.faintTextOf(context);
    final student = MockData.student;
    final auth = ref.watch(authControllerProvider);
    final displayName =
        auth.demoName.isNotEmpty ? auth.demoName : student.name;
    final collegeName = auth.collegeName.isNotEmpty
        ? auth.collegeName
        : student.college;
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              collegeName,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: faint,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.elevatedOf(context),
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageTitleBlock extends StatelessWidget {
  const PageTitleBlock({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
  });

  final String title;
  final String? subtitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/more');
                }
              },
              icon: Icon(Icons.chevron_left_rounded, color: navy, size: 28),
            ),
          if (showBack) const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.4,
              color: navy,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: GoogleFonts.inter(fontSize: 14, color: muted, height: 1.35),
            ),
          ],
        ],
      ),
    );
  }
}
