import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController(text: 'Hurghada');
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController(text: 'Premium CAVO member');

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _cardSlide;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;
  bool _acceptedTerms = true;
  bool _passwordsMatch = false;
  String _gender = 'male';
  bool _visitedBefore = false;
  String? _avatarPath;

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
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _bioController.dispose();
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
            color: const Color(0xFFD4AF37).withOpacity(0.16),
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

  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (file == null || !mounted) return;
    setState(() => _avatarPath = file.path);
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  Future<void> _register() async {
    final l10n = context.l10n;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final city = _cityController.text.trim();
    final area = _areaController.text.trim();
    final address = _addressController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        city.isEmpty ||
        address.isEmpty) {
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

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await ProfileController.instance.seedBasicProfile(
        fullName: name,
        phone: phone,
        gender: _gender,
        age: int.tryParse(_ageController.text.trim()),
        visitedBefore: _visitedBefore,
        city: city,
        area: area,
        addressLine: address,
        bio: bio,
        avatarPath: _avatarPath,
      );

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

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFB8B1A3)),
      filled: true,
      fillColor: const Color(0xFF141416),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.16)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.2),
      ),
    );
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
                'Create your full CAVO account with your real details so checkout, profile, and future orders stay synced.',
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
                      controller: _phoneController,
                      hintText: 'Phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            decoration: _dropdownDecoration('City'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _areaController,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            decoration: _dropdownDecoration('Area'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _addressController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      decoration: _dropdownDecoration('Address details'),
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
                                color: const Color(0xFF3DDC97).withOpacity(0.18),
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _pickAvatar(ImageSource.gallery),
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: const Color(0x1FD4AF37),
                            backgroundImage: _avatarPath == null ? null : FileImage(File(_avatarPath!)),
                            child: _avatarPath == null ? const Icon(Icons.photo_camera_back_rounded, color: Color(0xFFD4AF37)) : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Profile photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: AuthOutlineButton(label: 'Gallery', onPressed: () => _pickAvatar(ImageSource.gallery), compact: true)),
                                  const SizedBox(width: 8),
                                  Expanded(child: AuthOutlineButton(label: 'Camera', onPressed: () => _pickAvatar(ImageSource.camera), compact: true)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _gender,
                            dropdownColor: const Color(0xFF171717),
                            decoration: _dropdownDecoration('Gender'),
                            items: const [
                              DropdownMenuItem(value: 'male', child: Text('Male')),
                              DropdownMenuItem(value: 'female', child: Text('Female')),
                            ],
                            onChanged: (value) => setState(() => _gender = value ?? 'male'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            decoration: _dropdownDecoration('Age'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                      value: _visitedBefore,
                      contentPadding: EdgeInsets.zero,
                      activeColor: const Color(0xFFD4AF37),
                      title: const Text('Have you visited CAVO before?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                      subtitle: const Text('This helps personalize recommendations and account details.', style: TextStyle(color: Color(0xFFB8B1A3), fontSize: 12)),
                      onChanged: (value) => setState(() => _visitedBefore = value),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _bioController,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      decoration: _dropdownDecoration('Bio'),
                    ),
                    const SizedBox(height: 8),
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
                                color: const Color(0xFFD4AF37).withOpacity(0.42),
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
                'Email-first onboarding • full profile • premium feel',
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
