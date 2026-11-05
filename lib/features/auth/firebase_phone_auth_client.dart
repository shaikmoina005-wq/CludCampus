import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import 'auth_messages.dart';
import 'firebase_setup.dart';
import 'phone_auth_client.dart';

/// Firebase Phone Auth (`verifyPhoneNumber` + `PhoneAuthProvider.credential`).
class FirebasePhoneAuthClient implements PhoneAuthClient {
  @override
  bool get isConfigured => FirebaseSetup.isConfigured;

  /// No-op while [FirebaseSetup.isConfigured] is false, so a placeholder
  /// `google-services` file does not initialize a fake Firebase app.
  static Future<void> ensureInitialized() async {
    if (!FirebaseSetup.isConfigured) return;
    if (Firebase.apps.isNotEmpty) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> _ready() async {
    if (!isConfigured) {
      throw const PhoneAuthFailure(
        code: 'not-configured',
        message: AuthMessages.firebaseNotConfigured,
      );
    }
    await ensureInitialized();
  }

  @override
  Future<PhoneCodeDispatch> sendCode({
    required String e164,
    int? forceResendingToken,
  }) async {
    await _ready();
    final completer = Completer<PhoneCodeDispatch>();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: e164,
        timeout: const Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
        verificationCompleted: (credential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (!completer.isCompleted) {
              completer.complete(const PhoneCodeDispatch.autoVerified());
            }
          } catch (error) {
            if (!completer.isCompleted) {
              completer.completeError(_asFailure(error));
            }
          }
        },
        verificationFailed: (error) {
          if (!completer.isCompleted) {
            completer.completeError(_asFailure(error));
          }
        },
        codeSent: (verificationId, resendToken) {
          if (!completer.isCompleted) {
            completer.complete(
              PhoneCodeDispatch.sent(
                verificationId: verificationId,
                resendToken: resendToken,
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          if (!completer.isCompleted) {
            completer.complete(
              PhoneCodeDispatch.sent(verificationId: verificationId),
            );
          }
        },
      );
    } catch (error) {
      if (completer.isCompleted) return completer.future;
      throw _asFailure(error);
    }
    return completer.future;
  }

  @override
  Future<void> confirmCode({
    required String verificationId,
    required String smsCode,
  }) async {
    await _ready();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw _asFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    if (!isConfigured) return;
    try {
      if (Firebase.apps.isEmpty) return;
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Clearing the local campus session must still succeed.
    }
  }
}

PhoneAuthFailure _asFailure(Object error) {
  if (error is PhoneAuthFailure) return error;
  if (error is FirebaseAuthException) {
    return PhoneAuthFailure(
      code: error.code,
      message: firebasePhoneAuthMessage(error.code),
    );
  }
  return const PhoneAuthFailure(
    code: 'unknown',
    message: AuthMessages.sendFailed,
  );
}
