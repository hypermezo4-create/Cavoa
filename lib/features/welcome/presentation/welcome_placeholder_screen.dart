import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../shared/widgets/cavo_language_picker.dart';
import '../../auth/presentation/auth_premium_widgets.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/register_screen.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';
import '../../main_navigation/presentation/main_shell.dart';

class WelcomePlaceholderScreen extends StatefulWidget {
  const WelcomePlaceholderScreen({super.key});

  @override
  State<WelcomePlaceholderScreen> createState() =>
      _WelcomePlaceholderScreenState();
}

class _WelcomePlaceholderScreenState extends State<WelcomePlaceholderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _heroSlide;
  late final Animation<Offset> _actionsSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _logoScale = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.48, curve: Curves.easeOutBack),
      ),
    );

    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.68, curve: Curves.easeOutCubic),
      ),
    );

    _actionsSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToApp() {
    MainNavigationController.instance.goTo(0);
    Navigator.of(context).pushReplacement(
      buildCavoFadeRoute(const MainShell()),
    );
  }

  void _goToLogin() {
    Navigator.of(context).push(buildCavoFadeRoute(const LoginScreen()));
  }

  void _goToRegister() {
    Navigator.of(context).push(buildCavoFadeRoute(const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthPremiumScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CavoLanguagePicker(isLight: false),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: FadeTransition(
                      opacity: _fade,
                      child: Column(
                        children: [
                          SlideTransition(
                            position: _heroSlide,
                            child: Column(
                              children: [
                                ScaleTransition(
                                  scale: _logoScale,
                                  child: const AuthLogoMedallion(size: 176),
                                ),
                                const SizedBox(height: 22),
                                const AuthBadge(text: 'CAVO'),
                                const SizedBox(height: 28),
                                Text(
                                  l10n.mirrorOriginal,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 44,
                                    fontWeight: FontWeight.w900,
                                    height: 1.05,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 340),
                                  child: Text(
                                    'Continue with your secure email account to shop and track orders with CAVO.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFFB8B1A3),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                const AuthGlassCard(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 16,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(26),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        color: Color(0xFFF1D27A),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'English default  •  Arabic  •  Russian  •  German',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFF5F1E8),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 34),
                          SlideTransition(
                            position: _actionsSlide,
                            child: Column(
                              children: [
                                AuthPrimaryButton(
                                  label: l10n.login,
                                  onPressed: _goToLogin,
                                ),
                                const SizedBox(height: 14),
                                AuthOutlineButton(
                                  label: l10n.createAccount,
                                  onPressed: _goToRegister,
                                  leadingIcon: Icons.person_add_alt_1_rounded,
                                ),
                                const SizedBox(height: 18),
                                TextButton(
                                  onPressed: _goToApp,
                                  child: Text(
                                    l10n.continueAsGuest,
                                    style: const TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                const Text(
                                  'Refined by CAVO',
                                  style: TextStyle(
                                    color: Color(0xFF7F786B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
