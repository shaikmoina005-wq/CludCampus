# CludCampus

Student-first college companion Android MVP for Indian degree campuses.

**Brand:** CludCampus only (never CampusOne)  
**Package / applicationId:** `com.cludcampus.app`  
**Stack:** Flutter 3.x · Material 3 · Riverpod · go_router · Google Fonts

## Features (demo / mock data)

- Splash → demo login with role picker (default **Student**)
- Bottom nav: **Home**, **Attendance**, **Timetable**, **More**
- Home: greeting, today’s classes, attendance summary, notices, quick actions
- Attendance: overall % + subject-wise with **ANU 75%** awareness
- Timetable: Today + Week tabs
- More / Home shortcuts: Fees, Notices (list + detail), Friday Skill, Leave (form + history), Awards, Profile

All data is **mock** — clearly labelled in-app. No backend.

## Run

```bash
# From project root
flutter pub get
flutter run   # Android device/emulator, or chrome/linux if available
```

Generate launcher icons (already configured):

```bash
dart run flutter_launcher_icons
```

## Demo login

1. Open the app → splash → login
2. Keep role **Student** (or pick Faculty / HOD / Principal / College Office)
3. College code default: `ASN-TENALI`
4. Roll / staff ID is ignored (demo) — tap **Continue to demo**

Session is stored locally via `shared_preferences`. Sign out from **More** or **Profile**.

## Project layout

```
lib/
  app/           # MaterialApp + go_router
  core/          # theme, colors, models, mock data, shared widgets
  features/      # auth, shell, home, attendance, timetable, fees, …
```

## Analyze

```bash
flutter analyze
```

## Note on Android SDK

This MVP targets Android. Building an APK requires a local Android SDK / emulator. `flutter analyze` validates Dart/Flutter code without a device.

## License

Private / proprietary — MyCampus (Play Console developer name).
