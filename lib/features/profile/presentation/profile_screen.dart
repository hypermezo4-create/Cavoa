import 'dart:io';

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
import '../../favorites/data/favorites_controller.dart';
import '../../orders/data/order_controller.dart';
import '../../notifications/data/notification_center_controller.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../orders/presentation/my_orders_screen.dart';
import '../../orders/presentation/order_details_screen.dart';
import '../../favorites/presentation/favorites_screen.dart';
import '../../admin_orders/presentation/admin_orders_dashboard_screen.dart';
import '../data/profile_controller.dart';
import '../../welcome/presentation/welcome_placeholder_screen.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final user = FirebaseAuth.instance.currentUser;
    final l10n = context.l10n;
    final profile = ProfileController.instance.value;

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
                    ? l10n.guestModeSignInForFullAccess
                    : l10n.signedInSecurely,
                action: user == null ? null : l10n.edit,
                onActionTap: user == null
                    ? null
                    : () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
                        );
                      },
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
                        child: (profile?.avatarPath != null && profile!.avatarPath!.isNotEmpty)
                            ? Image.file(File(profile.avatarPath!), fit: BoxFit.cover)
                            : Image.asset('assets/branding/cavo_logo_circle.png', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.fullName.trim().isNotEmpty == true
                                ? profile!.fullName
                                : (user?.displayName?.trim().isNotEmpty == true ? user!.displayName! : (user?.email ?? l10n.cavoMember)),
                            style: TextStyle(
                              color: primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            profile?.email.isNotEmpty == true ? profile!.email : (user?.email ?? context.l10n.guestModeSignInForFullAccess),
                            style: TextStyle(
                              color: secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CavoPillTag(
                            label: user == null ? l10n.guestMode : l10n.cavoAccount,
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
                          subtitle: l10n.itemsSavedLabel,
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
                            subtitle: l10n.localOnly,
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
                                subtitle: l10n.securelySynced,
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
                subtitle: l10n.currentLanguageCode(AppLocaleController.instance.code),
                isLight: isLight,
                trailing: CavoLanguagePicker(isLight: isLight, expanded: false),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeModeController.instance,
                builder: (context, mode, _) {
                  final isCurrentlyLight = mode == ThemeMode.light;
                  return _ProfileActionTile(
                    title: l10n.appearance,
                    subtitle: isCurrentlyLight ? l10n.lightModePremiumOn : l10n.darkModePremiumOn,
                    isLight: isLight,
                    trailing: Switch.adaptive(
                      value: isCurrentlyLight,
                      activeColor: CavoColors.gold,
                      onChanged: (_) => ThemeModeController.instance.toggle(),
                    ),
                    onTap: ThemeModeController.instance.toggle,
                  );
                },
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<Set<String>>(
                valueListenable: FavoritesController.instance,
                builder: (context, favorites, _) {
                  return _ProfileActionTile(
                    title: context.l10n.favorites,
                    subtitle: '${favorites.length} ${context.l10n.itemsCountLabel} ${context.l10n.savedForLater}',
                    isLight: isLight,
                    trailing: const Icon(Icons.favorite_rounded, color: CavoColors.gold),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              if (user != null)
                Column(
                  children: [
                    _ProfileActionTile(
                      title: l10n.adminOrders,
                      subtitle: l10n.adminOrdersSubtitle,
                      isLight: isLight,
                      trailing: const Icon(Icons.admin_panel_settings_outlined, color: CavoColors.gold),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AdminOrdersDashboardScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ValueListenableBuilder<List<CavoNotificationItem>>(
                valueListenable: NotificationCenterController.instance,
                builder: (context, notifications, _) {
                  final unread = NotificationCenterController.instance.unreadCount;
                  return _ProfileActionTile(
                    title: l10n.notifications,
                    subtitle: unread == 0
                        ? l10n.noUnreadUpdates
                        : l10n.unreadUpdatesCount(unread),
                    isLight: isLight,
                    trailing: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications_none_rounded, color: CavoColors.gold),
                        if (unread > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: CavoColors.gold,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                unread > 9 ? '9+' : '$unread',
                                style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              CavoSectionHeader(
                title: context.l10n.orders,
                subtitle: user == null
                    ? l10n.signInToTrackOrders
                    : l10n.recentOrdersLatestStatus,
                action: user == null ? null : l10n.viewAll,
                onActionTap: user == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                        );
                      },
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
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.loggedOutSuccessfully)),
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const WelcomePlaceholderScreen()),
                        (route) => false,
                      );
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
  final VoidCallback? onTap;

  const _ProfileActionTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.isLight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: CavoGlassCard(
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
      ),
    );
  }
}

class _OrdersPlaceholder extends StatelessWidget {
  final bool isLight;

  const _OrdersPlaceholder({required this.isLight});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
            l10n.noSavedOrdersYet,
            style: TextStyle(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ordersPlaceholderSubtitle,
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
    final localeCode = Localizations.localeOf(context).languageCode;
    final l10n = context.l10n;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(order: order),
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
                  label: order.status.labelForLocale(Localizations.localeOf(context).languageCode),
                  isLight: isLight,
                  selected: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${order.total} EGP • ${order.items.length} ${l10n.itemsShortLabel} • ${order.paymentMethod.labelForLocale(localeCode)}',
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
                    order.isRated
                        ? l10n.ratedOutOfFive(order.rating)
                        : l10n.tapToViewDetails,
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
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final l10n = context.l10n;
      final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
      final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
      bool saving = false;
      bool success = false;
      return StatefulBuilder(
        builder: (context, setModalState) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14,
              top: 14,
            ),
            child: FractionallySizedBox(
              heightFactor: 0.86,
              child: CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(34)),
                child: Column(
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
                      l10n.editProfile,
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SheetField(controller: nameController, label: l10n.fullName, icon: Icons.person_outline_rounded, primary: primary, secondary: secondary),
                            const SizedBox(height: 12),
                            _SheetField(controller: emailController, label: l10n.emailAddress, icon: Icons.mail_outline_rounded, primary: primary, secondary: secondary, enabled: false),
                            const SizedBox(height: 12),
                            _SheetField(controller: phoneController, label: l10n.phoneNumber, icon: Icons.phone_outlined, primary: primary, secondary: secondary),
                            const SizedBox(height: 12),
                            _SheetField(controller: locationController, label: l10n.location, icon: Icons.location_on_outlined, primary: primary, secondary: secondary),
                            const SizedBox(height: 12),
                            _SheetField(controller: bioController, label: l10n.bio, icon: Icons.info_outline_rounded, primary: primary, secondary: secondary, maxLines: 2),
                            const SizedBox(height: 18),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: success
                                  ? Row(
                                      key: const ValueKey('ok'),
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, color: Color(0xFF2DBA71)),
                                        const SizedBox(width: 8),
                                        Text(l10n.profileSaved, style: const TextStyle(color: Color(0xFF2DBA71), fontWeight: FontWeight.w800)),
                                      ],
                                    )
                                  : const SizedBox.shrink(key: ValueKey('idle')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: saving ? null : () => Navigator.of(context).pop(),
                            child: Text(l10n.cancel),
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
                                      if (context.mounted) Navigator.of(context).pop();
                                    }
                                  },
                            child: Text(saving ? l10n.sending : l10n.saveChanges),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
