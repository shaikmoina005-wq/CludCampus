// PLACEHOLDER — not a live Firebase project.
//
// Phone Auth stays disabled until this file is replaced. The app treats
// project id `placeholder-cludcampus` as "not configured" and will not send
// SMS or accept roster codes in release builds.
//
// Moin: download the Android config for package `com.cludcampus.app`, then
// either run `flutterfire configure` or paste the values from
// `android/app/google-services.json` into [DefaultFirebaseOptions.android].
// Keep that JSON and this file on the same project. Steps are in the README.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

import 'features/auth/firebase_placeholders.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'CludCampus Phone Auth is configured for Android only.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: FirebasePlaceholders.apiKey,
    appId: FirebasePlaceholders.appId,
    messagingSenderId: FirebasePlaceholders.projectNumber,
    projectId: FirebasePlaceholders.projectId,
    storageBucket: FirebasePlaceholders.storageBucket,
  );
}
