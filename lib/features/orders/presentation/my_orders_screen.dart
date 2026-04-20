import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../data/order_controller.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final l10n = context.l10n;
    final localeCode = Localizations.localeOf(context).languageCode;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: StreamBuilder<List<CavoOrder>>(
            stream: OrderController.instance.watchCurrentUserOrders(),
            builder: (context, snapshot) {
              final orders = snapshot.data ?? const <CavoOrder>[];
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                children: [
                  Row(
                    children: [
                      CavoCircleIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        isLight: isLight,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.myOrders,
                          style: TextStyle(color: primary, fontSize: 28, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (orders.isEmpty)
                    CavoGlassCard(
                      isLight: isLight,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Text(
                        l10n.noOrdersYet,
                        style: TextStyle(color: secondary, fontWeight: FontWeight.w700),
                      ),
                    )
                  else
                    ...orders.map((order) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
                            ),
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
                                        child: Text(order.id, style: TextStyle(color: primary, fontWeight: FontWeight.w900)),
                                      ),
                                      CavoPillTag(
                                        label: order.status.labelForLocale(localeCode),
                                        isLight: isLight,
                                        selected: true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${order.total} EGP • ${order.items.length} ${l10n.itemsShortLabel} • ${order.paymentStatus.labelForLocale(localeCode)}',
                                    style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    order.fulfillmentType == OrderFulfillmentType.branchPickup
                                        ? (localeCode == 'ar' ? order.pickupBranchArabic : order.pickupBranchEnglish)
                                        : '${order.city}, ${order.area}',
                                    style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
