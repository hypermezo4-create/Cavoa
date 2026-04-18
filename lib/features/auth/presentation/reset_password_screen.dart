import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_premium_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  bool _loading = false;
  bool _success = false;

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
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _loading = true;
      _success = false;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      setState(() => _success = true);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Could not send reset email.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
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
                  const AuthBadge(
                    text: 'Verify your email',
                    icon: Icons.mail_outline_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 34),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Verify your email',
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
                'We will send a reset link to your inbox so you can create a new password and return to CAVO smoothly.',
                style: TextStyle(
                  color: Color(0xFFB8B1A3),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 28),
            AuthGlassCard(
              child: Column(
                children: [
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'example@cavo.store',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 18),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    child: _success
                        ? Column(
                            key: const ValueKey('success'),
                            children: const [
                              _SuccessPulse(),
                              SizedBox(height: 12),
                              Text(
                                'Code sent! Check your inbox.',
                                style: TextStyle(
                                  color: Color(0xFF7FF1A8),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(key: ValueKey('idle')),
                  ),
                  const SizedBox(height: 18),
                  AuthPrimaryButton(
                    label: _loading ? 'Sending...' : 'Send Reset Link',
                    onPressed: _loading ? null : _sendReset,
                    loading: _loading,
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

class _SuccessPulse extends StatefulWidget {
  const _SuccessPulse();

  @override
  State<_SuccessPulse> createState() => _SuccessPulseState();
}

class _SuccessPulseState extends State<_SuccessPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.08);
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [const Color(0xFF6D5DFF), const Color(0xFF915CFF).withOpacity(0.84)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7E61FF).withOpacity(0.36),
              blurRadius: 28,
            ),
          ],
        ),
        child: const Icon(Icons.mark_email_read_rounded, color: Colors.white),
      ),
    );
  }
}
