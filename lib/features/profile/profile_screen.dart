import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/full_name_text.dart';
import '../../core/widgets/soft_card.dart';
import '../auth/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = MockData.student;
    final auth = ref.watch(authControllerProvider);
    final enrolled = MockData.profileForDisplayName(auth.demoName);
    final signedInName = auth.demoName.isNotEmpty
        ? auth.demoName
        : student.name;
    final isPriyaRecord =
        enrolled != null &&
        MockData.nationalMobile(enrolled.phone) ==
            MockData.nationalMobile(student.phone);
    final initials = enrolled?.initials ?? student.initials;
    final detailLine = enrolled == null || isPriyaRecord
        ? student.programmeLine
        : enrolled.detail;
    final phoneLine = enrolled?.phone ?? student.phone;
    final mode = ref.watch(themeControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final elevated = isDark ? AppColors.darkElevated : AppColors.elevated;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(title: 'Profile', showBack: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                children: [
                  SoftCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: elevated,
                          child: Text(
                            initials,
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: navy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FullNameText(
                                signedInName,
                                style: GoogleFonts.inter(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                  color: navy,
                                ),
                              ),
                              const SizedBox(height: 3),
                              // Keep role as plain text (no Chip whitespace bug).
                              Text(
                                auth.role.label,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: muted,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                detailLine,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: muted,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                phoneLine,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appearance',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Follows your phone unless you lock Light or Dark.',
                          style: GoogleFonts.inter(fontSize: 13, color: muted),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _ThemeSegment(
                              label: 'System',
                              selected: mode == ThemeMode.system,
                              onTap: () => ref
                                  .read(themeControllerProvider.notifier)
                                  .setThemeMode(ThemeMode.system),
                            ),
                            const SizedBox(width: 8),
                            _ThemeSegment(
                              label: 'Light',
                              selected: mode == ThemeMode.light,
                              onTap: () => ref
                                  .read(themeControllerProvider.notifier)
                                  .setThemeMode(ThemeMode.light),
                            ),
                            const SizedBox(width: 8),
                            _ThemeSegment(
                              label: 'Dark',
                              selected: mode == ThemeMode.dark,
                              onTap: () => ref
                                  .read(themeControllerProvider.notifier)
                                  .setThemeMode(ThemeMode.dark),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SoftCard(
                    padding: EdgeInsets.zero,
                    onTap: () => context.push('/notification-settings'),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        'Notification settings',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: navy,
                        ),
                      ),
                      subtitle: Text(
                        'Push alerts, types, quiet hours',
                        style: GoogleFonts.inter(color: muted),
                      ),
                      trailing: Icon(Icons.chevron_right, color: muted),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).logout();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSegment extends StatelessWidget {
  const _ThemeSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final selectedBg = isDark ? Colors.white : AppColors.primaryButton;
    final selectedFg = isDark ? AppColors.navy : Colors.white;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? selectedBg : border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: selected ? selectedFg : navy,
            ),
          ),
        ),
      ),
    );
  }
}
