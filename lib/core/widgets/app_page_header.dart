import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../../features/auth/auth_controller.dart';
import 'full_name_text.dart';

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
    final displayName = auth.demoName.isNotEmpty ? auth.demoName : student.name;
    final collegeName = auth.collegeName.isNotEmpty
        ? auth.collegeName
        : student.college;
    final demoProfile = MockData.profileForDisplayName(auth.demoName);
    final initials =
        demoProfile?.initials ??
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collegeName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: faint,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 2),
                FullNameText(
                  displayName,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: navy,
                  ),
                ),
              ],
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

    // Full width, matching More's stretched column. A centered parent
    // would otherwise shrink this block and pull the chevron inward.
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showBack)
              Padding(
                // Title copy stays inset. Only the back control sits in the corner.
                padding: const EdgeInsets.only(left: 2),
                child: IconButton(
                  tooltip: 'Back',
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/more');
                    }
                  },
                  icon: Icon(Icons.chevron_left_rounded, color: navy, size: 28),
                ),
              ),
            if (showBack) const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.4,
                  color: navy,
                ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: muted,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
