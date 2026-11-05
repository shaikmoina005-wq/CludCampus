import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class StaffFeedbackScreen extends StatefulWidget {
  const StaffFeedbackScreen({super.key});

  @override
  State<StaffFeedbackScreen> createState() => _StaffFeedbackScreenState();
}

class _StaffFeedbackScreenState extends State<StaffFeedbackScreen> {
  String _subject = MockData.feedbackSubjects.first;
  int _rating = 0;
  bool _anonymous = true;
  bool _submitted = false;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a rating from 1 to 5')),
      );
      return;
    }
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted (demo)')),
    );
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
              title: 'Staff feedback',
              subtitle: 'Weekly class ratings',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This week’s class',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: _subject,
                          items: [
                            for (final s in MockData.feedbackSubjects)
                              DropdownMenuItem(value: s, child: Text(s)),
                          ],
                          onChanged: (v) =>
                              setState(() => _subject = v ?? _subject),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Rating',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (var i = 1; i <= 5; i++)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => setState(() => _rating = i),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _rating == i
                                          ? AppColors.primaryButton
                                          : (isDark
                                              ? AppColors.darkElevated
                                              : AppColors.elevated),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$i',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        color: _rating == i
                                            ? Colors.white
                                            : navy,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _comment,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Optional comment',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Abusive language is not allowed and may be flagged.',
                          style: GoogleFonts.inter(fontSize: 12, color: muted),
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _anonymous,
                          onChanged: (v) =>
                              setState(() => _anonymous = v ?? true),
                          title: Text(
                            'Submit anonymously',
                            style: GoogleFonts.inter(color: navy),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: _submit,
                          child: const Text('Submit'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text('Not now'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prior feedback',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Data Structures · 5/5',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Clear explanations and well-paced labs.',
                          style: GoogleFonts.inter(color: muted),
                        ),
                        if (_submitted) ...[
                          const SizedBox(height: 12),
                          Text(
                            '$_subject · $_rating/5 (just now)',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandBlue,
                            ),
                          ),
                        ],
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
