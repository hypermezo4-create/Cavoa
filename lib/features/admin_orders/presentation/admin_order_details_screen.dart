import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../data/admin_orders_controller.dart';

class AdminOrderDetailsScreen extends StatefulWidget {
  const AdminOrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<AdminOrderDetailsScreen> createState() => _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  bool _saving = false;

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _saving = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.orderUpdatedSuccessfully)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.l10n.failedToUpdateOrder}: $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<String?> _askText({
    required String title,
    required String hint,
    bool requiredValue = false,
  }) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.cancel)),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (requiredValue && value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.thisFieldIsRequired)),
                  );
                  return;
                }
                Navigator.of(context).pop(value);
              },
              child: Text(context.l10n.save),
            ),
          ],
        );
      },
    );
  }

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
          child: StreamBuilder<CavoOrder?>(
            stream: AdminOrdersController.instance.watchOrder(widget.orderId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final order = snapshot.data;
              if (order == null) {
                return Center(child: Text(l10n.orderNotFound));
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                children: [
                  Row(
                    children: [
                      CavoCircleIconButton(icon: Icons.arrow_back_ios_new_rounded, isLight: isLight, onTap: () => Navigator.of(context).maybePop()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(l10n.adminOrderDetailsTitle, style: TextStyle(color: primary, fontSize: 24, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CavoGlassCard(
                    isLight: isLight,
                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.id, style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        _meta(l10n.customerLabel, order.customerName, primary, secondary),
                        _meta(l10n.phoneLabel, order.phoneNumber, primary, secondary),
                        _meta(l10n.fulfillmentLabel, order.fulfillmentType.labelForLocale(localeCode), primary, secondary),
                        _meta(l10n.pickupBranchLabel, order.fulfillmentType == OrderFulfillmentType.branchPickup ? '${order.pickupBranchArabic} / ${order.pickupBranchEnglish}' : '-', primary, secondary),
                        _meta(l10n.deliveryAddressLabel, '${order.city} - ${order.area} - ${order.addressLine}', primary, secondary),
                        _meta(l10n.paymentMethodLabel, order.paymentMethod.labelForLocale(localeCode), primary, secondary),
                        _meta(l10n.paymentStatusLabel, order.paymentStatus.labelForLocale(localeCode), primary, secondary),
                        _meta(l10n.orderStatusLabel, order.status.labelForLocale(localeCode), primary, secondary),
                        _meta(l10n.subtotal, '${order.subtotal} EGP', primary, secondary),
                        _meta(l10n.deliveryFeeLabel, '${order.pickupFee} EGP', primary, secondary),
                        _meta(l10n.total, '${order.total} EGP', primary, secondary),
                        _meta(l10n.notesLabel, order.notes.isEmpty ? '-' : order.notes, primary, secondary),
                        _meta(l10n.adminNoteLabel, order.adminNote.isEmpty ? '-' : order.adminNote, primary, secondary),
                        _meta(l10n.rejectionReasonLabel, order.rejectionReason.isEmpty ? '-' : order.rejectionReason, primary, secondary),
                        _meta(l10n.createdAtLabel, order.createdAt.toLocal().toString(), primary, secondary),
                        _meta(l10n.updatedAtLabel, (order.updatedAt ?? order.createdAt).toLocal().toString(), primary, secondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CavoGlassCard(
                    isLight: isLight,
                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.itemsLabel, style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('${item.title} (${item.size ?? '-'}) x${item.quantity}', style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
                                ),
                                Text('${item.total} EGP', style: TextStyle(color: secondary, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _action(l10n.approve, _saving ? null : () => _runAction(() => AdminOrdersController.instance.approveOrder(order.id))),
                      _action(l10n.reject, _saving ? null : () async {
                        final reason = await _askText(title: l10n.rejectionReasonLabel, hint: l10n.requiredLabel, requiredValue: true);
                        if (reason == null) return;
                        await _runAction(() => AdminOrdersController.instance.rejectOrder(orderId: order.id, rejectionReason: reason));
                      }),
                      _action(l10n.markProcessing, _saving ? null : () => _runAction(() => AdminOrdersController.instance.markProcessing(order.id))),
                      _action(l10n.markShipped, _saving ? null : () => _runAction(() => AdminOrdersController.instance.markShipped(order.id))),
                      _action(l10n.markDelivered, _saving ? null : () => _runAction(() => AdminOrdersController.instance.markDelivered(order.id))),
                      _action(l10n.cancel, _saving ? null : () => _runAction(() => AdminOrdersController.instance.cancelOrder(order.id))),
                      _action(l10n.updatePayment, _saving ? null : () async {
                        final status = await showDialog<OrderPaymentStatus>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Text(l10n.updatePaymentStatus),
                            children: OrderPaymentStatus.values
                                .map((value) => SimpleDialogOption(
                                      onPressed: () => Navigator.of(context).pop(value),
                                      child: Text(value.labelForLocale(localeCode)),
                                    ))
                                .toList(growable: false),
                          ),
                        );
                        if (status == null) return;
                        await _runAction(() => AdminOrdersController.instance.updatePaymentStatus(orderId: order.id, paymentStatus: status));
                      }),
                      _action(l10n.addAdminNote, _saving ? null : () async {
                        final note = await _askText(title: l10n.adminNoteLabel, hint: l10n.writeANote, requiredValue: true);
                        if (note == null) return;
                        await _runAction(() => AdminOrdersController.instance.addAdminNote(orderId: order.id, adminNote: note));
                      }),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _action(String text, VoidCallback? onTap) {
    return ElevatedButton(onPressed: onTap, child: Text(text));
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
          Expanded(child: Text(value, style: TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
