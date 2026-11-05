import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';
import 'notes_controller.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _text = TextEditingController();
  late DateTime _date;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2029, 12, 31),
    );
    if (picked != null) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _save() async {
    final text = _text.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Write a note, then tap Save.');
      return;
    }
    await ref.read(notesProvider.notifier).save(text, _date);
    if (!mounted) return;
    setState(() {
      _text.clear();
      _error = null;
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saved for ${DateFormat('d MMM yyyy').format(_date)}. It is on your calendar.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final df = DateFormat('d MMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Notes & reminders',
              subtitle: 'Write a note, pick a date, then save it',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _text,
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: 'Write a reminder…',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                          ),
                          onChanged: (_) {
                            if (_error != null) setState(() => _error = null);
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                            ),
                            label: Text(df.format(_date)),
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.danger,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (notes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: 48,
                            color: muted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No reminders yet',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Save a note with a date to see it here and on the calendar.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: muted),
                          ),
                        ],
                      ),
                    )
                  else
                    for (final note in notes) ...[
                      SoftCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.text,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: navy,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    df.format(note.date),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remove note',
                              onPressed: () => ref
                                  .read(notesProvider.notifier)
                                  .remove(note.id),
                              icon: Icon(Icons.close, color: muted, size: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: AppColors.scaffoldOf(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: FilledButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ),
        ),
      ),
    );
  }
}
