import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/models.dart';

class NotesController extends Notifier<List<ReminderNote>> {
  static const _key = 'cc_notes';

  @override
  List<ReminderNote> build() {
    _hydrate();
    return const [];
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (state.isNotEmpty) return;
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is! List) return;
    state = [
      for (final item in decoded)
        if (item is Map)
          ReminderNote(
            id: '${item['id']}',
            text: '${item['text']}',
            date: DateTime.parse('${item['date']}'),
          ),
    ];
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = [
      for (final note in state)
        {
          'id': note.id,
          'text': note.text,
          'date': DateTime(note.date.year, note.date.month, note.date.day)
              .toIso8601String(),
        },
    ];
    await prefs.setString(_key, jsonEncode(payload));
  }

  Future<void> save(String text, DateTime date) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final note = ReminderNote(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: trimmed,
      date: DateTime(date.year, date.month, date.day),
    );
    state = [note, ...state];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = [for (final note in state) if (note.id != id) note];
    await _persist();
  }
}

final notesProvider =
    NotifierProvider<NotesController, List<ReminderNote>>(NotesController.new);

List<ReminderNote> notesOn(List<ReminderNote> notes, DateTime date) {
  return [
    for (final note in notes)
      if (note.date.year == date.year &&
          note.date.month == date.month &&
          note.date.day == date.day)
        note,
  ];
}
