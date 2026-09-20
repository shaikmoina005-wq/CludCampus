import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';

class FridaySkillScreen extends StatelessWidget {
  const FridaySkillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = MockData.skills;
    return Scaffold(
      appBar: AppBar(title: const Text('Friday Skill')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.navy,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Weekly skill sessions for career readiness — soft skills, tools, and interview practice.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      height: 1.4,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...sessions.map(
            (s) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('EEE, d MMM').format(s.date)} · ${s.time}',
                      style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${s.trainer} · ${s.venue}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: s.tags.map((t) => Chip(label: Text(t))).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
