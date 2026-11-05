import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';

class AuthState {
  const AuthState({
    this.isLoggedIn = false,
    this.role = UserRole.student,
    this.collegeCode = '',
    this.collegeName = '',
    this.demoName = '',
    this.initialized = false,
  });

  final bool isLoggedIn;
  final UserRole role;
  final String collegeCode;
  final String collegeName;

  /// Signed-in person. Campus screens still read this field.
  final String demoName;
  final bool initialized;

  AuthState copyWith({
    bool? isLoggedIn,
    UserRole? role,
    String? collegeCode,
    String? collegeName,
    String? demoName,
    bool? initialized,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      collegeCode: collegeCode ?? this.collegeCode,
      collegeName: collegeName ?? this.collegeName,
      demoName: demoName ?? this.demoName,
      initialized: initialized ?? this.initialized,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  static const _kLoggedIn = 'cc_logged_in';
  static const _kRole = 'cc_role';
  static const _kCollege = 'cc_college';
  static const _kCollegeName = 'cc_college_name';
  static const _kDemoName = 'cc_demo_name';

  /// Bumped on login and logout so a slow hydrate cannot overwrite them.
  int _session = 0;

  @override
  AuthState build() {
    _hydrate();
    return const AuthState();
  }

  Future<void> _hydrate() async {
    final session = ++_session;
    final prefs = await SharedPreferences.getInstance();
    if (session != _session) return;
    final loggedIn = prefs.getBool(_kLoggedIn) ?? false;
    if (!loggedIn) {
      state = const AuthState(initialized: true);
      return;
    }
    final roleName = prefs.getString(_kRole) ?? UserRole.student.name;
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleName,
      orElse: () => UserRole.student,
    );
    final college = prefs.getString(_kCollege) ?? MockData.asnCollege.code;
    final collegeName =
        prefs.getString(_kCollegeName) ?? MockData.asnCollege.name;
    final demoName = prefs.getString(_kDemoName) ?? '';
    state = AuthState(
      isLoggedIn: true,
      role: role,
      collegeCode: college,
      collegeName: collegeName,
      demoName: demoName,
      initialized: true,
    );
  }

  /// Opens the session for an enrolled student or staff profile.
  /// The mobile number has already selected this person and role.
  Future<void> loginAsEnrolled(DemoRoleProfile profile) async {
    _session++;
    final prefs = await SharedPreferences.getInstance();
    final college = MockData.asnCollege;
    final display = MockData.displayNameFor(profile);
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kRole, profile.role.name);
    await prefs.setString(_kCollege, college.code);
    await prefs.setString(_kCollegeName, college.name);
    await prefs.setString(_kDemoName, display);
    state = AuthState(
      isLoggedIn: true,
      role: profile.role,
      collegeCode: college.code,
      collegeName: college.name,
      demoName: display,
      initialized: true,
    );
  }

  Future<void> logout() async {
    _session++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kRole);
    await prefs.remove(_kCollege);
    await prefs.remove(_kCollegeName);
    await prefs.remove(_kDemoName);
    state = const AuthState(initialized: true);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
