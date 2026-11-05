import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import 'auth_flags.dart';
import 'auth_messages.dart';
import 'mock_phone_auth_client.dart';
import 'phone_auth_client.dart';
import 'phone_number.dart';

/// Installed from `main`. Tests override this. The default never sends SMS
/// and never accepts a roster code.
final phoneAuthClientProvider = Provider<PhoneAuthClient>(
  (ref) => const UnconfiguredPhoneAuthClient(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    phoneAuth: ref.watch(phoneAuthClientProvider),
    allowMockFallback: mockOtpFallbackAllowed,
  );
});

enum OtpBackend { firebase, mock }

enum OtpRejection { invalidNumber, notEnrolled, notConfigured, failed }

class OtpSession {
  const OtpSession({
    required this.e164,
    required this.verificationId,
    required this.backend,
    this.resendToken,
  });

  final String e164;
  final String verificationId;
  final OtpBackend backend;
  final int? resendToken;
}

sealed class OtpRequestResult {
  const OtpRequestResult();
}

class OtpCodeSent extends OtpRequestResult {
  const OtpCodeSent(this.session);

  final OtpSession session;
}

class OtpAutoSignedIn extends OtpRequestResult {
  const OtpAutoSignedIn(this.profile);

  final DemoRoleProfile profile;
}

class OtpRequestRejected extends OtpRequestResult {
  const OtpRequestRejected(this.reason, this.message);

  final OtpRejection reason;
  final String message;
}

sealed class OtpVerifyResult {
  const OtpVerifyResult();
}

class OtpVerified extends OtpVerifyResult {
  const OtpVerified(this.profile);

  final DemoRoleProfile profile;
}

class OtpVerifyRejected extends OtpVerifyResult {
  const OtpVerifyRejected(this.message);

  final String message;
}

/// Enrollment check, then Firebase SMS, then the enrolled person's profile.
///
/// Unknown numbers never reach [PhoneAuthClient.sendCode]. A wrong Firebase
/// code is not retried against the roster `otp` field. That field is only
/// read by [MockRosterPhoneAuthClient], and only when [allowMockFallback]
/// is on in a debug build whose Firebase options are still the placeholder.
class AuthRepository {
  AuthRepository({
    required this.phoneAuth,
    PhoneAuthClient? mockClient,
    this.allowMockFallback = false,
    bool? debugBuild,
    DemoRoleProfile? Function(String mobile)? enrollment,
  }) : _mockClient = mockClient ?? const MockRosterPhoneAuthClient(),
       _debugBuild = debugBuild ?? kDebugMode,
       _enrollment = enrollment ?? MockData.profileForMobile;

  final PhoneAuthClient phoneAuth;
  final PhoneAuthClient _mockClient;
  final bool allowMockFallback;
  final bool _debugBuild;
  final DemoRoleProfile? Function(String mobile) _enrollment;

  bool get _mockAllowed => allowMockFallback && _debugBuild;

  Future<OtpRequestResult> requestOtp(
    String rawMobile, {
    int? forceResendingToken,
  }) async {
    final e164 = indianE164(rawMobile);
    if (e164 == null) {
      return const OtpRequestRejected(
        OtpRejection.invalidNumber,
        AuthMessages.invalidMobile,
      );
    }
    final profile = _enrollment(e164);
    if (profile == null) {
      return const OtpRequestRejected(
        OtpRejection.notEnrolled,
        AuthMessages.notEnrolled,
      );
    }

    // Fakes report isConfigured themselves. The Firebase client reports false
    // while lib/firebase_options.dart is still the placeholder, so this does
    // not call verifyPhoneNumber for an unconfigured release build.
    if (!phoneAuth.isConfigured) {
      if (!_mockAllowed) {
        return const OtpRequestRejected(
          OtpRejection.notConfigured,
          AuthMessages.firebaseNotConfigured,
        );
      }
      debugPrint(
        'CludCampus: debug roster OTP is active because Firebase is not configured.',
      );
      return _dispatch(
        client: _mockClient,
        e164: e164,
        backend: OtpBackend.mock,
        profile: profile,
      );
    }

    return _dispatch(
      client: phoneAuth,
      e164: e164,
      backend: OtpBackend.firebase,
      profile: profile,
      forceResendingToken: forceResendingToken,
    );
  }

  Future<OtpRequestResult> _dispatch({
    required PhoneAuthClient client,
    required String e164,
    required OtpBackend backend,
    required DemoRoleProfile profile,
    int? forceResendingToken,
  }) async {
    try {
      final dispatch = await client.sendCode(
        e164: e164,
        forceResendingToken: forceResendingToken,
      );
      if (dispatch.autoVerified) {
        return OtpAutoSignedIn(profile);
      }
      if (dispatch.verificationId.isEmpty) {
        return const OtpRequestRejected(
          OtpRejection.failed,
          AuthMessages.sendFailed,
        );
      }
      return OtpCodeSent(
        OtpSession(
          e164: e164,
          verificationId: dispatch.verificationId,
          backend: backend,
          resendToken: dispatch.resendToken,
        ),
      );
    } on PhoneAuthFailure catch (error) {
      return OtpRequestRejected(OtpRejection.failed, error.message);
    }
  }

  Future<OtpVerifyResult> verifyOtp({
    required OtpSession session,
    required String code,
  }) async {
    final sms = code.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(sms)) {
      return const OtpVerifyRejected(AuthMessages.enterOtp);
    }
    final profile = _enrollment(session.e164);
    if (profile == null) {
      return const OtpVerifyRejected(AuthMessages.notEnrolled);
    }
    if (session.backend == OtpBackend.mock && !_mockAllowed) {
      return const OtpVerifyRejected(AuthMessages.firebaseNotConfigured);
    }

    final client = session.backend == OtpBackend.mock ? _mockClient : phoneAuth;
    try {
      await client.confirmCode(
        verificationId: session.verificationId,
        smsCode: sms,
      );
    } on PhoneAuthFailure catch (error) {
      if (error.code == 'invalid-verification-code') {
        return const OtpVerifyRejected(AuthMessages.wrongOtp);
      }
      if (error.code == 'session-expired' ||
          error.code == 'invalid-verification-id') {
        return const OtpVerifyRejected(AuthMessages.sessionExpired);
      }
      return OtpVerifyRejected(error.message);
    }
    return OtpVerified(profile);
  }
}
