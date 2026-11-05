import 'package:cludcampus/core/data/mock_data.dart';
import 'package:cludcampus/features/auth/auth_messages.dart';
import 'package:cludcampus/features/auth/auth_repository.dart';
import 'package:cludcampus/features/auth/phone_auth_client.dart';

/// Test double for Firebase Phone Auth.
///
/// The code it accepts is the roster `otp` so widget tests can open each
/// role without SMS. Production does not do this: a configured Firebase
/// client never consults that field.
class RosterPhoneAuthFake implements PhoneAuthClient {
  @override
  bool get isConfigured => true;

  @override
  Future<PhoneCodeDispatch> sendCode({
    required String e164,
    int? forceResendingToken,
  }) async {
    return PhoneCodeDispatch.sent(verificationId: e164, resendToken: 1);
  }

  @override
  Future<void> confirmCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final profile = MockData.profileForMobile(verificationId);
    if (profile == null || !profile.acceptsOtp(smsCode)) {
      throw const PhoneAuthFailure(
        code: 'invalid-verification-code',
        message: AuthMessages.wrongOtp,
      );
    }
  }

  @override
  Future<void> signOut() async {}
}

/// Riverpod 3 does not export the override type. `dynamic` still assigns to
/// `ProviderScope.overrides`.
dynamic rosterPhoneAuthOverride() {
  return phoneAuthClientProvider.overrideWithValue(RosterPhoneAuthFake());
}
