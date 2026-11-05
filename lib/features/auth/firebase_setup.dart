import '../../firebase_options.dart';
import 'firebase_placeholders.dart';

/// Whether this build has a real Firebase Android app, not the git placeholder.
class FirebaseSetup {
  const FirebaseSetup._();

  static bool get isConfigured {
    final options = DefaultFirebaseOptions.android;
    if (options.projectId != FirebasePlaceholders.projectId) {
      return options.apiKey.isNotEmpty &&
          options.apiKey != FirebasePlaceholders.apiKey &&
          options.appId.isNotEmpty;
    }
    return false;
  }
}
