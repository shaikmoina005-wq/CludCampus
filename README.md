# CludCampus

Student-first college companion Android MVP for Indian degree campuses.

**Brand:** CludCampus only (never CampusOne)  
**Package / applicationId:** `com.cludcampus.app`  
**Stack:** Flutter 3.x · Material 3 · Riverpod · go_router · Google Fonts

## Features (demo / mock campus data)

- Splash → mobile number + OTP login (no role cards, college picker, or register link)
- Enrolled numbers only. Unknown numbers stay on login and are not sent to Firebase
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

## Login

The screen asks for an Indian mobile and a 6-digit SMS code. It does not list roles or codes.

1. The number is normalized to E.164 (`+91` + 10 digits).
2. It must match an enrolled person in `MockData.demoRoles`. Otherwise the app stays on login with "This mobile number is not enrolled." and does not call Firebase.
3. An enrolled number goes through Firebase Phone Auth (`verifyPhoneNumber`, then `PhoneAuthProvider.credential`).
4. A correct code opens that person’s existing role session (student, faculty, HOD, principal, or college office). A wrong code shows an error and is not checked against the old on-device codes.
5. The session is still stored with `shared_preferences`. Sign out from **More** or **Profile** also signs out of Firebase.

Campus data is still local mock data. There is no college backend. The roster is only the list of mobiles allowed to receive an OTP.

### Debug roster OTP (not for Play)

Release and profile builds never accept the `otp` field on `DemoRoleProfile`.

A debug build can use those codes only when Firebase is still the placeholder below **and** you pass:

```bash
flutter run --dart-define=CLUDCAMPUS_MOCK_OTP=true
```

`CLUDCAMPUS_MOCK_OTP` is ignored when `kDebugMode` is false, and it is ignored once `lib/firebase_options.dart` points at a real project. Play builds must not rely on it.

## Firebase Phone Auth

`firebase_core` 5.1.x and `firebase_auth` 7.0.x. Android package: `com.cludcampus.app`.

The files in git are **placeholders**, not a live Firebase project:

| File | Placeholder |
| --- | --- |
| `android/app/google-services.json` | `project_id` `placeholder-cludcampus`, API key `REPLACE_ME` |
| `lib/firebase_options.dart` | same project id and API key |

Until both are replaced together, the app does not call Firebase. Release builds show “Phone sign-in is not set up yet…” instead of accepting a roster code.

`firebase_auth` 7 requires Android `minSdk` 24. The app module uses `maxOf(flutter.minSdkVersion, 24)`.

### Console checklist

1. Create or open a Firebase project. Do not keep the id `placeholder-cludcampus`.
2. Authentication → Sign-in method → enable **Phone**.
3. Upgrade the project to the **Blaze** plan if Phone Auth asks for billing. Production SMS beyond the free test numbers requires it.
4. Add an Android app with package name `com.cludcampus.app`.
5. Add SHA-1 and SHA-256 fingerprints, then download a new `google-services.json` if you add them later:
   - **Debug** (`flutter run`):

     ```bash
     keytool -list -v \
       -alias androiddebugkey \
       -keystore ~/.android/debug.keystore \
       -storepass android \
       -keypass android
     ```

   - **Play upload key** SHA-256 (add the matching SHA-1 from Play Console as well):

     `EA:45:BF:D0:91:2F:3D:DD:0D:DD:80:8B:69:67:5D:54:CD:33:81:4E:29:37:93:C6:B2:CF:48:8A:E0:5F:A1:5D`

   - **Play app signing key**: Play Console → Test and release → App integrity → App signing. Installs from Play are signed with this key, so Phone Auth needs its SHA-1 and SHA-256 in addition to the upload key.
6. Replace `android/app/google-services.json` with the file from the console (package `com.cludcampus.app`).
7. Replace `lib/firebase_options.dart` with the same Android app. From the project root, after the FlutterFire CLI is installed:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   The app treats project id `placeholder-cludcampus` as not configured. Replacing only the JSON is not enough.
8. Optional while developing: Authentication → Phone → **Phone numbers for testing**. Add the enrolled E.164 number and a 6-digit code. Firebase will not send a real SMS for that pair. The app still checks enrollment first, and once Firebase is configured it accepts only the Firebase code, not the roster `otp` field.
9. Before pointing this at real people, replace the demo mobiles in `MockData.demoRoles` with numbers you control. Those demo numbers are the only ones allowed to start an SMS.

Rebuild after the config change. A Play App Bundle is a release build: it uses Firebase and ignores `CLUDCAMPUS_MOCK_OTP`.

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
