import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class CollegeScreen extends StatelessWidget {
  const CollegeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final c = MockData.asnCollege;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'College',
              subtitle: 'Profile and campus network',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.name,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: navy,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                c.statusLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(c.address ?? '',
                            style: GoogleFonts.inter(color: muted)),
                        const SizedBox(height: 8),
                        Text('Affiliation · ${c.affiliation}',
                            style: GoogleFonts.inter(color: muted)),
                        const SizedBox(height: 4),
                        Text(c.phone ?? '',
                            style: GoogleFonts.inter(color: muted)),
                        Text(c.email ?? '',
                            style: GoogleFonts.inter(color: muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Network',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...MockData.colleges.map(
                    (col) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SoftCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: col.isLive
                                  ? AppColors.brandBlue.withValues(alpha: 0.15)
                                  : (isDark
                                      ? AppColors.darkElevated
                                      : AppColors.elevated),
                              child: Text(
                                col.abbrev,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: col.isLive
                                      ? AppColors.brandBlue
                                      : navy,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    col.name,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: navy,
                                    ),
                                  ),
                                  Text(
                                    '${col.code} · ${col.city}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              col.statusLabel,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: col.isLive
                                    ? AppColors.success
                                    : muted,
                              ),
                            ),
                          ],
                        ),
                      ),
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
