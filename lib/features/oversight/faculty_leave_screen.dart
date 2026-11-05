import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/soft_card.dart';

class FacultyLeaveScreen extends StatelessWidget {
  const FacultyLeaveScreen({super.key});

  String _dates(FacultyLeave leave) {
    final full = DateFormat('d MMM yyyy');
    final sameDay =
        leave.from.year == leave.to.year &&
        leave.from.month == leave.to.month &&
        leave.from.day == leave.to.day;
    if (sameDay) return full.format(leave.from);
    final short = DateFormat('d MMM');
    if (leave.from.year == leave.to.year) {
      return '${short.format(leave.from)} – ${full.format(leave.to)}';
    }
    return '${full.format(leave.from)} – ${full.format(leave.to)}';
  }

  @override
  Widget build(BuildContext context) {
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    final leaves = MockData.facultyOnLeave;

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Faculty on leave',
              subtitle: 'Teachers away from class',
              showBack: true,
            ),
            Expanded(
              child: leaves.isEmpty
                  ? const EmptyState(
                      icon: Icons.event_available_outlined,
                      title: 'No faculty on leave',
                      message: 'Everyone on the teaching list is in.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                      itemCount: leaves.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final leave = leaves[i];
                        return SoftCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.elevatedOf(context),
                                child: Text(
                                  leave.initials,
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
                                      leave.name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: navy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${leave.designation} · ${leave.department}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: muted,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _dates(leave),
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: navy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      leave.note,
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.pillBgOf(context),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  leave.type,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: muted,
                                  ),
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
