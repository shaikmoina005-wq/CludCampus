import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  late List<LeaveRequest> _leaves;
  final _reasonCtrl = TextEditingController();
  String _type = 'Personal';
  DateTime? _from;
  DateTime? _to;
  static const _types = ['Casual', 'Sick', 'Personal', 'On duty', 'Earned'];

  @override
  void initState() {
    super.initState();
    _leaves = List.of(MockData.leaves);
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Approved':
        return AppColors.success;
      case 'Rejected':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime(2026, 9, 21);
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2027, 12, 31),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
        if (_to != null && _to!.isBefore(picked)) _to = picked;
      } else {
        _to = picked;
      }
    });
  }

  void _submit() {
    if (_from == null || _to == null || _reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill dates and reason')),
      );
      return;
    }
    setState(() {
      _leaves.insert(
        0,
        LeaveRequest(
          id: 'l${_leaves.length + 1}',
          from: _from!,
          to: _to!,
          reason: _reasonCtrl.text.trim(),
          type: _type,
          status: 'Pending',
          appliedOn: DateTime(2026, 9, 21),
        ),
      );
      _reasonCtrl.clear();
      _from = null;
      _to = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Leave request submitted (demo)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM yyyy');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Leave requests',
              subtitle: 'Apply and track',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _type,
                          decoration: const InputDecoration(labelText: 'Type'),
                          items: [
                            for (final t in _types)
                              DropdownMenuItem(value: t, child: Text(t)),
                          ],
                          onChanged: (v) => setState(() => _type = v ?? 'Personal'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pickDate(isFrom: true),
                                child: Text(
                                  _from == null ? 'From' : df.format(_from!),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _pickDate(isFrom: false),
                                child: Text(
                                  _to == null ? 'To' : df.format(_to!),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _reasonCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Reason',
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _submit,
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'History',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final l in _leaves)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SoftCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l.type} · ${df.format(l.from)}'
                                    '${l.from == l.to ? '' : ' – ${df.format(l.to)}'}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: navy,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    l.reason,
                                    style: GoogleFonts.inter(color: muted),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(l.status).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l.status,
                                style: GoogleFonts.inter(
                                  color: _statusColor(l.status),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
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
