import 'auth_messages.dart';

/// Failure from the phone-auth client. UI copy is already chosen.
class PhoneAuthFailure implements Exception {
  const PhoneAuthFailure({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() => 'PhoneAuthFailure($code): $message';
}

/// Result of asking the SMS provider to send a code.
class PhoneCodeDispatch {
  const PhoneCodeDispatch.sent({required this.verificationId, this.resendToken})
    : autoVerified = false;

  /// Android sometimes reads the SMS itself and signs in with no typed code.
  const PhoneCodeDispatch.autoVerified()
    : autoVerified = true,
      verificationId = '',
      resendToken = null;

  final bool autoVerified;
  final String verificationId;
  final int? resendToken;
}

/// Sends and checks an SMS code. Firebase is one implementation; tests use another.
abstract class PhoneAuthClient {
  /// False when this build must not call the network SMS provider.
  bool get isConfigured;

  Future<PhoneCodeDispatch> sendCode({
    required String e164,
    int? forceResendingToken,
  });

  Future<void> confirmCode({
    required String verificationId,
    required String smsCode,
  });

  Future<void> signOut();
}

/// Used when `main` has not installed Firebase and tests have not installed a fake.
class UnconfiguredPhoneAuthClient implements PhoneAuthClient {
  const UnconfiguredPhoneAuthClient();

  @override
  bool get isConfigured => false;

  @override
  Future<PhoneCodeDispatch> sendCode({
    required String e164,
    int? forceResendingToken,
  }) {
    throw const PhoneAuthFailure(
      code: 'not-configured',
      message: AuthMessages.firebaseNotConfigured,
    );
  }

  @override
  Future<void> confirmCode({
    required String verificationId,
    required String smsCode,
  }) {
    throw const PhoneAuthFailure(
      code: 'not-configured',
      message: AuthMessages.firebaseNotConfigured,
    );
  }

  @override
  Future<void> signOut() async {}
}
