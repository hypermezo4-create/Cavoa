import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main_navigation/presentation/main_navigation_controller.dart';
import '../../main_navigation/presentation/main_shell.dart';
import 'auth_premium_widgets.dart';
import 'otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _normalizeEgyptNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'\s+'), '');
    if (digits.startsWith('+')) return digits;
    if (digits.startsWith('00')) return '+${digits.substring(2)}';
    if (digits.startsWith('0')) return '+20${digits.substring(1)}';
    if (digits.startsWith('20')) return '+$digits';
    return '+20$digits';
  }

  String _mapPhoneAuthError(FirebaseAuthException error) {
    final code = error.code.toLowerCase();
    if (code.contains('billing') || code.contains('not-enabled')) {
      return 'Phone OTP is not ready yet on Firebase billing for this build.';
    }
    switch (error.code) {
      case 'invalid-phone-number':
        return 'Please enter a valid phone number.';
      case 'too-many-requests':
        return 'Too many OTP attempts. Please try again later.';
      case 'quota-exceeded':
        return 'OTP quota is exceeded right now. Please try again later.';
      case 'operation-not-allowed':
        return 'Phone sign-in is not enabled in Firebase Auth.';
      case 'network-request-failed':
        return 'Network error while sending OTP. Please try again.';
      default:
        return error.message ?? 'Phone verification failed.';
    }
  }

  void _goToApp() {
    MainNavigationController.instance.goTo(0);
    Navigator.of(context).pushAndRemoveUntil(
      buildCavoFadeRoute(const MainShell()),
      (route) => false,
    );
  }

  Future<void> _sendCode() async {
    final number = _normalizeEgyptNumber(_phoneController.text.trim());
    if (number.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }

    setState(() => _sending = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          _goToApp();
        },
        verificationFailed: (error) {
          if (!mounted) return;
          setState(() => _sending = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_mapPhoneAuthError(error))),
          );
        },
        codeSent: (verificationId, _) {
          if (!mounted) return;
          setState(() => _sending = false);
          Navigator.of(context).push(
            buildCavoFadeRoute(
              OtpVerificationScreen(
                verificationId: verificationId,
                phoneNumber: number,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) {
          if (mounted) setState(() => _sending = false);
        },
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error is FirebaseAuthException ? _mapPhoneAuthError(error) : 'Could not send OTP right now.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPremiumScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          physics: const BouncingScrollPhysics(),
          children: [
            FadeTransition(
              opacity: _fade,
              child: Row(
                children: [
                  AuthBackButton(onPressed: () => Navigator.of(context).maybePop()),
                  const Spacer(),
                  const AuthBadge(text: 'Phone OTP', icon: Icons.phone_iphone_rounded),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Continue with your phone',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'We will send a one-time verification code to your number so you can sign in safely.',
                style: TextStyle(
                  color: Color(0xFFB8B1A3),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AuthGlassCard(
              child: Column(
                children: [
                  AuthTextField(
                    controller: _phoneController,
                    hintText: '01xxxxxxxxx',
                    icon: Icons.phone_in_talk_rounded,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 14),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Egypt format is supported automatically. Example: 010xxxxxxxx',
                      style: TextStyle(
                        color: Color(0xFF8A8377),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AuthPrimaryButton(
                    label: _sending ? 'Sending...' : 'Send OTP',
                    onPressed: _sending ? null : _sendCode,
                    loading: _sending,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
