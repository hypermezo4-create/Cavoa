import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';
import '../../main_navigation/presentation/main_shell.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: surface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: primaryText),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
    );
  }

  String _mapAuthError(AppLocalizations l10n, FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return l10n.authEmailInUse;
      case 'invalid-email':
        return l10n.authInvalidEmail;
      case 'weak-password':
        return l10n.authWeakPassword;
      case 'too-many-requests':
        return l10n.authTooManyRequests;
      default:
        return error.message ?? l10n.somethingWentWrong;
    }
  }

  Future<void> _register() async {
    final l10n = context.l10n;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage(l10n.completeAllFields);
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

    try {
      setState(() => _loading = true);
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      if (!mounted) return;
      MainNavigationController.instance.goTo(0);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showMessage(_mapAuthError(l10n, error));
    } catch (_) {
      if (!mounted) return;
      _showMessage(l10n.somethingWentWrong);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? CavoColors.lightBackground : CavoColors.background;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final soft = isLight ? CavoColors.lightSurfaceSoft : CavoColors.surfaceSoft;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final mutedText =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? const [
                    Color(0xFFF8F6F1),
                    Color(0xFFF2EEE5),
                    Color(0xFFECE6DA),
                  ]
                : const [
                    Color(0xFF050505),
                    Color(0xFF080808),
                    Color(0xFF0D0A06),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              Row(
                children: [
                  _CircleButton(
                    isLight: isLight,
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: surface,
                  border: Border.all(color: border),
                  boxShadow: [
                    if (isLight)
                      BoxShadow(
                        color: CavoColors.lightShadow.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/branding/cavo_logo_circle.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.createAccount,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.joinCavoToSave,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: border),
                  boxShadow: [
                    if (isLight)
                      BoxShadow(
                        color: CavoColors.lightShadow.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildField(
                      context: context,
                      controller: _nameController,
                      hintText: l10n.fullName,
                      icon: Icons.person_outline_rounded,
                      soft: soft,
                      border: border,
                      primaryText: primaryText,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context: context,
                      controller: _emailController,
                      hintText: l10n.emailAddress,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      soft: soft,
                      border: border,
                      primaryText: primaryText,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context: context,
                      controller: _phoneController,
                      hintText: l10n.phoneNumber,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      soft: soft,
                      border: border,
                      primaryText: primaryText,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context: context,
                      controller: _passwordController,
                      hintText: l10n.password,
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                      ),
                      soft: soft,
                      border: border,
                      primaryText: primaryText,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      context: context,
                      controller: _confirmPasswordController,
                      hintText: l10n.confirmPassword,
                      icon: Icons.verified_user_outlined,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                      ),
                      soft: soft,
                      border: border,
                      primaryText: primaryText,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _loading ? null : _register,
                      child: Text(_loading ? l10n.loading : l10n.createAccount),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.signInAndContinue,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(l10n.goToLogin),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  l10n.mirrorOriginalPremiumFootwear,
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color soft,
    required Color border,
    required Color primaryText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: primaryText),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: soft,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: CavoColors.gold,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final bool isLight;
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.isLight,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final iconColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.96),
          shape: BoxShape.circle,
          border: Border.all(color: border),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}
