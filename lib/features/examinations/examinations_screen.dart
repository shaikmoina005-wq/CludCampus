import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class ExaminationsScreen extends StatelessWidget {
  const ExaminationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Examinations',
              subtitle: 'Schedules and ANU pattern',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    accentLeft: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I INTERNALS',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                            color: AppColors.brandBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '15–20 September 2026',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('ANU pattern · II Year A',
                            style: GoogleFonts.inter(color: muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...MockData.internalExams.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SoftCard(
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.brandBlue.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    e.dateLabel.split(' ').first,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: AppColors.brandBlue,
                                    ),
                                  ),
                                  Text(
                                    e.dateLabel.split(' ').last.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: AppColors.brandBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.subject,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: navy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${e.code} · ${e.timeLabel}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
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
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ANU semester-end examinations',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tentative: November 2026. Final timetable will be published by the university.',
                          style: GoogleFonts.inter(color: muted, height: 1.4),
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
