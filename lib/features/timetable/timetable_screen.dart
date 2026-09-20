import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/empty_state.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    final today = MockData.weekdayShort(DateTime.now());
    final idx = _days.indexOf(today).clamp(0, _days.length - 1);
    _tabs = TabController(length: 2, vsync: this);
    _selectedDay = _days[idx];
  }

  late String _selectedDay;

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<ClassSlot> _forDay(String day) =>
      MockData.timetable.where((c) => c.day == day).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Week'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _DayList(slots: MockData.todayClasses()),
          Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  itemCount: _days.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final d = _days[i];
                    final selected = d == _selectedDay;
                    return ChoiceChip(
                      label: Text(d),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedDay = d),
                      selectedColor: AppColors.accent.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: selected ? AppColors.accent : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              Expanded(child: _DayList(slots: _forDay(_selectedDay))),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayList extends StatelessWidget {
  const _DayList({required this.slots});
  final List<ClassSlot> slots;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const EmptyState(
        icon: Icons.event_available_outlined,
        title: 'No classes',
        message: 'Nothing scheduled for this day.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: slots.length,
      itemBuilder: (context, i) {
        final s = slots[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${s.startTime} – ${s.endTime}',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.subject,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${s.faculty} · Room ${s.room} · ${s.code}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
