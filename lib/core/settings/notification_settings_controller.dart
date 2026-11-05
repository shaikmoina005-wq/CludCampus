import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  const NotificationSettings({
    this.notices = true,
    this.attendance = true,
    this.fees = true,
    this.recognition = true,
    this.quietHours = false,
  });

  final bool notices;
  final bool attendance;
  final bool fees;
  final bool recognition;
  final bool quietHours;

  NotificationSettings copyWith({
    bool? notices,
    bool? attendance,
    bool? fees,
    bool? recognition,
    bool? quietHours,
  }) {
    return NotificationSettings(
      notices: notices ?? this.notices,
      attendance: attendance ?? this.attendance,
      fees: fees ?? this.fees,
      recognition: recognition ?? this.recognition,
      quietHours: quietHours ?? this.quietHours,
    );
  }
}

class NotificationSettingsController extends Notifier<NotificationSettings> {
  static const _kNotices = 'cc_notif_notices';
  static const _kAttendance = 'cc_notif_attendance';
  static const _kFees = 'cc_notif_fees';
  static const _kRecognition = 'cc_notif_recognition';
  static const _kQuiet = 'cc_notif_quiet';

  @override
  NotificationSettings build() {
    _hydrate();
    return const NotificationSettings();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      notices: prefs.getBool(_kNotices) ?? true,
      attendance: prefs.getBool(_kAttendance) ?? true,
      fees: prefs.getBool(_kFees) ?? true,
      recognition: prefs.getBool(_kRecognition) ?? true,
      quietHours: prefs.getBool(_kQuiet) ?? false,
    );
  }

  Future<void> setNotices(bool v) async {
    state = state.copyWith(notices: v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotices, v);
  }

  Future<void> setAttendance(bool v) async {
    state = state.copyWith(attendance: v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAttendance, v);
  }

  Future<void> setFees(bool v) async {
    state = state.copyWith(fees: v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kFees, v);
  }

  Future<void> setRecognition(bool v) async {
    state = state.copyWith(recognition: v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRecognition, v);
  }

  Future<void> setQuietHours(bool v) async {
    state = state.copyWith(quietHours: v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kQuiet, v);
  }

  Future<void> reset() async {
    state = const NotificationSettings();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kNotices);
    await prefs.remove(_kAttendance);
    await prefs.remove(_kFees);
    await prefs.remove(_kRecognition);
    await prefs.remove(_kQuiet);
  }
}

final notificationSettingsProvider = NotifierProvider<
    NotificationSettingsController, NotificationSettings>(
  NotificationSettingsController.new,
);
