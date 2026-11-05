import 'package:cludcampus/core/data/india_public_holidays.dart';
import 'package:cludcampus/core/widgets/app_page_header.dart';
import 'package:cludcampus/features/calendar/calendar_screen.dart';
import 'package:cludcampus/features/home/home_screen.dart';
import 'package:cludcampus/features/notes/notes_screen.dart';
import 'package:cludcampus/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('bundled India holidays include the major festivals', () {
    String name(int year, int month, int day) =>
        IndiaPublicHolidays.namesOn(DateTime(year, month, day)).join(' ');

    expect(name(2026, 1, 26), contains('Republic Day'));
    expect(name(2026, 3, 4), contains('Holi'));
    expect(name(2026, 3, 21), contains('Eid'));
    expect(name(2026, 8, 15), contains('Independence Day'));
    expect(name(2026, 11, 8), contains('Diwali'));
    expect(name(2027, 1, 26), contains('Republic Day'));
    expect(IndiaPublicHolidays.all.length, greaterThan(80));
  });

  testWidgets('a long student name is shown in full', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );
    await tester.pump();

    const fullName = 'Priya Venkata Lakshmi Reddy';
    final matches = tester.widgetList<Text>(find.textContaining(fullName));
    expect(matches.length, greaterThan(1));
    for (final text in matches) {
      expect(text.softWrap, isTrue);
      expect(text.overflow, isNot(TextOverflow.ellipsis));
      expect(text.maxLines, isNull);
      expect(text.data, isNot('Priya'));
    }
    expect(find.textContaining('Good '), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ProfileScreen())),
    );
    await tester.pump();
    final profileNames = tester.widgetList<Text>(find.text(fullName));
    expect(profileNames.length, greaterThan(1));
    for (final text in profileNames) {
      expect(text.softWrap, isTrue);
      expect(text.overflow, isNot(TextOverflow.ellipsis));
      expect(text.maxLines, isNull);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('More-screen back control sits in the top-left corner', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PageTitleBlock(
            title: 'Friday Skill',
            subtitle: 'Friday debate topics and Spotlight Hour',
            showBack: true,
          ),
        ),
      ),
    );
    await tester.pump();

    final back = tester.getTopLeft(find.byTooltip('Back'));
    final title = tester.getTopLeft(find.text('Friday Skill'));
    expect(back.dx, lessThan(12));
    expect(back.dx, lessThan(title.dx - 8));
    expect(back.dy, lessThan(title.dy));
  });

  testWidgets('calendar opens on today and browses to a future festival', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CalendarScreen())),
    );
    await tester.pump();

    final today = DateTime.now();
    expect(find.textContaining('Regular classwork'), findsNothing);
    expect(
      find.text(DateFormat('EEE, d MMM yyyy').format(today)),
      findsOneWidget,
    );
    final holidayToday = IndiaPublicHolidays.namesOn(today);
    final closed = holidayToday.isNotEmpty ||
        today.weekday == DateTime.sunday ||
        (today.weekday == DateTime.saturday &&
            today.day >= 8 &&
            today.day <= 14);
    if (!closed) {
      expect(
        find.text('Regular lectures from your timetable.'),
        findsOneWidget,
      );
    }

    var cursor = DateTime(today.year, today.month, 1);
    var guard = 0;
    while (cursor.year != 2027 || cursor.month != 1) {
      final forward = cursor.isBefore(DateTime(2027, 1, 1));
      await tester.tap(
        find.byTooltip(forward ? 'Next month' : 'Previous month'),
      );
      await tester.pump();
      cursor = DateTime(cursor.year, cursor.month + (forward ? 1 : -1), 1);
      expect(guard++, lessThan(40));
    }
    await tester.tap(find.text('26'));
    await tester.pump();
    expect(find.textContaining('Republic Day'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving a dated note shows it again and on the calendar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    Future<void> show(Widget home) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: home),
        ),
      );
      await tester.pump();
    }

    await show(const NotesScreen());
    expect(find.text('Save'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Write a note, then tap Save.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'I want leave');
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('25').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('I want leave'), findsOneWidget);
    expect(find.textContaining('25'), findsWidgets);

    await show(const NotesScreen());
    expect(find.text('I want leave'), findsOneWidget);

    await show(const CalendarScreen());
    final saved = DateTime(DateTime.now().year, DateTime.now().month, 25);
    var cursor = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final target = DateTime(saved.year, saved.month, 1);
    var guard = 0;
    while (cursor.year != target.year || cursor.month != target.month) {
      final forward = cursor.isBefore(target);
      await tester.tap(
        find.byTooltip(forward ? 'Next month' : 'Previous month'),
      );
      await tester.pump();
      cursor = DateTime(cursor.year, cursor.month + (forward ? 1 : -1), 1);
      expect(guard++, lessThan(20));
    }
    await tester.tap(find.text('25'));
    await tester.pump();
    expect(find.text('I want leave'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
