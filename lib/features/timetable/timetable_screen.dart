import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/soft_card.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    final today = MockData.weekdayShort(DateTime(2026, 9, 21));
    _selectedDay = _days.contains(today) ? today : 'Mon';
  }

  List<ClassSlot> _forDay(String day) =>
      MockData.timetable.where((c) => c.day == day).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final slots = _forDay(_selectedDay);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            PageTitleBlock(
              title: 'Class timetable',
              subtitle: MockData.semesterLabel,
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final d = _days[i];
                  final selected = d == _selectedDay;
                  final accent = AppColors.chromeAccentOf(context);
                  final onAccent = isDark
                      ? AppColors.darkBackground
                      : const Color(0xFFF2F4F7);
                  return Material(
                    color: selected
                        ? accent
                        : (isDark ? AppColors.darkSurface : Colors.white),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: selected
                            ? accent
                            : AppColors.borderOf(context),
                      ),
                    ),
                    child: InkWell(
                      customBorder: const StadiumBorder(),
                      onTap: () => setState(() => _selectedDay = d),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Text(
                          d,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected ? onAccent : muted,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: slots.isEmpty
                  ? const EmptyState(
                      icon: Icons.event_available_outlined,
                      title: 'No periods',
                      message: 'No periods on this day for your class.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                      itemCount: slots.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final s = slots[i];
                        return SoftCard(
                          accentLeft: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s.startTime} – ${s.endTime}',
                                style: GoogleFonts.inter(
                                  color: muted,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.subject,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: navy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${s.yearSection} · ${s.room} · ${s.faculty}',
                                style: GoogleFonts.inter(
                                  color: muted,
                                  fontSize: 13,
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
