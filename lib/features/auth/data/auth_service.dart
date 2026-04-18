import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config/auth_config.dart';

class CavoAuthException implements Exception {
  const CavoAuthException(
    this.message, {
    this.debugDetails,
    this.cause,
  });

  final String message;
  final String? debugDetails;
  final Object? cause;

  @override
  String toString() {
    if (debugDetails == null || debugDetails!.trim().isEmpty) {
      return message;
    }

    return '$message\n$debugDetails';
  }
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleInitialized = false;

  Future<void> initialize() async {
    if (_googleInitialized) return;

    await _googleSignIn.initialize(
      serverClientId: AuthConfig.googleServerClientId,
    );

    _googleInitialized = true;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      await initialize();

      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const CavoAuthException(
          'Google returned no ID token.',
          debugDetails:
              'Check the web OAuth client, serverClientId, and google-services.json.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (error, stackTrace) {
      debugPrint(
        'CAVO GoogleSignInException: '
        'code=${error.code.name}, '
        'description=${error.description}, '
        'details=${error.details}',
      );
      debugPrintStack(stackTrace: stackTrace);

      throw CavoAuthException(
        _mapGoogleSignInException(error),
        debugDetails:
            'GoogleSignInException(code: ${error.code.name}, '
            'description: ${error.description ?? 'none'}, '
            'details: ${error.details ?? 'none'})',
        cause: error,
      );
    } on FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
        'CAVO FirebaseAuthException during Google login: '
        'code=${error.code}, message=${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);

      throw CavoAuthException(
        _mapFirebaseAuthException(error),
        debugDetails:
            'FirebaseAuthException(code: ${error.code}, '
            'message: ${error.message ?? 'none'})',
        cause: error,
      );
    } catch (error, stackTrace) {
      debugPrint('CAVO unexpected Google sign-in error: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw CavoAuthException(
        'Unexpected Google sign-in failure.',
        debugDetails: error.toString(),
        cause: error,
      );
    }
  }

  String _mapGoogleSignInException(GoogleSignInException error) {
    switch (error.code) {
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'Google Sign-In Android configuration error. '
            'Check SHA-1, package name, and serverClientId.';
      case GoogleSignInExceptionCode.canceled:
        return 'Google sign-in was canceled. If this happens right after '
            'choosing an account, it often means there is still a '
            'configuration mismatch in Android/Firebase.';
      case GoogleSignInExceptionCode.interrupted:
        return 'Google sign-in was interrupted. Please try again.';
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'Google provider configuration is incomplete or unavailable '
            'on this device.';
      case GoogleSignInExceptionCode.uiUnavailable:
        return 'Google sign-in UI is unavailable right now. Open the screen '
            'again and retry.';
      case GoogleSignInExceptionCode.userMismatch:
        return 'Google account mismatch detected. Sign out and try again.';
      case GoogleSignInExceptionCode.unknownError:
        final description = error.description?.trim();
        if (description != null && description.isNotEmpty) {
          return description;
        }
        return 'Unknown Google sign-in error.';
    }
  }

  String _mapFirebaseAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'account-exists-with-different-credential':
        return 'This email already exists with another sign-in method.';
      case 'invalid-credential':
        return 'Google returned an invalid credential.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled in Firebase Auth.';
      case 'network-request-failed':
        return 'Network request failed during Google sign-in.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return error.message ?? 'Firebase rejected Google sign-in.';
    }
  }
}
