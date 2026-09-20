import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/data/mock_data.dart';
import '../auth/auth_controller.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = MockData.student;
    final items = <_MoreItem>[
      _MoreItem(Icons.payments_outlined, 'Fees', 'Dues & payment history', '/fees'),
      _MoreItem(Icons.campaign_outlined, 'Notices', 'Circulars & announcements', '/notices'),
      _MoreItem(Icons.psychology_outlined, 'Friday Skill', 'Skill sessions', '/friday-skill'),
      _MoreItem(Icons.event_busy_outlined, 'Leave', 'Apply & history', '/leave'),
      _MoreItem(Icons.emoji_events_outlined, 'Awards', 'Recognition & achievements', '/awards'),
      _MoreItem(Icons.person_outline, 'Profile', 'Student card & details', '/profile'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.navy,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Text(
                  student.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              title: Text(
                student.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                '${student.rollNo} · ${student.collegeCode}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: AppColors.accent),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(item.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(item.route),
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out of demo'),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${AppStrings.appName} MVP · mock data',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreItem {
  const _MoreItem(this.icon, this.title, this.subtitle, this.route);
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}
