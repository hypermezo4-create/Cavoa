import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../checkout/presentation/checkout_screen.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';
import '../../main_navigation/presentation/main_shell.dart';
import 'auth_premium_widgets.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    this.redirectToCheckout = false,
  });

  final String verificationId;
  final String phoneNumber;
  final bool redirectToCheckout;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  late final AnimationController _entryController;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  Timer? _timer;
  late String _verificationId;
  int _secondsLeft = 60;
  bool _loading = false;
  bool _success = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _verificationId = widget.verificationId;
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    _textController.addListener(_onCodeChanged);
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _entryController.dispose();
    _shakeController.dispose();
    _textController.removeListener(_onCodeChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToApp() {
    if (widget.redirectToCheckout) {
      Navigator.of(context).pushAndRemoveUntil(
        buildCavoFadeRoute(const CheckoutScreen()),
        (route) => false,
      );
      return;
    }
    MainNavigationController.instance.goTo(0);
    Navigator.of(context).pushAndRemoveUntil(
      buildCavoFadeRoute(const MainShell()),
      (route) => false,
    );
  }

  void _onCodeChanged() {
    if (_textController.text.length == 6 && !_loading) {
      _verifyCode();
    } else if (_error) {
      setState(() => _error = false);
    }
  }

  Future<void> _verifyCode() async {
    final code = _textController.text.trim();
    if (code.length != 6) return;
    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      setState(() => _success = true);
      await Future<void>.delayed(const Duration(milliseconds: 620));
      if (!mounted) return;
      _goToApp();
    } on FirebaseAuthException {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _success = false;
        _error = true;
      });
      _shakeController.forward(from: 0);
    }
  }


  Future<void> _resendCode() async {
    _textController.clear();
    _startTimer();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          _goToApp();
        },
        verificationFailed: (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Could not resend code.')),
          );
        },
        codeSent: (verificationId, _) {
          _verificationId = verificationId;
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A fresh code was sent.')),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not resend code. $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = _textController.text;
    return AuthPremiumScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          physics: const BouncingScrollPhysics(),
          children: [
            FadeTransition(
              opacity: CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
              child: Row(
                children: [
                  AuthBackButton(onPressed: () => Navigator.of(context).maybePop()),
                  const Spacer(),
                  const AuthBadge(text: 'OTP Verification', icon: Icons.shield_rounded),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'OTP Verification',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We have sent the verification code to ${widget.phoneNumber}.',
              style: const TextStyle(
                color: Color(0xFFB8B1A3),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 26),
            AuthGlassCard(
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_error ? _shakeAnimation.value : 0, 0),
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _focusNode.requestFocus(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final filled = index < code.length;
                          final char = filled ? code[index] : '';
                          final borderColor = _success
                              ? const Color(0xFF56D882)
                              : _error
                                  ? const Color(0xFFFF5F7A)
                                  : filled
                                      ? CavoColors.gold
                                      : const Color(0xFF35312A);
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 46,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFF151515),
                              border: Border.all(color: borderColor, width: 1.4),
                              boxShadow: filled
                                  ? [
                                      BoxShadow(
                                        color: borderColor.withOpacity(0.14),
                                        blurRadius: 18,
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              char,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: _error
                          ? const Text(
                              'Wrong code, please try again.',
                              key: ValueKey('error'),
                              style: TextStyle(
                                color: Color(0xFFFF718A),
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : Text(
                              'The code will expire in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                              key: const ValueKey('timer'),
                              style: const TextStyle(
                                color: Color(0xFFB8B1A3),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    if (_success)
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF56D882), size: 54)
                    else
                      const SizedBox(height: 54),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _secondsLeft == 0 ? _resendCode : null,
                      child: Text(
                        _secondsLeft == 0 ? 'Resend' : 'Resend in ${_secondsLeft}s',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Offstage(
                      offstage: true,
                      child: SizedBox(
                        width: 0,
                        height: 0,
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          autofocus: true,
                          decoration: const InputDecoration(counterText: ''),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
