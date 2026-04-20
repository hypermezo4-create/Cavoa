import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../checkout/presentation/checkout_screen.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';
import '../../main_navigation/presentation/main_shell.dart';
import '../../profile/data/profile_controller.dart';
import 'auth_premium_widgets.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.redirectToCheckout = false});

  final bool redirectToCheckout;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _cardSlide;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;
  bool _acceptedTerms = true;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
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
        curve: const Interval(0.0, 0.76, curve: Curves.easeOutCubic),
      ),
    );

    _confirmPasswordController.addListener(_syncPasswordMatch);
    _passwordController.addListener(_syncPasswordMatch);
    _controller.forward();
  }

  @override
  void dispose() {
    _confirmPasswordController.removeListener(_syncPasswordMatch);
    _passwordController.removeListener(_syncPasswordMatch);
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _syncPasswordMatch() {
    final match = _passwordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text;

    if (match != _passwordsMatch) {
      setState(() {
        _passwordsMatch = match;
      });
    }
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
            color: const Color(0xFFD4AF37).withValues(alpha: 0.16),
          ),
        ),
      ),
    );
  }

  String _mapAuthError(FirebaseAuthException error) {
    final l10n = context.l10n;

    switch (error.code) {
      case 'email-already-in-use':
        return l10n.authEmailInUse;
      case 'invalid-email':
        return l10n.authInvalidEmail;
      case 'weak-password':
        return l10n.authWeakPassword;
      default:
        return error.message ?? l10n.somethingWentWrong;
    }
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

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  Future<void> _register() async {
    final l10n = context.l10n;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(l10n.completeAllFields);
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage(l10n.authInvalidEmail);
      return;
    }

    if (password != confirmPassword) {
      _showMessage(l10n.passwordsDoNotMatch);
      return;
    }

    if (password.length < 6) {
      _showMessage(l10n.passwordMustBeAtLeastSix);
      return;
    }

    if (!_acceptedTerms) {
      _showMessage('Please accept the Terms of Service and Privacy Policy.');
      return;
    }

    try {
      setState(() => _loading = true);

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      // FIX BUG UTAMA: Jangan await seedBasicProfile.
      // Sebelumnya: await ProfileController.instance.seedBasicProfile(...)
      // → Firestore set() di dalamnya bisa hang selamanya jika koneksi lambat
      //   → spinner tidak berhenti → user tidak bisa melanjutkan.
      // Sekarang: fire-and-forget. Akun Firebase Auth sudah berhasil dibuat.
      // Profile akan sync ke Firestore di background via authStateChanges listener.
      unawaited(ProfileController.instance.seedBasicProfile(
        fullName: name,
        phone: '',
        gender: '',
        age: null,
        visitedBefore: false,
      ));

      if (!mounted) return;
      _showMessage('Your account is ready. Welcome to CAVO.');
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
                    text: 'Email account',
                    icon: Icons.mark_email_read_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _fade,
              child: const Center(
                child: AuthLogoMedallion(size: 120),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Create your account in seconds, then complete the rest of your profile later from the profile page.',
                style: TextStyle(
                  color: Color(0xFFB8B1A3),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 18),
            FadeTransition(
              opacity: _fade,
              child: const AuthProgressDots(activeIndex: 0),
            ),
            const SizedBox(height: 22),
            SlideTransition(
              position: _cardSlide,
              child: AuthGlassCard(
                child: Column(
                  children: [
                    AuthTextField(
                      controller: _nameController,
                      hintText: 'Full name',
                      icon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
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
                      textInputAction: TextInputAction.next,
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
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      hintText: l10n.confirmPassword,
                      icon: Icons.verified_user_outlined,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_passwordsMatch)
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF3DDC97).withValues(alpha: 0.18),
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Color(0xFF3DDC97),
                                size: 16,
                              ),
                            ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: const Color(0xFFF5F1E8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptedTerms = !_acceptedTerms;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: _acceptedTerms
                                  ? const Color(0xFFD4AF37)
                                  : Colors.transparent,
                              border: Border.all(
                                color: const Color(0xFFD4AF37).withValues(alpha: 0.42),
                              ),
                            ),
                            child: _acceptedTerms
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'I agree to the Terms of Service and Privacy Policy.',
                            style: TextStyle(
                              color: Color(0xFFB8B1A3),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    AuthPrimaryButton(
                      label: _loading ? l10n.loading : l10n.createAccount,
                      onPressed: _loading ? null : _register,
                      loading: _loading,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            FadeTransition(
              opacity: _fade,
              child: AuthGlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: AuthFooterLink(
                  title: 'Already have an account?',
                  actionLabel: 'Login',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      buildCavoFadeRoute(LoginScreen(redirectToCheckout: widget.redirectToCheckout)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Fast sign up • finish profile later • premium feel',
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
