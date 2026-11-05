import 'package:flutter/foundation.dart';

/// Debug-only roster OTP. Release, profile, and Play builds ignore this.
///
/// ```bash
/// flutter run --dart-define=CLUDCAMPUS_MOCK_OTP=true
/// ```
///
/// The fallback also requires the committed Firebase options to still be the
/// placeholder. A real `lib/firebase_options.dart` always uses Firebase SMS.
const bool kMockOtpCompileFlag = bool.fromEnvironment('CLUDCAMPUS_MOCK_OTP');

/// True only for a debug process that was started with [kMockOtpCompileFlag].
bool get mockOtpFallbackAllowed => kDebugMode && kMockOtpCompileFlag;
