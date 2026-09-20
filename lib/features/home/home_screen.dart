import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/stat_card.dart';
import '../auth/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final student = MockData.student;
    final attendance = MockData.attendance;
    final today = MockData.todayClasses();
    final notices = MockData.notices.take(3).toList();
    final hour = DateTime.now().hour;
    final greet = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: AppColors.navy,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.navy,
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/branding/cludcampus-logo.png',
                          height: 28,
                          color: Colors.white,
                          colorBlendMode: BlendMode.srcATop,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            auth.role.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '$greet, ${student.name.split(' ').first}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student.branch} · ${student.year} · ${student.section}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Attendance',
                        value:
                            '${attendance.overallPercent.toStringAsFixed(1)}%',
                        subtitle:
                            '${attendance.overallPresent}/${attendance.overallTotal} classes',
                        color: attendance.overallPercent >= 75
                            ? AppColors.success
                            : AppColors.warning,
                        icon: Icons.fact_check_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'Today',
                        value: '${today.length}',
                        subtitle: today.isEmpty ? 'No classes' : 'classes',
                        color: AppColors.accent,
                        icon: Icons.schedule_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: "Today's classes",
                  actionLabel: 'Timetable',
                  onAction: () => context.go('/timetable'),
                ),
                if (today.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No classes scheduled for ${DateFormat('EEEE').format(DateTime.now())}. Enjoy the break!',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ...today.map((c) => _ClassTile(slot: c)),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Quick actions',
                ),
                _QuickActions(),
                const SizedBox(height: 24),
                SectionHeader(
                  title: 'Notices',
                  actionLabel: 'See all',
                  onAction: () => context.push('/notices'),
                ),
                ...notices.map(
                  (n) => _NoticePreview(
                    notice: n,
                    onTap: () => context.push('/notices/${n.id}'),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassTile extends StatelessWidget {
  const _ClassTile({required this.slot});
  final ClassSlot slot;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 52,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slot.startTime,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
              Text(
                slot.endTime,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        title: Text(
          slot.subject,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text('${slot.faculty} · ${slot.room}'),
        trailing: Chip(label: Text(slot.code)),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.payments_outlined, 'Fees', '/fees'),
      (Icons.campaign_outlined, 'Notices', '/notices'),
      (Icons.psychology_outlined, 'Friday Skill', '/friday-skill'),
      (Icons.event_busy_outlined, 'Leave', '/leave'),
      (Icons.emoji_events_outlined, 'Awards', '/awards'),
      (Icons.person_outline, 'Profile', '/profile'),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.05,
      children: items
          .map(
            (e) => InkWell(
              onTap: () => context.push(e.$3),
              borderRadius: BorderRadius.circular(16),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(e.$1, color: AppColors.accent, size: 26),
                    const SizedBox(height: 8),
                    Text(
                      e.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _NoticePreview extends StatelessWidget {
  const _NoticePreview({required this.notice, required this.onTap});
  final Notice notice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        title: Text(
          notice.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${notice.category} · ${DateFormat('d MMM').format(notice.postedAt)}',
        ),
        trailing: notice.pinned
            ? const Icon(Icons.push_pin, size: 16, color: AppColors.accent)
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
