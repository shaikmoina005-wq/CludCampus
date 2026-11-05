import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/full_name_text.dart';
import '../../core/widgets/soft_card.dart';
import '../auth/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final student = MockData.student;
    final attendance = MockData.attendance;
    final notices = MockData.notices.take(3).toList();
    final greeting = MockData.timeGreeting();
    final demoProfile = MockData.profileForDisplayName(auth.demoName);
    final displayName = auth.demoName.isNotEmpty ? auth.demoName : student.name;
    final collegeName = auth.collegeName.isNotEmpty
        ? auth.collegeName
        : student.college;
    final dateLine = DateFormat('EEEE, d MMMM').format(DateTime.now());
    final pct = attendance.overallPercent.round();
    final isStudent = auth.role == UserRole.student;
    final showToday =
        isStudent || auth.role == UserRole.faculty || auth.role == UserRole.hod;
    final today = isStudent
        ? MockData.todayClasses()
        : MockData.classesForPerson(demoProfile?.name ?? displayName);

    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    final faint = AppColors.faintTextOf(context);
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: AppPageHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    collegeName.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: faint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FullNameText(
                    '$greeting, $displayName',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      letterSpacing: -0.4,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$dateLine · ${demoProfile?.detail ?? (isStudent ? '${student.branch} · ${student.year}' : auth.role.label)}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (isStudent) ...[
                    // Attendance + Fee due (demo side-by-side)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: SoftCard(
                              onTap: () => context.go('/attendance'),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: CustomPaint(
                                          painter: _RingPainter(
                                            progress:
                                                attendance.overallPercent / 100,
                                            color: AppColors.attendanceGreen,
                                            trackColor: isDark
                                                ? AppColors.darkElevated
                                                : AppColors.elevated,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$pct%',
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.attendanceGreen,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Overall attendance',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: muted,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${attendance.overallPresent}/${attendance.overallTotal} hours',
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: navy,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Above the 75% ANU minimum',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: faint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SoftCard(
                              onTap: () => context.push('/more/fees'),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fee due',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: muted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '₹${MockData.examFeeAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                    style: GoogleFonts.inter(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                      color: navy,
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: () =>
                                          context.push('/more/fees'),
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size.fromHeight(40),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        textStyle: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      child: const Text('Pay now'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Recognition
                    SoftCard(
                      onTap: () => context.push('/more/awards'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RECOGNITION',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: faint,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            MockData.recognitionTitle,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            MockData.recognitionPeriod,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Friday Skill
                    SoftCard(
                      accentLeft: true,
                      onTap: () => context.push('/more/friday-skill'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'FRIDAY SKILL',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6,
                                  color: faint,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                MockData.fridaySkillTime,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: faint,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            MockData.fridaySkillTitle,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            MockData.fridaySkillMeta,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Feedback CTA — muted secondary like demo
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.push('/staff-feedback'),
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.darkElevated
                              : const Color(0xFF8A9BB0),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Give class feedback'),
                      ),
                    ),
                  ] else
                    _StaffHomeCards(role: auth.role, collegeName: collegeName),
                  const SizedBox(height: 28),

                  if (showToday) ...[
                    // Today
                    Row(
                      children: [
                        Text(
                          'Today',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: navy,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.go('/timetable'),
                          child: Text(
                            'Week ›',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SoftCard(
                      child: today.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  isStudent
                                      ? 'No class periods today.'
                                      : 'No classes on your timetable today.',
                                  style: GoogleFonts.inter(
                                    color: muted,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                for (var i = 0; i < today.length; i++) ...[
                                  if (i > 0)
                                    Divider(
                                      height: 20,
                                      color: AppColors.dividerOf(context),
                                    ),
                                  _TodayRow(slot: today[i]),
                                ],
                              ],
                            ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Notices
                  Row(
                    children: [
                      Text(
                        'Notices',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: navy,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => context.go('/notices'),
                        child: Text(
                          'View ›',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SoftCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < notices.length; i++) ...[
                          if (i > 0)
                            Divider(
                              height: 1,
                              color: AppColors.dividerOf(context),
                            ),
                          _NoticeRow(
                            notice: notices[i],
                            onTap: () =>
                                context.push('/notices/${notices[i].id}'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffHomeCards extends StatelessWidget {
  const _StaffHomeCards({required this.role, required this.collegeName});

  final UserRole role;
  final String collegeName;

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[];
    void add(String kicker, String title, String subtitle, VoidCallback onTap) {
      if (cards.isNotEmpty) cards.add(const SizedBox(height: 12));
      cards.add(
        SoftCard(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kicker,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.faintTextOf(context),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextOf(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.mutedTextOf(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    switch (role) {
      case UserRole.faculty:
        add(
          'TEACHING',
          'Your timetable',
          'Classes assigned to you',
          () => context.go('/timetable'),
        );
      case UserRole.hod:
        add(
          'DEPARTMENT',
          'Computer Science',
          'Teachers in the department',
          () => context.push('/more/faculty'),
        );
        add(
          'ATTENDANCE',
          'Low attendance',
          '${MockData.lowAttendance.length} students below the 75% line',
          () => context.push('/more/low-attendance'),
        );
        add(
          'LEAVE',
          'Faculty on leave',
          '${MockData.facultyOnLeave.length} teachers away from class',
          () => context.push('/more/faculty-leave'),
        );
        add(
          'TEACHING',
          'Your timetable',
          'Classes assigned to you',
          () => context.go('/timetable'),
        );
      case UserRole.principal:
        add(
          'CAMPUS',
          collegeName,
          'College profile',
          () => context.push('/more/college'),
        );
        add(
          'ATTENDANCE',
          'Low attendance',
          '${MockData.lowAttendance.length} students below the 75% line',
          () => context.push('/more/low-attendance'),
        );
        add(
          'LEAVE',
          'Faculty on leave',
          '${MockData.facultyOnLeave.length} teachers away from class',
          () => context.push('/more/faculty-leave'),
        );
        add(
          'FACULTY',
          'Department teachers',
          'Computer Science faculty',
          () => context.push('/more/faculty'),
        );
      case UserRole.collegeOffice:
        add(
          'FEES',
          'Fee desk',
          'Student dues and receipts',
          () => context.push('/more/fees'),
        );
        add(
          'LEAVE',
          'Leave requests',
          'Applications sent to the office',
          () => context.push('/more/leave'),
        );
        add(
          'CAMPUS',
          collegeName,
          'College profile',
          () => context.push('/more/college'),
        );
      case UserRole.student:
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }
}

class _TodayRow extends StatelessWidget {
  const _TodayRow({required this.slot});
  final ClassSlot slot;

  String get _ampm {
    final parts = slot.startTime.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? parts[1] : '00';
    final suffix = h >= 12 ? 'pm' : 'am';
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$h12:${m.padLeft(2, '0')} $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slot.subject,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${slot.room} · ${slot.faculty}',
                style: GoogleFonts.inter(fontSize: 12, color: muted),
              ),
            ],
          ),
        ),
        Text(
          _ampm,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: muted,
          ),
        ),
      ],
    );
  }
}

class _NoticeRow extends StatelessWidget {
  const _NoticeRow({required this.notice, required this.onTap});
  final Notice notice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    final faint = AppColors.faintTextOf(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.pillBgOf(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                notice.category.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: muted,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notice.title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d MMM yyyy').format(notice.postedAt),
              style: GoogleFonts.inter(fontSize: 12, color: faint),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 4;
    final bg = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.2832 * progress.clamp(0.0, 1.0),
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}
