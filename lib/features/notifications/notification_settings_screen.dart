import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/settings/notification_settings_controller.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(notificationSettingsProvider);
    final n = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Notification settings',
              subtitle: 'Push types and quiet hours',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  _ToggleCard(
                    title: 'Notices & circulars',
                    subtitle: 'Holidays, exams, staff leave',
                    value: s.notices,
                    onChanged: n.setNotices,
                  ),
                  _ToggleCard(
                    title: 'Attendance',
                    subtitle: 'Shortage and register updates',
                    value: s.attendance,
                    onChanged: n.setAttendance,
                  ),
                  _ToggleCard(
                    title: 'Fees',
                    subtitle: 'Due dates and receipts',
                    value: s.fees,
                    onChanged: n.setFees,
                  ),
                  _ToggleCard(
                    title: 'Recognition',
                    subtitle: 'Student of the Month and staff awards',
                    value: s.recognition,
                    onChanged: n.setRecognition,
                  ),
                  _ToggleCard(
                    title: 'Quiet hours',
                    subtitle: 'Mute non-urgent alerts 9:00 pm – 7:00 am',
                    value: s.quietHours,
                    onChanged: n.setQuietHours,
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

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final Future<void> Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(fontSize: 13, color: muted),
                  ),
                ],
              ),
            ),
            Switch(value: value, onChanged: (v) => onChanged(v)),
          ],
        ),
      ),
    );
  }
}
