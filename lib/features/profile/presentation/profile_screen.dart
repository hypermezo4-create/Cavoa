import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/app_locale_controller.dart';
import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_mode_controller.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_language_picker.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../cart/data/cart_controller.dart';
import '../../orders/data/order_controller.dart';
import '../../orders/presentation/delivery_tracking_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
            children: [
              CavoSectionHeader(
                title: context.l10n.profile,
                subtitle: user == null
                    ? context.l10n.guestModeSignInForFullAccess
                    : context.l10n.signedInSecurely,
                action: user == null ? null : 'Edit',
                onActionTap: user == null
                    ? null
                    : () => _showEditProfileSheet(context, user: user, isLight: isLight),
                isLight: isLight,
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(34)),
                child: Row(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: CavoColors.gold.withValues(alpha: 0.18),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/branding/cavo_logo_circle.png', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName?.trim().isNotEmpty == true
                                ? user!.displayName!
                                : (user?.email ?? 'CAVO Member'),
                            style: TextStyle(
                              color: primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user?.email ?? context.l10n.guestModeSignInForFullAccess,
                            style: TextStyle(
                              color: secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CavoPillTag(
                            label: user == null ? 'Guest mode' : 'Firebase account',
                            isLight: isLight,
                            selected: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<CartItem>>(
                      valueListenable: CartController.instance,
                      builder: (context, cartItems, _) {
                        return _CountCard(
                          title: context.l10n.cart,
                          value: '${cartItems.length}',
                          subtitle: 'items saved',
                          icon: Icons.shopping_bag_outlined,
                          isLight: isLight,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: user == null
                        ? _CountCard(
                            title: context.l10n.orders,
                            value: '${OrderController.instance.value.length}',
                            subtitle: 'local only',
                            icon: Icons.receipt_long_outlined,
                            isLight: isLight,
                          )
                        : StreamBuilder<List<CavoOrder>>(
                            stream: OrderController.instance.watchCurrentUserOrders(),
                            builder: (context, snapshot) {
                              final value = snapshot.data?.length ?? 0;
                              return _CountCard(
                                title: context.l10n.orders,
                                value: '$value',
                                subtitle: 'synced to Firebase',
                                icon: Icons.cloud_done_outlined,
                                isLight: isLight,
                              );
                            },
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CavoSectionHeader(
                title: context.l10n.quickAccess,
                subtitle: context.l10n.personalizeCavoExperience,
                isLight: isLight,
              ),
              const SizedBox(height: 12),
              _ProfileActionTile(
                title: context.l10n.language,
                subtitle: 'Current: ${AppLocaleController.instance.code}',
                isLight: isLight,
                trailing: const CavoLanguagePicker(isLight: false, expanded: false),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeModeController.instance,
                builder: (context, mode, _) {
                  return _ProfileActionTile(
                    title: context.l10n.appearance,
                    subtitle: mode == ThemeMode.dark ? context.l10n.dark : context.l10n.light,
                    isLight: isLight,
                    trailing: Switch.adaptive(
                      value: mode == ThemeMode.dark,
                      activeColor: CavoColors.gold,
                      onChanged: (_) => ThemeModeController.instance.toggle(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              CavoSectionHeader(
                title: context.l10n.orders,
                subtitle: user == null
                    ? 'Sign in to sync order status from Firebase.'
                    : 'Your recent Firebase orders appear here with their latest status.',
                isLight: isLight,
              ),
              const SizedBox(height: 12),
              if (user == null)
                _OrdersPlaceholder(isLight: isLight)
              else
                StreamBuilder<List<CavoOrder>>(
                  stream: OrderController.instance.watchCurrentUserOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    final orders = snapshot.data ?? const <CavoOrder>[];
                    if (orders.isEmpty) {
                      return _OrdersPlaceholder(isLight: isLight);
                    }
                    return Column(
                      children: orders.take(6).map((order) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _OrderCard(order: order, isLight: isLight),
                      )).toList(growable: false),
                    );
                  },
                ),
              const SizedBox(height: 18),
              if (user != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.loggedOutSuccessfully)),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(context.l10n.logout),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool isLight;

  const _CountCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return CavoGlassCard(
      isLight: isLight,
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CavoColors.gold.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: CavoColors.gold),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              color: primary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool isLight;

  const _ProfileActionTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    return CavoGlassCard(
      isLight: isLight,
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}

class _OrdersPlaceholder extends StatelessWidget {
  final bool isLight;

  const _OrdersPlaceholder({required this.isLight});

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    return CavoGlassCard(
      isLight: isLight,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Column(
        children: [
          const Icon(Icons.inventory_2_outlined, color: CavoColors.gold, size: 38),
          const SizedBox(height: 12),
          Text(
            'No saved orders yet',
            style: TextStyle(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Once checkout is completed, your orders will appear here with the latest status from Firebase.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final CavoOrder order;
  final bool isLight;

  const _OrderCard({required this.order, required this.isLight});

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DeliveryTrackingScreen(order: order),
          ),
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: CavoGlassCard(
        isLight: isLight,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    style: TextStyle(
                      color: primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                CavoPillTag(
                  label: order.status.label,
                  isLight: isLight,
                  selected: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${order.total} EGP • ${order.items.length} item(s) • ${order.paymentMethod.label}',
              style: TextStyle(
                color: secondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${order.city} • ${order.area} • ${order.addressLine}',
              style: TextStyle(
                color: secondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.isRated ? 'Rated ${order.rating}/5' : 'Tap to track order',
                    style: TextStyle(
                      color: order.isRated ? const Color(0xFF2DBA71) : CavoColors.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: CavoColors.gold, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showEditProfileSheet(
  BuildContext context, {
  required User user,
  required bool isLight,
}) async {
  final nameController = TextEditingController(text: user.displayName ?? '');
  final emailController = TextEditingController(text: user.email ?? '');
  final phoneController = TextEditingController();
  final locationController = TextEditingController(text: 'Hurghada, Egypt');
  final bioController = TextEditingController(text: 'Premium CAVO member');

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
      final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
      bool saving = false;
      bool success = false;
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14,
            ),
            child: CavoGlassCard(
              isLight: isLight,
              borderRadius: const BorderRadius.all(Radius.circular(34)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: secondary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SheetField(controller: nameController, label: 'Full name', icon: Icons.person_outline_rounded, primary: primary, secondary: secondary),
                  const SizedBox(height: 12),
                  _SheetField(controller: emailController, label: 'Email', icon: Icons.mail_outline_rounded, primary: primary, secondary: secondary, enabled: false),
                  const SizedBox(height: 12),
                  _SheetField(controller: phoneController, label: 'Phone', icon: Icons.phone_outlined, primary: primary, secondary: secondary),
                  const SizedBox(height: 12),
                  _SheetField(controller: locationController, label: 'Location', icon: Icons.location_on_outlined, primary: primary, secondary: secondary),
                  const SizedBox(height: 12),
                  _SheetField(controller: bioController, label: 'Bio', icon: Icons.info_outline_rounded, primary: primary, secondary: secondary, maxLines: 2),
                  const SizedBox(height: 18),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: success
                        ? Row(
                            key: const ValueKey('ok'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.check_circle_rounded, color: Color(0xFF2DBA71)),
                              SizedBox(width: 8),
                              Text('Profile saved smoothly', style: TextStyle(color: Color(0xFF2DBA71), fontWeight: FontWeight.w800)),
                            ],
                          )
                        : const SizedBox.shrink(key: ValueKey('idle')),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: saving ? null : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: saving
                              ? null
                              : () async {
                                  setModalState(() => saving = true);
                                  await user.updateDisplayName(nameController.text.trim());
                                  if (context.mounted) {
                                    setModalState(() {
                                      saving = false;
                                      success = true;
                                    });
                                    await Future<void>.delayed(const Duration(milliseconds: 700));
                                  }
                                },
                          child: Text(saving ? 'Saving...' : 'Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.primary,
    required this.secondary,
    this.enabled = true,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color primary;
  final Color secondary;
  final bool enabled;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      style: TextStyle(color: primary, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondary, fontWeight: FontWeight.w600),
        prefixIcon: Icon(icon, color: secondary),
      ),
    );
  }
}
