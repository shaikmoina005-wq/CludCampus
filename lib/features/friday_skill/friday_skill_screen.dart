import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class FridaySkillScreen extends StatefulWidget {
  const FridaySkillScreen({super.key});

  @override
  State<FridaySkillScreen> createState() => _FridaySkillScreenState();
}

class _FridaySkillScreenState extends State<FridaySkillScreen> {
  late List<DebateTopic> _topics;
  String? _votedId;

  @override
  void initState() {
    super.initState();
    _topics = List.of(MockData.debateTopics);
  }

  void _vote(DebateTopic topic) {
    if (topic.closed || topic.isFull) return;
    if (_votedId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already used your vote this Friday')),
      );
      return;
    }
    setState(() {
      _votedId = topic.id;
      _topics = [
        for (final t in _topics)
          if (t.id == topic.id)
            DebateTopic(
              id: t.id,
              title: t.title,
              description: t.description,
              votes: t.votes + 1,
              capacity: t.capacity,
              closed: t.closed || t.votes + 1 >= t.capacity,
            )
          else
            t,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Friday Skill',
              subtitle: 'Friday debate topics and Spotlight Hour',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    accentLeft: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MockData.fridaySkillTime,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.brandBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          MockData.fridaySkillTitle,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${MockData.fridayPresentCount} present · 4 topics · 10 votes each',
                          style: GoogleFonts.inter(color: muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final t in _topics)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SoftCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    t.title,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: navy,
                                    ),
                                  ),
                                ),
                                if (t.closed || t.isFull)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkElevated
                                          : AppColors.elevated,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'CLOSED',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: muted,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              t.description,
                              style: GoogleFonts.inter(color: muted, height: 1.4),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: t.votes / t.capacity,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.brandBlue,
                              backgroundColor: isDark
                                  ? AppColors.darkElevated
                                  : AppColors.elevated,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '${t.votes}/${t.capacity} votes',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: muted,
                                  ),
                                ),
                                const Spacer(),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(84, 40),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: (t.closed || t.isFull)
                                      ? null
                                      : () => _vote(t),
                                  child: Text(
                                    _votedId == t.id ? 'Voted' : 'Vote',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
