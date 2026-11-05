import 'package:cludcampus/app/app.dart';
import 'package:cludcampus/core/data/mock_data.dart';
import 'package:cludcampus/core/widgets/app_page_header.dart';
import 'package:cludcampus/features/college/college_screen.dart';
import 'package:cludcampus/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  void usePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  test('low attendance mocks sit under the ANU line', () {
    expect(MockData.lowAttendance, isNotEmpty);
    expect(MockData.facultyOnLeave, isNotEmpty);
    for (final student in MockData.lowAttendance) {
      expect(student.percent, lessThan(75), reason: student.name);
      expect(student.present, lessThan(student.total));
    }
  });

  testWidgets('College shows this campus only and pins the back control', (
    tester,
  ) async {
    usePhone(tester);
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CollegeScreen())),
    );
    await tester.pump();

    expect(find.text('Network'), findsNothing);
    expect(find.text('Campus profile'), findsOneWidget);
    expect(find.textContaining('Sri Venkateswara'), findsNothing);
    expect(find.textContaining('Andhra Loyola'), findsNothing);
    expect(find.textContaining('Maris Stella'), findsNothing);
    expect(find.textContaining('Onboarding'), findsNothing);
    expect(find.text('ASN Degree College, Tenali'), findsWidgets);
    expect(find.text('office@asndegreetenali.edu.in'), findsOneWidget);
    expect(find.textContaining('ASN-TNL'), findsOneWidget);

    final back = tester.getTopLeft(find.byTooltip('Back'));
    final title = tester.getTopLeft(find.text('College'));
    expect(back.dx, lessThan(12));
    expect(back.dx, lessThan(title.dx - 8));
    expect(back.dy, lessThan(title.dy));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a centered column cannot pull the back control inward', (
    tester,
  ) async {
    usePhone(tester);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              PageTitleBlock(
                title: 'College',
                subtitle: 'Campus profile',
                showBack: true,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    final back = tester.getTopLeft(find.byTooltip('Back'));
    final title = tester.getTopLeft(find.text('College'));
    expect(back.dx, lessThan(12));
    expect(back.dx, lessThan(title.dx - 8));
  });

  testWidgets(
    'principal and HOD review lists, without student attendance or fees',
    (tester) async {
      usePhone(tester);
      await tester.pumpWidget(const ProviderScope(child: CludCampusApp()));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 400));

      Future<void> signIn(String mobile, String otp) async {
        await tester.enterText(find.byType(TextField).at(0), mobile);
        await tester.tap(find.text('Send OTP'));
        await tester.pump();
        await tester.enterText(find.byType(TextField).at(1), otp);
        await tester.tap(find.text('Verify & continue'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
      }

      List<String> tabLabels() {
        final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
        return [
          for (final dest in bar.destinations)
            (dest as NavigationDestination).label,
        ];
      }

      Finder homeText(String text) => find.descendant(
        of: find.byType(HomeScreen),
        matching: find.text(text),
      );

      Future<void> logout() async {
        await tester.tap(find.text('More'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.scrollUntilVisible(
          find.text('Logout'),
          200,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.tap(find.text('Logout'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Login with OTP'), findsOneWidget);
      }

      await signIn('9876504001', '040001');
      expect(tabLabels(), isNot(contains('Attendance')));
      expect(
        tabLabels(),
        containsAll(['Home', 'Timetable', 'Notices', 'More']),
      );
      expect(find.text('Pay now'), findsNothing);
      expect(find.text('Fee due'), findsNothing);
      expect(find.text('Overall attendance'), findsNothing);
      expect(find.text('Give class feedback'), findsNothing);
      expect(homeText('Low attendance'), findsOneWidget);
      expect(homeText('Faculty on leave'), findsOneWidget);
      expect(find.textContaining('Dr Ramchand Kolasani'), findsWidgets);
      expect(find.textContaining('Priya Venkata Lakshmi Reddy'), findsNothing);

      await tester.scrollUntilVisible(homeText('Low attendance'), 200);
      await tester.tap(homeText('Low attendance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Sravani K'), findsOneWidget);
      expect(find.text('Anitha P'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Rahul Varma'), 200);
      expect(find.text('Rahul Varma'), findsOneWidget);
      expect(find.text('Mohammed Imran'), findsOneWidget);
      expect(find.textContaining('short in'), findsWidgets);
      expect(find.text('Pay now'), findsNothing);
      expect(find.textContaining('Sri Venkateswara'), findsNothing);

      final listBack = tester.getTopLeft(find.byTooltip('Back'));
      expect(listBack.dx, lessThan(12));
      await tester.tap(find.byTooltip('Back'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await tester.scrollUntilVisible(homeText('Faculty on leave'), 200);
      await tester.tap(homeText('Faculty on leave'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Ms Divya Sri'), findsOneWidget);
      expect(find.text('Mrs Swathi Devi'), findsOneWidget);
      expect(find.text('Casual'), findsOneWidget);
      expect(find.text('Sick'), findsOneWidget);
      expect(find.text('Pay now'), findsNothing);
      await tester.tap(find.byTooltip('Back'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await logout();

      await signIn('9876503001', '030001');
      expect(tabLabels(), isNot(contains('Attendance')));
      expect(find.text('Pay now'), findsNothing);
      expect(find.text('Fee due'), findsNothing);
      expect(homeText('Low attendance'), findsOneWidget);
      expect(homeText('Faculty on leave'), findsOneWidget);
      expect(find.textContaining('Prof Lakshmi Narayana'), findsWidgets);

      await tester.tap(homeText('Faculty on leave'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Ms Divya Sri'), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await logout();

      await signIn('9876501001', '010001');
      expect(tabLabels(), contains('Attendance'));
      expect(find.text('Pay now'), findsOneWidget);
      expect(find.text('Fee due'), findsOneWidget);
      expect(homeText('Low attendance'), findsNothing);
      expect(homeText('Faculty on leave'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
