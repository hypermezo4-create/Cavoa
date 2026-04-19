import 'package:flutter/foundation.dart';

class CavoAuthException implements Exception {
  const CavoAuthException(this.message, {this.debugDetails, this.cause});

  final String message;
  final String? debugDetails;
  final Object? cause;

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  Future<void> initialize() async {
    debugPrint('CAVO email-only auth build active. External providers are disabled.');
  }

  Future<void> signInWithGoogle() async {
    throw const CavoAuthException(
      'External sign-in has been removed from this build. Please use your email and password.',
    );
  }
}
