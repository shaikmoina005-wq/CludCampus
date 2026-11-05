import 'dart:convert';
import 'dart:io';

import 'package:cludcampus/core/data/mock_data.dart';
import 'package:cludcampus/core/models/models.dart';
import 'package:cludcampus/features/auth/auth_controller.dart';
import 'package:cludcampus/features/auth/auth_flags.dart';
import 'package:cludcampus/features/auth/auth_messages.dart';
import 'package:cludcampus/features/auth/auth_repository.dart';
import 'package:cludcampus/features/auth/firebase_placeholders.dart';
import 'package:cludcampus/features/auth/firebase_setup.dart';
import 'package:cludcampus/features/auth/phone_auth_client.dart';
import 'package:cludcampus/features/auth/phone_number.dart';
import 'package:cludcampus/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Indian mobiles normalize to E.164', () {
    expect(indianE164('9876501001'), '+919876501001');
    expect(indianE164('+91 98765 01001'), '+919876501001');
    expect(indianE164('09876501001'), '+919876501001');
    expect(indianE164('919876501001'), '+919876501001');
    expect(prettyIndianMobile('9876501001'), '+91 98765 01001');
    expect(indianE164('5876501001'), isNull);
    expect(indianE164('98765'), isNull);
    expect(indianE164(''), isNull);
    expect(indianE164('98765010011'), isNull);
  });

  test('shipped Firebase config is the documented placeholder', () {
    expect(kMockOtpCompileFlag, isFalse);
    expect(FirebaseSetup.isConfigured, isFalse);
    expect(
      DefaultFirebaseOptions.android.projectId,
      FirebasePlaceholders.projectId,
    );
    expect(DefaultFirebaseOptions.android.apiKey, FirebasePlaceholders.apiKey);

    final json = jsonDecode(
      File('android/app/google-services.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final project = json['project_info'] as Map<String, dynamic>;
    expect(project['project_id'], FirebasePlaceholders.projectId);
    expect(project['project_number'], FirebasePlaceholders.projectNumber);
    final client = (json['client'] as List).single as Map<String, dynamic>;
    final info = client['client_info'] as Map<String, dynamic>;
    expect(info['mobilesdk_app_id'], FirebasePlaceholders.appId);
    final android = info['android_client_info'] as Map<String, dynamic>;
    expect(android['package_name'], 'com.cludcampus.app');
    final apiKey =
        ((client['api_key'] as List).single
            as Map<String, dynamic>)['current_key'];
    expect(apiKey, FirebasePlaceholders.apiKey);
  });

  test('Firebase auth codes become clear login copy', () {
    expect(
      firebasePhoneAuthMessage('invalid-verification-code'),
      AuthMessages.wrongOtp,
    );
    expect(
      firebasePhoneAuthMessage('missing-client-identifier'),
      AuthMessages.missingSha,
    );
    expect(firebasePhoneAuthMessage('quota-exceeded'), AuthMessages.smsQuota);
    expect(
      firebasePhoneAuthMessage('operation-not-allowed'),
      AuthMessages.phoneProviderOff,
    );
    expect(firebasePhoneAuthMessage('something-else'), AuthMessages.sendFailed);
  });

  test('an unknown number never asks the SMS client to send', () async {
    final phone = ScriptedPhoneAuth();
    final repo = AuthRepository(phoneAuth: phone);
    final result = await repo.requestOtp('9876543210');

    expect(result, isA<OtpRequestRejected>());
    expect((result as OtpRequestRejected).reason, OtpRejection.notEnrolled);
    expect(result.message, AuthMessages.notEnrolled);
    expect(phone.sends, 0);
  });

  test('an enrolled number is sent as E.164 and keeps that role', () async {
    final phone = ScriptedPhoneAuth(acceptedCode: '654321');
    final repo = AuthRepository(phoneAuth: phone, allowMockFallback: true);
    final sent = await repo.requestOtp('98765 04001');

    expect(phone.sends, 1);
    expect(phone.lastE164, '+919876504001');
    final session = (sent as OtpCodeSent).session;
    expect(session.backend, OtpBackend.firebase);

    final rosterCode = await repo.verifyOtp(session: session, code: '040001');
    expect(rosterCode, isA<OtpVerifyRejected>());
    expect((rosterCode as OtpVerifyRejected).message, AuthMessages.wrongOtp);
    expect(
      MockData.profileForMobile('9876504001')!.acceptsOtp('654321'),
      isFalse,
    );

    final sms = await repo.verifyOtp(session: session, code: '654321');
    expect((sms as OtpVerified).profile.role, UserRole.principal);
    expect(sms.profile.name, 'Dr Ramchand Kolasani');
  });

  test('resend forwards the Firebase resend token', () async {
    final phone = ScriptedPhoneAuth(acceptedCode: '654321');
    final repo = AuthRepository(phoneAuth: phone);
    final first = await repo.requestOtp('9876501001') as OtpCodeSent;
    await repo.requestOtp(
      '9876501001',
      forceResendingToken: first.session.resendToken,
    );
    expect(phone.lastToken, first.session.resendToken);
    expect(phone.sends, 2);
  });

  test('missing Firebase config does not accept the roster code', () async {
    final phone = ScriptedPhoneAuth(configured: false);
    final repo = AuthRepository(
      phoneAuth: phone,
      allowMockFallback: true,
      debugBuild: false,
    );

    final blocked = await repo.requestOtp('9876501001');
    expect((blocked as OtpRequestRejected).reason, OtpRejection.notConfigured);
    expect(blocked.message, AuthMessages.firebaseNotConfigured);
    expect(phone.sends, 0);

    final forced = await repo.verifyOtp(
      session: const OtpSession(
        e164: '+919876501001',
        verificationId: 'mock:+919876501001',
        backend: OtpBackend.mock,
      ),
      code: '010001',
    );
    expect(
      (forced as OtpVerifyRejected).message,
      AuthMessages.firebaseNotConfigured,
    );
  });

  test('a Firebase session is not retried against the roster code', () async {
    final repo = AuthRepository(
      phoneAuth: const UnconfiguredPhoneAuthClient(),
      allowMockFallback: true,
      debugBuild: true,
    );
    final result = await repo.verifyOtp(
      session: const OtpSession(
        e164: '+919876501001',
        verificationId: 'firebase-id',
        backend: OtpBackend.firebase,
      ),
      code: '010001',
    );
    expect(
      (result as OtpVerifyRejected).message,
      AuthMessages.firebaseNotConfigured,
    );
  });

  test('debug mock fallback accepts only that person\'s roster code', () async {
    final phone = ScriptedPhoneAuth(configured: false);
    final repo = AuthRepository(
      phoneAuth: phone,
      allowMockFallback: true,
      debugBuild: true,
    );

    final sent = await repo.requestOtp('+91 98765 03001');
    expect(phone.sends, 0);
    final session = (sent as OtpCodeSent).session;
    expect(session.backend, OtpBackend.mock);
    expect(session.e164, '+919876503001');

    final otherRole = await repo.verifyOtp(session: session, code: '010001');
    expect((otherRole as OtpVerifyRejected).message, AuthMessages.wrongOtp);

    final hod = await repo.verifyOtp(session: session, code: '030001');
    expect((hod as OtpVerified).profile.role, UserRole.hod);
  });

  test(
    'auto-retrieval opens the enrolled profile without a typed code',
    () async {
      final phone = ScriptedPhoneAuth(autoVerify: true);
      final container = ProviderContainer(
        overrides: [phoneAuthClientProvider.overrideWithValue(phone)],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(authControllerProvider.notifier)
          .requestOtp('9876502001');
      expect(result, isA<OtpAutoSignedIn>());
      final state = container.read(authControllerProvider);
      expect(state.isLoggedIn, isTrue);
      expect(state.role, UserRole.faculty);
      expect(state.demoName, 'Dr Ramesh Kumar');
      expect(state.collegeCode, MockData.asnCollege.code);
    },
  );

  test('a verified SMS opens the enrolled role session', () async {
    final phone = ScriptedPhoneAuth(acceptedCode: '222333');
    final container = ProviderContainer(
      overrides: [phoneAuthClientProvider.overrideWithValue(phone)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(authControllerProvider.notifier);

    final sent = await notifier.requestOtp('9876505001') as OtpCodeSent;
    final verified = await notifier.verifyOtp(
      session: sent.session,
      code: '222333',
    );
    expect(verified, isA<OtpVerified>());
    final state = container.read(authControllerProvider);
    expect(state.role, UserRole.collegeOffice);
    expect(state.demoName, 'College Office');
    expect(state.isLoggedIn, isTrue);

    await notifier.logout();
    expect(container.read(authControllerProvider).isLoggedIn, isFalse);
    expect(phone.signedOut, isTrue);
  });
}

class ScriptedPhoneAuth implements PhoneAuthClient {
  ScriptedPhoneAuth({
    this.configured = true,
    this.acceptedCode = '654321',
    this.autoVerify = false,
  });

  final bool configured;
  final String acceptedCode;
  final bool autoVerify;
  int sends = 0;
  String? lastE164;
  int? lastToken;
  bool signedOut = false;

  @override
  bool get isConfigured => configured;

  @override
  Future<PhoneCodeDispatch> sendCode({
    required String e164,
    int? forceResendingToken,
  }) async {
    sends++;
    lastE164 = e164;
    lastToken = forceResendingToken;
    if (autoVerify) return const PhoneCodeDispatch.autoVerified();
    return PhoneCodeDispatch.sent(verificationId: 'vid-$e164', resendToken: 7);
  }

  @override
  Future<void> confirmCode({
    required String verificationId,
    required String smsCode,
  }) async {
    if (smsCode != acceptedCode) {
      throw const PhoneAuthFailure(
        code: 'invalid-verification-code',
        message: 'bad',
      );
    }
  }

  @override
  Future<void> signOut() async {
    signedOut = true;
  }
}
