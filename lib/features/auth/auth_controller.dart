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
  final String demoName;
  final bool initialized;

  bool get hasCollege => collegeCode.isNotEmpty;

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
    final roleName = prefs.getString(_kRole) ?? UserRole.student.name;
    final college = prefs.getString(_kCollege) ?? '';
    final collegeName = prefs.getString(_kCollegeName) ?? '';
    final demoName = prefs.getString(_kDemoName) ?? '';
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleName,
      orElse: () => UserRole.student,
    );
    state = AuthState(
      isLoggedIn: loggedIn,
      role: role,
      collegeCode: college,
      collegeName: collegeName,
      demoName: demoName,
      initialized: true,
    );
  }

  Future<void> selectCollege(CollegeInfo college) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCollege, college.code);
    await prefs.setString(_kCollegeName, college.name);
    state = state.copyWith(
      collegeCode: college.code,
      collegeName: college.name,
    );
  }

  Future<void> clearCollege() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCollege);
    await prefs.remove(_kCollegeName);
    state = state.copyWith(collegeCode: '', collegeName: '');
  }

  Future<void> login({
    required UserRole role,
    String? collegeCode,
    String? collegeName,
    String? demoName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final code = collegeCode ?? state.collegeCode;
    final name = collegeName ?? state.collegeName;
    final display = demoName ??
        (role == UserRole.student ? MockData.student.name : role.label);
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kRole, role.name);
    await prefs.setString(_kCollege, code);
    await prefs.setString(_kCollegeName, name);
    await prefs.setString(_kDemoName, display);
    state = AuthState(
      isLoggedIn: true,
      role: role,
      collegeCode: code,
      collegeName: name,
      demoName: display,
      initialized: true,
    );
  }

  Future<void> loginAsDemo(DemoRoleProfile profile) async {
    await login(
      role: profile.role,
      demoName: profile.name,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kDemoName);
    state = state.copyWith(isLoggedIn: false, demoName: '');
  }

  Future<void> resetDemoData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const AuthState(initialized: true);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
