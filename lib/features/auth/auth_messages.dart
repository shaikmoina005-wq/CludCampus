/// Copy shown on the mobile OTP screen. No code, role, or roster hint.
class AuthMessages {
  const AuthMessages._();

  static const invalidMobile =
      'Enter the 10-digit mobile number your college registered.';
  static const notEnrolled = 'This mobile number is not enrolled.';
  static const sendFirst = 'Send an OTP to this mobile number first.';
  static const enterOtp = 'Enter the 6-digit OTP sent to your mobile.';
  static const wrongOtp = 'That OTP does not match this number.';
  static const sessionExpired =
      'That code expired. Send a new OTP and try again.';
  static const tooManyRequests =
      'Too many attempts. Wait a few minutes and try again.';
  static const smsQuota =
      'Firebase SMS quota is used up. Enable billing for Phone Auth, then try again.';
  static const missingSha =
      'This build is not registered for SMS sign-in. Add the app SHA-1 and SHA-256 in the Firebase Console.';
  static const network =
      'No network connection. Check the connection and try again.';
  static const phoneProviderOff =
      'Phone sign-in is turned off in Firebase. Enable the Phone provider and rebuild.';
  static const sendFailed = 'Could not send the SMS code. Try again.';
  static const firebaseNotConfigured =
      'Phone sign-in is not set up yet. Add the Firebase Android config for com.cludcampus.app and rebuild.';
}

/// User-facing text for a Firebase Auth error code. Unknown codes stay generic.
String firebasePhoneAuthMessage(String code) {
  switch (code) {
    case 'invalid-verification-code':
      return AuthMessages.wrongOtp;
    case 'invalid-verification-id':
    case 'session-expired':
      return AuthMessages.sessionExpired;
    case 'invalid-phone-number':
      return AuthMessages.invalidMobile;
    case 'too-many-requests':
      return AuthMessages.tooManyRequests;
    case 'quota-exceeded':
      return AuthMessages.smsQuota;
    case 'missing-client-identifier':
    case 'app-not-authorized':
    case 'invalid-app-credential':
    case 'invalid-cert-hash':
      return AuthMessages.missingSha;
    case 'network-request-failed':
      return AuthMessages.network;
    case 'operation-not-allowed':
      return AuthMessages.phoneProviderOff;
    default:
      return AuthMessages.sendFailed;
  }
}
