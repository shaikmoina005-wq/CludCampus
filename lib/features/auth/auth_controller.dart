import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/models.dart';

class AuthState {
  const AuthState({
    this.isLoggedIn = false,
    this.role = UserRole.student,
    this.collegeCode = 'ASN-TENALI',
    this.initialized = false,
  });

  final bool isLoggedIn;
  final UserRole role;
  final String collegeCode;
  final bool initialized;

  AuthState copyWith({
    bool? isLoggedIn,
    UserRole? role,
    String? collegeCode,
    bool? initialized,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      collegeCode: collegeCode ?? this.collegeCode,
      initialized: initialized ?? this.initialized,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  static const _kLoggedIn = 'cc_logged_in';
  static const _kRole = 'cc_role';
  static const _kCollege = 'cc_college';

  @override
  AuthState build() {
    _hydrate();
    return const AuthState();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_kLoggedIn) ?? false;
    final roleName = prefs.getString(_kRole) ?? UserRole.student.name;
    final college = prefs.getString(_kCollege) ?? 'ASN-TENALI';
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleName,
      orElse: () => UserRole.student,
    );
    state = AuthState(
      isLoggedIn: loggedIn,
      role: role,
      collegeCode: college,
      initialized: true,
    );
  }

  Future<void> login({
    required UserRole role,
    required String collegeCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kRole, role.name);
    await prefs.setString(_kCollege, collegeCode);
    state = AuthState(
      isLoggedIn: true,
      role: role,
      collegeCode: collegeCode,
      initialized: true,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    state = state.copyWith(isLoggedIn: false);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
