import 'package:cludcampus/core/data/mock_data.dart';
import 'package:cludcampus/core/models/models.dart';
import 'package:cludcampus/features/auth/login_screen.dart';
import 'package:cludcampus/features/home/home_screen.dart';
import 'package:cludcampus/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/roster_phone_auth_fake.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('enrolled mobiles each map to one person, role, and OTP', () {
    expect(MockData.profileForMobile('9876543210'), isNull);
    expect(MockData.profileForMobile('9876504001')?.role, UserRole.principal);
    expect(
      MockData.profileForMobile('+91 98765 04001')?.name,
      'Dr Ramchand Kolasani',
    );
    expect(
      MockData.displayNameFor(MockData.profileForMobile('9876501001')!),
      'Priya Venkata Lakshmi Reddy',
    );

    final otps = MockData.demoRoles.map((role) => role.otp).toSet();
    expect(otps, hasLength(MockData.demoRoles.length));
    for (final profile in MockData.demoRoles) {
      expect(profile.otp, hasLength(6));
      expect(profile.acceptsOtp(profile.otp), isTrue);
      expect(profile.acceptsOtp('000000'), isFalse);
      expect(MockData.profileForMobile(profile.phone)?.role, profile.role);
    }
  });

  GoRouter harness() {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
        GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      ],
    );
  }

  Future<void> pumpLogin(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [rosterPhoneAuthOverride()],
        child: MaterialApp.router(routerConfig: harness()),
      ),
    );
    await tester.pump();
  }

  Future<void> signIn(WidgetTester tester, String mobile, String otp) async {
    await tester.enterText(find.byType(TextField).at(0), mobile);
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(1), otp);
    await tester.tap(find.text('Verify & continue'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('an unknown number is not enrolled and does not become Priya', (
    tester,
  ) async {
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextField).at(0), '9876543210');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    await tester.pump();

    expect(find.text('This mobile number is not enrolled.'), findsOneWidget);
    expect(find.text('Verify & continue'), findsNothing);
    expect(find.textContaining('Priya'), findsNothing);
    expect(find.text('Login with OTP'), findsOneWidget);
  });

  testWidgets('a known number rejects another role OTP', (tester) async {
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextField).at(0), '9876504001');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('040001'), findsNothing);
    await tester.enterText(find.byType(TextField).at(1), '010001');
    await tester.tap(find.text('Verify & continue'));
    await tester.pump();
    await tester.pump();

    expect(find.text('That OTP does not match this number.'), findsOneWidget);
    expect(find.text('Login with OTP'), findsOneWidget);
    expect(find.textContaining('Dr Ramchand'), findsNothing);
    expect(find.textContaining('Priya'), findsNothing);
  });

  testWidgets('each enrolled number opens that person and role', (
    tester,
  ) async {
    final cases = <(String, String, String, String, bool)>[
      (
        '9876501002',
        '010002',
        'Eshu Sahana',
        'B.Sc Computer Science · II Year',
        true,
      ),
      (
        '9876501001',
        '010001',
        'Priya Venkata Lakshmi Reddy',
        'B.Sc Computer Science · II Year',
        true,
      ),
      ('9876501011', '010011', 'Kiran Teja', 'B.C.A · III Year', true),
      (
        '9876502001',
        '020001',
        'Dr Ramesh Kumar',
        'Assistant Professor · Computer Science',
        false,
      ),
      (
        '9876503001',
        '030001',
        'Prof Lakshmi Narayana',
        'Head · Computer Science',
        false,
      ),
      (
        '9876504001',
        '040001',
        'Dr Ramchand Kolasani',
        'Principal · B.E, MS, M.Tech, Ph.D',
        false,
      ),
      (
        '9876505001',
        '050001',
        'College Office',
        'Administrative office',
        false,
      ),
    ];

    for (final item in cases) {
      final (mobile, otp, name, detail, studentHome) = item;
      SharedPreferences.setMockInitialValues({});
      await pumpLogin(tester);
      await signIn(tester, mobile, otp);

      expect(find.text('Login with OTP'), findsNothing, reason: name);
      expect(find.textContaining(name), findsWidgets, reason: name);
      expect(find.textContaining(detail), findsWidgets, reason: name);
      expect(tester.takeException(), isNull, reason: name);
      if (studentHome) {
        expect(find.text('Overall attendance'), findsOneWidget, reason: name);
        expect(find.text('Pay now'), findsOneWidget, reason: name);
      } else {
        expect(find.text('Overall attendance'), findsNothing, reason: name);
        expect(find.text('Pay now'), findsNothing, reason: name);
        expect(find.text('Give class feedback'), findsNothing, reason: name);
      }
      if (name != 'Priya Venkata Lakshmi Reddy') {
        expect(
          find.textContaining('Priya Venkata Lakshmi Reddy'),
          findsNothing,
          reason: name,
        );
      }
    }
  });

  testWidgets('principal login opens the principal profile, not Priya', (
    tester,
  ) async {
    await pumpLogin(tester);
    await signIn(tester, '9876504001', '040001');

    expect(find.text('Fee desk'), findsNothing);
    expect(find.text('Department teachers'), findsOneWidget);
    expect(find.text('Data Structures'), findsNothing);

    await tester.tap(find.text('RK'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Dr Ramchand Kolasani'), findsWidgets);
    expect(find.text('Principal'), findsWidgets);
    expect(find.text('+91 98765 04001'), findsOneWidget);
    expect(find.textContaining('Priya'), findsNothing);
    expect(find.textContaining('II Year A'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('faculty sees their own classes', (tester) async {
    await pumpLogin(tester);
    await signIn(tester, '9876502001', '020001');

    expect(find.text('Your timetable'), findsOneWidget);
    expect(find.text('Data Structures'), findsOneWidget);
    expect(find.text('DBMS'), findsNothing);
  });

  testWidgets('the office home uses the fee desk and leave screens', (
    tester,
  ) async {
    await pumpLogin(tester);
    await signIn(tester, '9876505001', '050001');

    expect(find.text('Fee desk'), findsOneWidget);
    expect(find.text('Leave requests'), findsOneWidget);
    expect(find.text('College profile'), findsOneWidget);
    expect(find.text('Today'), findsNothing);
  });

  testWidgets('a principal session is restored on the next launch', (
    tester,
  ) async {
    await pumpLogin(tester);
    await signIn(tester, '9876504001', '040001');
    expect(find.textContaining('Dr Ramchand Kolasani'), findsWidgets);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [rosterPhoneAuthOverride()],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Dr Ramchand Kolasani'), findsWidgets);
    expect(find.textContaining('Principal'), findsWidgets);
    expect(find.text('Pay now'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
