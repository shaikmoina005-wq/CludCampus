import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/soft_card.dart';

class LowAttendanceScreen extends StatelessWidget {
  const LowAttendanceScreen({super.key});

  Color _pctColor(double pct) {
    if (pct < 65) return AppColors.danger;
    return AppColors.warning;
  }

  @override
  Widget build(BuildContext context) {
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    final students = MockData.lowAttendance;

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Low attendance',
              subtitle: 'Students below the 75% ANU minimum',
              showBack: true,
            ),
            Expanded(
              child: students.isEmpty
                  ? const EmptyState(
                      icon: Icons.fact_check_outlined,
                      title: 'No students under 75%',
                      message: 'Everyone on this list is clear for now.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                      itemCount: students.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final student = students[i];
                        final pct = student.percent.round();
                        final color = _pctColor(student.percent);
                        return SoftCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.elevatedOf(context),
                                child: Text(
                                  student.initials,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: navy,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: navy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${student.rollNo} · ${student.programme}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: muted,
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${student.present}/${student.total} hours · short in ${student.shortSubject}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: muted,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$pct%',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: color,
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
