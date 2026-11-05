import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';
import '../auth/auth_controller.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Student More menu — order + hints match live demo /app/more.
    final items = <_MoreItem>[
      const _MoreItem(Icons.auto_awesome_outlined, 'Friday Skill',
          'Friday debate topics and Spotlight Hour', '/friday-skill'),
      const _MoreItem(Icons.note_alt_outlined, 'Notes & reminders',
          'Your own list with a date', '/notes'),
      const _MoreItem(Icons.calendar_month_outlined, 'Calendar',
          'Classes, holidays and reminders', '/calendar'),
      const _MoreItem(Icons.photo_library_outlined, 'Gallery',
          'College celebrations & events', '/gallery'),
      const _MoreItem(Icons.currency_rupee_rounded, 'Fees',
          'Pay and view dues', '/fees'),
      const _MoreItem(Icons.event_busy_outlined, 'Leave requests',
          'Apply and track', '/leave'),
      const _MoreItem(Icons.newspaper_outlined, 'Tech News',
          'World feeds for class discussion', '/tech-news'),
      const _MoreItem(Icons.edit_calendar_outlined, 'Examinations',
          'Internals and ANU timetable', '/examinations'),
      const _MoreItem(Icons.emoji_events_outlined, 'Recognition',
          'Student of the Month and staff awards', '/awards'),
      const _MoreItem(Icons.rate_review_outlined, 'Staff feedback',
          'Ratings after each class', '/staff-feedback'),
      const _MoreItem(Icons.groups_outlined, 'Faculty',
          'Teachers for your programme', '/faculty'),
      const _MoreItem(Icons.account_balance_outlined, 'College',
          'Campus profile', '/college'),
      const _MoreItem(Icons.menu_book_outlined, 'Previous papers',
          'Past exams for every group and year', '/course-papers'),
      const _MoreItem(Icons.notifications_outlined, 'Notification settings',
          'Push types and quiet hours', '/notification-settings'),
      const _MoreItem(Icons.install_mobile_outlined, 'Get the app',
          'Home Screen, iPhone and Android', '/get-app'),
    ];

    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'More',
              subtitle: 'The rest of the campus',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SoftCard(
                        padding: EdgeInsets.zero,
                        onTap: () => context.push(item.route),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(item.icon, color: muted, size: 22),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: navy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle,
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
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SoftCard(
                      padding: EdgeInsets.zero,
                      onTap: () => context.push('/profile'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, color: muted, size: 22),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Profile & appearance',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: navy,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Appearance and sign out',
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.elevatedOf(context),
                        foregroundColor: navy,
                        elevation: 0,
                      ),
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .logout();
                        if (context.mounted) context.go('/login');
                      },
                      child: const Text('Logout'),
                    ),
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

class _MoreItem {
  const _MoreItem(this.icon, this.title, this.subtitle, this.route);
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}
