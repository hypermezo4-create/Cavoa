import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final CavoOrder order;

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
          child: ListView(
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
                      l10n.orderDetailsTitle,
                      style: TextStyle(color: primary, fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.id, style: TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    _meta(l10n.statusLabel, order.status.labelForLocale(localeCode), primary, secondary),
                    _meta(l10n.paymentLabel, order.paymentMethod.labelForLocale(localeCode), primary, secondary),
                    _meta(l10n.paymentStatusLabel, order.paymentStatus.labelForLocale(localeCode), primary, secondary),
                    _meta(l10n.fulfillmentLabel, order.fulfillmentType.labelForLocale(localeCode), primary, secondary),
                    _meta(l10n.placedAtLabel, order.createdAt.toLocal().toString(), primary, secondary),
                    if (order.fulfillmentType == OrderFulfillmentType.branchPickup)
                      _meta(
                        l10n.pickupBranchLabel,
                        localeCode == 'ar' ? order.pickupBranchArabic : order.pickupBranchEnglish,
                        primary,
                        secondary,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.itemsLabel, style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.title} ${item.size == null ? '' : '(${item.size})'} x${item.quantity}',
                                  style: TextStyle(color: primary, fontWeight: FontWeight.w700),
                                ),
                              ),
                              Text('${item.total} EGP', style: TextStyle(color: secondary, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Column(
                  children: [
                    _meta(l10n.customerLabel, order.customerName, primary, secondary),
                    _meta(l10n.phoneLabel, order.phoneNumber, primary, secondary),
                    _meta(l10n.cityLabel, order.city, primary, secondary),
                    _meta(l10n.areaLabel, order.area, primary, secondary),
                    _meta(l10n.addressLabel, order.addressLine, primary, secondary),
                    if (order.notes.trim().isNotEmpty) _meta(l10n.notesLabel, order.notes, primary, secondary),
                    _meta(l10n.subtotal, '${order.subtotal} EGP', primary, secondary),
                    _meta(l10n.deliveryPickupFeeLabel, '${order.pickupFee} EGP', primary, secondary),
                    _meta(l10n.total, '${order.total} EGP', primary, secondary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meta(String label, String value, Color primary, Color secondary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
