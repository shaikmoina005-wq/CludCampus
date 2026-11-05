import '../../core/data/mock_data.dart';
import 'auth_messages.dart';
import 'phone_auth_client.dart';

/// Debug-only stand-in. Checks the roster `otp` field. Never used for Play builds.
class MockRosterPhoneAuthClient implements PhoneAuthClient {
  const MockRosterPhoneAuthClient();

  @override
  bool get isConfigured => true;

  @override
  Future<PhoneCodeDispatch> sendCode({
    required String e164,
    int? forceResendingToken,
  }) async {
    return PhoneCodeDispatch.sent(verificationId: 'mock:$e164', resendToken: 1);
  }

  @override
  Future<void> confirmCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final e164 = verificationId.startsWith('mock:')
        ? verificationId.substring(5)
        : verificationId;
    final profile = MockData.profileForMobile(e164);
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
