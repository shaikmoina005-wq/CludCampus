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

  /// Signed-in student name. Campus screens still read this field.
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

  @override
  AuthState build() {
    _hydrate();
    return const AuthState();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_kLoggedIn) ?? false;
    if (!loggedIn) {
      state = const AuthState(initialized: true);
      return;
    }
    final student = MockData.student;
    await prefs.setString(_kRole, UserRole.student.name);
    await prefs.setString(_kCollege, student.collegeCode);
    await prefs.setString(_kCollegeName, student.college);
    await prefs.setString(_kDemoName, student.name);
    state = AuthState(
      isLoggedIn: true,
      role: UserRole.student,
      collegeCode: student.collegeCode,
      collegeName: student.college,
      demoName: student.name,
      initialized: true,
    );
  }

  /// Opens the enrolled student's session. The college is taken from that
  /// record — the student does not pick a campus or a role.
  Future<void> loginStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final student = MockData.student;
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kRole, UserRole.student.name);
    await prefs.setString(_kCollege, student.collegeCode);
    await prefs.setString(_kCollegeName, student.college);
    await prefs.setString(_kDemoName, student.name);
    state = AuthState(
      isLoggedIn: true,
      role: UserRole.student,
      collegeCode: student.collegeCode,
      collegeName: student.college,
      demoName: student.name,
      initialized: true,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kRole);
    await prefs.remove(_kCollege);
    await prefs.remove(_kCollegeName);
    await prefs.remove(_kDemoName);
    state = const AuthState(initialized: true);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
