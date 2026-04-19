import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';
import '../../main_navigation/presentation/main_shell.dart';
import '../data/auth_service.dart';
import 'auth_premium_widgets.dart';
import 'phone_auth_screen.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _cardSlide;
  late final Animation<Offset> _footerSlide;

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _footerSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF141414),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFFF5F1E8),
            fontWeight: FontWeight.w600,
            height: 1.45,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: const Color(0xFFD4AF37).withOpacity(0.16),
          ),
        ),
      ),
    );
  }

  String _mapAuthError(FirebaseAuthException error) {
    final l10n = context.l10n;

    switch (error.code) {
      case 'invalid-email':
        return l10n.authInvalidEmail;
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return l10n.authInvalidCredentials;
      case 'user-disabled':
        return l10n.authUserDisabled;
      case 'too-many-requests':
        return l10n.authTooManyRequests;
      default:
        return error.message ?? l10n.somethingWentWrong;
    }
  }

  void _goToApp() {
    MainNavigationController.instance.goTo(0);
    Navigator.of(context).pushAndRemoveUntil(
      buildCavoFadeRoute(const MainShell()),
      (route) => false,
    );
  }

  Future<void> _login() async {
    final l10n = context.l10n;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage(l10n.completeAllFields);
      return;
    }

    try {
      setState(() => _loading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      _goToApp();
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showMessage(_mapAuthError(error));
    } catch (_) {
      if (!mounted) return;
      _showMessage(l10n.somethingWentWrong);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      setState(() => _loading = true);

      await AuthService.instance.signInWithGoogle();

      if (!mounted) return;
      _goToApp();
    } on CavoAuthException catch (error) {
      if (!mounted) return;
      _showMessage(error.message);
    } catch (error) {
      if (!mounted) return;
      _showMessage('Unexpected Google sign-in error. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                  AuthBackButton(onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  const AuthBadge(
                    text: 'Secure sign in',
                    icon: Icons.shield_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            FadeTransition(
              opacity: _fade,
              child: const Center(
                child: AuthLogoMedallion(size: 128),
              ),
            ),
            const SizedBox(height: 22),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Sign in to continue your cart, saved preferences, and premium checkout flow.',
                style: TextStyle(
                  color: Color(0xFFB8B1A3),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: _cardSlide,
              child: AuthGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthBadge(
                      text: 'Mirror Original',
                      icon: Icons.auto_awesome_rounded,
                    ),
                    const SizedBox(height: 18),
                    AuthTextField(
                      controller: _emailController,
                      hintText: l10n.emailAddress,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _passwordController,
                      hintText: l10n.password,
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: const Color(0xFFF5F1E8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            buildCavoFadeRoute(const ResetPasswordScreen()),
                          );
                        },
                        child: Text(
                          l10n.forgotPassword,
                          style: const TextStyle(
                            color: Color(0xFFF1D27A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AuthPrimaryButton(
                      label: _loading ? l10n.loading : l10n.login,
                      onPressed: _loading ? null : _login,
                      loading: _loading,
                    ),
                    const SizedBox(height: 18),
                    const AuthDividerLabel(text: 'or continue with'),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        AuthIconAction(
                          onPressed: _loading ? () {} : () => _loginWithGoogle(),
                          icon: const Text(
                            'G',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        AuthIconAction(
                          onPressed: _loading
                              ? () {}
                              : () {
                                  Navigator.of(context).push(
                                    buildCavoFadeRoute(const PhoneAuthScreen()),
                                  );
                                },
                          icon: const Icon(
                            Icons.phone_in_talk_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        AuthIconAction(
                          onPressed: () {
                            _showMessage(
                              'Facebook login will be enabled after Meta app setup is finished.',
                            );
                          },
                          icon: const Icon(
                            Icons.facebook_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AuthOutlineButton(
                      label: l10n.continueAsGuest,
                      onPressed: _goToApp,
                      compact: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SlideTransition(
              position: _footerSlide,
              child: AuthGlassCard(
                padding: const EdgeInsets.all(18),
                borderRadius: const BorderRadius.all(Radius.circular(26)),
                child: Column(
                  children: [
                    const Text(
                      'New to CAVO?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your account to unlock saved style picks, faster checkout, and future order tracking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB8B1A3),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    AuthFooterLink(
                      title: 'Ready to join?',
                      actionLabel: 'Create Account',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          buildCavoFadeRoute(const RegisterScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Mirror Original • Premium Footwear',
                style: TextStyle(
                  color: Color(0xFF7F786B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
