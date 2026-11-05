import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  Color _categoryFill(String category, bool isDark) {
    switch (category.toLowerCase()) {
      case 'holiday':
        return isDark
            ? const Color(0xFF3A2A55)
            : const Color(0xFFEDE7F6);
      case 'exam':
        return isDark
            ? const Color(0xFF1C3A5C)
            : const Color(0xFFD6E6F7);
      case 'fee':
      case 'fees':
        return isDark
            ? const Color(0xFF1C3A5C)
            : const Color(0xFFD6E6F7);
      case 'award':
      case 'recognition':
        return AppColors.elevated;
      case 'event':
      case 'sports':
        return AppColors.elevated;
      default:
        return AppColors.elevated;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notices = MockData.notices;
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Notices',
              subtitle: 'Circulars, holidays and staff leave',
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                itemCount: notices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final n = notices[i];
                  return SoftCard(
                    onTap: () => context.push('/notices/${n.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _Pill(
                              label: n.category.toUpperCase(),
                              foreground: muted,
                              background: isDark
                                  ? AppColors.darkElevated
                                  : _categoryFill(n.category, false),
                            ),
                            if (n.pinned)
                              _Pill(
                                label: 'PINNED',
                                foreground: isDark
                                    ? AppColors.darkBackground
                                    : AppColors.darkTextPrimary,
                                background: AppColors.chromeAccentOf(context),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          n.title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: navy,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('d MMM yyyy').format(n.postedAt),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: foreground,
        ),
      ),
    );
  }
}

class NoticeDetailScreen extends StatelessWidget {
  const NoticeDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final notice = MockData.notices.firstWhere(
      (n) => n.id == id,
      orElse: () => MockData.notices.first,
    );
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(title: 'Notice', showBack: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            _Pill(
                              label: notice.category.toUpperCase(),
                              foreground: muted,
                              background: AppColors.elevatedOf(context),
                            ),
                            if (notice.pinned)
                              _Pill(
                                label: 'PINNED',
                                foreground: AppColors.isDark(context)
                                    ? AppColors.darkBackground
                                    : AppColors.darkTextPrimary,
                                background: AppColors.chromeAccentOf(context),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          notice.title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: navy,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${DateFormat('d MMM yyyy').format(notice.postedAt)} · ${notice.issuer}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: muted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          notice.body,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.5,
                            color: navy,
                          ),
                        ),
                      ],
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
