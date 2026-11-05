import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/india_public_holidays.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';
import '../notes/notes_controller.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  static final _firstMonth = DateTime(2024, 1, 1);
  static final _lastMonth = DateTime(2029, 12, 1);

  late DateTime _month;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final today = _dateOnly(DateTime.now());
    _selected = today;
    _month = DateTime(today.year, today.month, 1);
  }

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isSecondSaturday(DateTime date) =>
      date.weekday == DateTime.saturday && date.day >= 8 && date.day <= 14;

  List<String> _holidayNames(DateTime date) {
    final names = IndiaPublicHolidays.namesOn(date);
    if (_isSecondSaturday(date)) {
      names.add('Second Saturday — no classes');
    }
    return names;
  }

  List<ClassSlot> _lectures(DateTime date, List<String> holidays) {
    if (holidays.isNotEmpty || date.weekday == DateTime.sunday) return const [];
    final day = MockData.weekdayShort(date);
    return MockData.timetable.where((slot) => slot.day == day).toList();
  }

  List<String> _academicReminders(DateTime date) {
    return [
      for (final item in MockData.academicReminders)
        if (_sameDay(item.date, date)) item.label,
    ];
  }

  void _shiftMonth(int delta) {
    final next = DateTime(_month.year, _month.month + delta, 1);
    if (next.isBefore(_firstMonth) || next.isAfter(_lastMonth)) return;
    final days = DateUtils.getDaysInMonth(next.year, next.month);
    final day = _selected.day.clamp(1, days);
    setState(() {
      _month = next;
      _selected = DateTime(next.year, next.month, day);
    });
  }

  void _goToday() {
    final today = _dateOnly(DateTime.now());
    setState(() {
      _selected = today;
      _month = DateTime(today.year, today.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);
    final today = _dateOnly(DateTime.now());
    final isDark = AppColors.isDark(context);
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final leading = DateTime(_month.year, _month.month, 1).weekday - 1;
    final monthLabel = DateFormat('MMMM yyyy').format(_month);
    final holidays = _holidayNames(_selected);
    final lectures = _lectures(_selected, holidays);
    final reminders = [
      ..._academicReminders(_selected),
      for (final note in notesOn(notes, _selected)) note.text,
    ];
    final onToday = _sameDay(_selected, today) &&
        _month.year == today.year &&
        _month.month == today.month;

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const AppPageHeader(title: 'CludCampus'),
            PageTitleBlock(
              title: 'Calendar',
              subtitle: '$monthLabel · lectures, holidays, reminders',
              showBack: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  if (velocity <= -200) _shiftMonth(1);
                  if (velocity >= 200) _shiftMonth(-1);
                },
                child: SoftCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Previous month',
                            onPressed: _month.isAfter(_firstMonth)
                                ? () => _shiftMonth(-1)
                                : null,
                            icon: const Icon(Icons.chevron_left_rounded),
                          ),
                          Expanded(
                            child: Text(
                              monthLabel,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: navy,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Next month',
                            onPressed: _month.isBefore(_lastMonth)
                                ? () => _shiftMonth(1)
                                : null,
                            icon: const Icon(Icons.chevron_right_rounded),
                          ),
                        ],
                      ),
                      if (!onToday)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _goToday,
                            child: const Text('Today'),
                          ),
                        ),
                      const SizedBox(height: 4),
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
                          childAspectRatio: 0.82,
                        ),
                        itemBuilder: (context, i) {
                          if (i < leading) return const SizedBox.shrink();
                          final day = i - leading + 1;
                          final date = DateTime(_month.year, _month.month, day);
                          final selected = _sameDay(date, _selected);
                          final isToday = _sameDay(date, today);
                          final holiday = _holidayNames(date).isNotEmpty;
                          final reminder = notesOn(notes, date).isNotEmpty ||
                              _academicReminders(date).isNotEmpty;
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() => _selected = date),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? (isDark
                                            ? Colors.white
                                            : AppColors.primaryButton)
                                        : null,
                                    border: isToday && !selected
                                        ? Border.all(
                                            color: isDark
                                                ? Colors.white
                                                : AppColors.primaryButton,
                                            width: 1.6,
                                          )
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
                                          : (holiday
                                              ? AppColors.holidayGreen
                                              : navy),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                SizedBox(
                                  height: 6,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (holiday)
                                        const _Dot(color: AppColors.holidayGreen),
                                      if (holiday && reminder)
                                        const SizedBox(width: 3),
                                      if (reminder)
                                        const _Dot(
                                          color: AppColors.reminderAmber,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          _LegendDot(
                            color: AppColors.holidayGreen,
                            label: 'Holiday',
                          ),
                          SizedBox(width: 16),
                          _LegendDot(
                            color: AppColors.reminderAmber,
                            label: 'Reminder',
                          ),
                        ],
                      ),
                    ],
                  ),
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
                    DateFormat('EEE, d MMM yyyy').format(_selected),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (holidays.isNotEmpty)
                    _DetailCard(
                      label: 'Holiday',
                      body: holidays.join('\n'),
                      note: 'Public holiday or festival. No regular lectures this day.',
                    ),
                  if (holidays.isEmpty &&
                      _selected.weekday == DateTime.sunday)
                    const _DetailCard(
                      label: 'Sunday',
                      body: 'No classes',
                    ),
                  if (lectures.isNotEmpty) ...[
                    if (holidays.isNotEmpty) const SizedBox(height: 10),
                    _DetailCard(
                      label: 'Classes',
                      body: lectures
                          .map(
                            (slot) =>
                                '${slot.subject} · ${slot.startTime}–${slot.endTime} · ${slot.room}',
                          )
                          .join('\n'),
                      note: 'Regular lectures from your timetable.',
                    ),
                  ],
                  if (lectures.isEmpty &&
                      holidays.isEmpty &&
                      _selected.weekday != DateTime.sunday)
                    const _DetailCard(
                      label: 'Classes',
                      body: 'No lectures on this day.',
                    ),
                  if (reminders.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _DetailCard(
                      label: 'Reminder',
                      body: reminders.join('\n'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
        _Dot(color: color),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: muted)),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.label,
    required this.body,
    this.note,
  });

  final String label;
  final String body;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final navy = AppColors.primaryTextOf(context);
    final muted = AppColors.mutedTextOf(context);
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: muted,
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: 6),
            Text(
              note!,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.35,
                color: muted,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: navy,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
