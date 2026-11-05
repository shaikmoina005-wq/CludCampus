import 'package:cludcampus/app/app.dart';
import 'package:cludcampus/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpLogin(WidgetTester tester, GoRouter router) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pump();
  }

  GoRouter loginRouter() {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('Student home')),
        ),
      ],
    );
  }

  testWidgets('login shows mobile OTP and hides demo shortcuts', (
    tester,
  ) async {
    final router = loginRouter();
    await pumpLogin(tester, router);

    expect(find.text('Login with OTP'), findsOneWidget);
    expect(find.text('Mobile number'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Enter OTP'), findsOneWidget);
    expect(
      find.text('Use the mobile number your college registered for you.'),
      findsOneWidget,
    );

    const banned = [
      'Change college',
      'Register here',
      'New user?',
      'TRY A DEMO ROLE',
      'Students',
      'Eshu Sahana',
      'Priya Reddy',
      '123456',
      '010001',
      '040001',
      'Demo OTP',
      'demo OTP',
      'ASN Degree College',
      'Select your college',
    ];
    for (final label in banned) {
      expect(find.textContaining(label), findsNothing, reason: label);
    }
  });

  testWidgets('a 6-digit OTP opens the student home', (tester) async {
    final router = loginRouter();
    await pumpLogin(tester, router);

    await tester.enterText(find.byType(TextField).at(0), '9876501001');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();

    expect(find.textContaining('123456'), findsNothing);
    expect(find.textContaining('Demo'), findsNothing);
    expect(find.text('OTP sent to +91 98765 01001'), findsOneWidget);
    expect(find.text('Verify & continue'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), '010001');
    await tester.tap(find.text('Verify & continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Student home'), findsOneWidget);
    expect(find.text('Login with OTP'), findsNothing);
  });

  testWidgets('empty mobile stays on login', (tester) async {
    final router = loginRouter();
    await pumpLogin(tester, router);

    await tester.tap(find.text('Send OTP'));
    await tester.pump();

    expect(
      find.text('Enter the 10-digit mobile number your college registered.'),
      findsOneWidget,
    );
    expect(find.text('Verify & continue'), findsNothing);
    expect(find.text('Student home'), findsNothing);
  });

  testWidgets('splash opens the student login, then OTP reaches home', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CludCampusApp()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Login with OTP'), findsOneWidget);
    expect(find.text('Change college'), findsNothing);
    expect(find.textContaining('Register'), findsNothing);
    expect(find.textContaining('Eshu Sahana'), findsNothing);
    expect(find.textContaining('Priya Reddy'), findsNothing);
    expect(find.textContaining('Demo OTP'), findsNothing);
    expect(find.textContaining('TRY A DEMO'), findsNothing);
    expect(find.text('Select your college to continue.'), findsNothing);

    await tester.enterText(find.byType(TextField).at(0), '9876501001');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    expect(find.text('OTP sent to +91 98765 01001'), findsOneWidget);
    expect(find.textContaining('123456'), findsNothing);

    await tester.enterText(find.byType(TextField).at(1), '010001');
    await tester.tap(find.text('Verify & continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Login with OTP'), findsNothing);
    expect(find.textContaining('Good '), findsWidgets);
    expect(find.text('Change college'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('More'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.scrollUntilVisible(find.text('Logout'), 200);
    await tester.tap(find.text('Logout'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Login with OTP'), findsOneWidget);
    expect(find.text('Change college'), findsNothing);
    expect(find.textContaining('Select your college'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
