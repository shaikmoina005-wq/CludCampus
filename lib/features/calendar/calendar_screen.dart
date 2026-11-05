import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selected = DateTime(2026, 9, 21);
  static final _month = DateTime(2026, 9, 1);

  String _detailFor(DateTime d) {
    for (final h in MockData.calendarHighlights) {
      if (h.date.year == d.year &&
          h.date.month == d.month &&
          h.date.day == d.day) {
        return h.label;
      }
    }
    if (d.weekday == DateTime.sunday) return 'Sunday — no classes';
    return 'Regular classwork';
  }

  String _kindFor(DateTime d) {
    for (final h in MockData.calendarHighlights) {
      if (h.date.year == d.year &&
          h.date.month == d.month &&
          h.date.day == d.day) {
        if (h.isHoliday) return 'HOLIDAY';
        if (h.hasReminder) return 'REMINDER';
        return 'CLASS';
      }
    }
    if (d.weekday == DateTime.sunday) return 'OFF';
    return 'CLASS';
  }

  bool _isHoliday(DateTime d) {
    for (final h in MockData.calendarHighlights) {
      if (h.date.year == d.year &&
          h.date.month == d.month &&
          h.date.day == d.day &&
          h.isHoliday) {
        return true;
      }
    }
    return false;
  }

  bool _hasReminder(DateTime d) {
    for (final h in MockData.calendarHighlights) {
      if (h.date.year == d.year &&
          h.date.month == d.month &&
          h.date.day == d.day &&
          h.hasReminder) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final firstWeekday = DateTime(_month.year, _month.month, 1).weekday; // Mon=1
    final leading = firstWeekday - 1;
    final monthLabel = DateFormat('MMMM yyyy').format(_month);
    final kind = _kindFor(_selected);

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const AppPageHeader(title: 'CludCampus'),
            PageTitleBlock(
              title: 'Calendar',
              subtitle: '$monthLabel · classes, holidays, reminders',
              showBack: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SoftCard(
                child: Column(
                  children: [
                    Text(
                      monthLabel,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        for (final d in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                          Expanded(
                            child: Center(
                              child: Text(
                                d,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: muted,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: leading + daysInMonth,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, i) {
                        if (i < leading) return const SizedBox.shrink();
                        final day = i - leading + 1;
                        final date = DateTime(_month.year, _month.month, day);
                        final selected = date.day == _selected.day &&
                            date.month == _selected.month;
                        final holiday = _isHoliday(date);
                        final reminder = _hasReminder(date);
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => setState(() => _selected = date),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? (isDark
                                          ? Colors.white
                                          : AppColors.primaryButton)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$day',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? (isDark
                                            ? AppColors.navy
                                            : Colors.white)
                                        : navy,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                height: 6,
                                child: holiday || reminder
                                    ? Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: holiday
                                              ? AppColors.holidayGreen
                                              : AppColors.reminderAmber,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const _LegendDot(
                          color: AppColors.holidayGreen,
                          label: 'Holiday',
                        ),
                        const SizedBox(width: 16),
                        const _LegendDot(
                          color: AppColors.reminderAmber,
                          label: 'Reminder',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEE, d MMM, yyyy').format(_selected),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kind,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: muted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _detailFor(_selected),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: navy,
                            height: 1.35,
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

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.mutedTextOf(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: muted)),
      ],
    );
  }
}
