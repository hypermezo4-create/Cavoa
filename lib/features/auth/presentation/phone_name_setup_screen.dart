import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../checkout/presentation/checkout_screen.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';
import '../../main_navigation/presentation/main_shell.dart';
import '../../profile/data/profile_controller.dart';
import 'auth_premium_widgets.dart';

class PhoneNameSetupScreen extends StatefulWidget {
  const PhoneNameSetupScreen({
    super.key,
    required this.phoneNumber,
    this.redirectToCheckout = false,
  });

  final String phoneNumber;
  final bool redirectToCheckout;

  @override
  State<PhoneNameSetupScreen> createState() => _PhoneNameSetupScreenState();
}

class _PhoneNameSetupScreenState extends State<PhoneNameSetupScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    final user = FirebaseAuth.instance.currentUser;
    final existingName = (ProfileController.instance.value?.fullName.trim().isNotEmpty == true)
        ? ProfileController.instance.value!.fullName.trim()
        : (user?.displayName ?? '').trim();
    if (existingName.isNotEmpty && existingName != 'CAVO Member') {
      _nameController.text = existingName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
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

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first.')),
      );
      return;
    }

    setState(() => _saving = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please try phone login again.')),
      );
      return;
    }

    try {
      await user.updateDisplayName(name);
    } catch (_) {}

    try {
      await ProfileController.instance.seedBasicProfile(
        fullName: name,
        phone: widget.phoneNumber,
        gender: '',
        age: null,
        visitedBefore: false,
      );
    } catch (_) {}

    if (!mounted) return;
    setState(() => _saving = false);
    _goToApp();
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
                    text: 'Your CAVO name',
                    icon: Icons.person_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Tell us your name',
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
                'One quick step and you will be inside CAVO. This name will appear on your profile and future orders.',
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
                    controller: _nameController,
                    hintText: 'Your full name',
                    icon: Icons.badge_rounded,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.phoneNumber,
                      style: const TextStyle(
                        color: Color(0xFF8A8377),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AuthPrimaryButton(
                    label: _saving ? 'Saving...' : 'Continue',
                    onPressed: _saving ? null : _save,
                    loading: _saving,
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
