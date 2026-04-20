import 'package:flutter/material.dart';

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
        const SnackBar(content: Text('Order updated successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order: $error')),
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
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (requiredValue && value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This field is required.')),
                  );
                  return;
                }
                Navigator.of(context).pop(value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
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
                return const Center(child: Text('Order not found.'));
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                children: [
                  Row(
                    children: [
                      CavoCircleIconButton(icon: Icons.arrow_back_ios_new_rounded, isLight: isLight, onTap: () => Navigator.of(context).maybePop()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Admin Order Details', style: TextStyle(color: primary, fontSize: 24, fontWeight: FontWeight.w900)),
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
                        _meta('Customer', order.customerName, primary, secondary),
                        _meta('Phone', order.phoneNumber, primary, secondary),
                        _meta('Fulfillment', order.fulfillmentType.key, primary, secondary),
                        _meta('Pickup branch', order.fulfillmentType == OrderFulfillmentType.branchPickup ? 'مول سيتي سنتر طريق عربيا / Mall City Center, Arabeya Road' : '-', primary, secondary),
                        _meta('Delivery address', '${order.city} - ${order.area} - ${order.addressLine}', primary, secondary),
                        _meta('Payment method', order.paymentMethod.key, primary, secondary),
                        _meta('Payment status', order.paymentStatus.key, primary, secondary),
                        _meta('Order status', order.status.key, primary, secondary),
                        _meta('Subtotal', '${order.subtotal} EGP', primary, secondary),
                        _meta('Delivery fee', '${order.pickupFee} EGP', primary, secondary),
                        _meta('Total', '${order.total} EGP', primary, secondary),
                        _meta('Notes', order.notes.isEmpty ? '-' : order.notes, primary, secondary),
                        _meta('Admin note', order.adminNote.isEmpty ? '-' : order.adminNote, primary, secondary),
                        _meta('Rejection reason', order.rejectionReason.isEmpty ? '-' : order.rejectionReason, primary, secondary),
                        _meta('Created at', order.createdAt.toLocal().toString(), primary, secondary),
                        _meta('Updated at', (order.updatedAt ?? order.createdAt).toLocal().toString(), primary, secondary),
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
                        Text('Items', style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w900)),
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
                      _action('Approve', _saving ? null : () => _runAction(() => AdminOrdersController.instance.approveOrder(order.id))),
                      _action('Reject', _saving ? null : () async {
                        final reason = await _askText(title: 'Rejection reason', hint: 'Required', requiredValue: true);
                        if (reason == null) return;
                        await _runAction(() => AdminOrdersController.instance.rejectOrder(orderId: order.id, rejectionReason: reason));
                      }),
                      _action('Mark processing', _saving ? null : () => _runAction(() => AdminOrdersController.instance.markProcessing(order.id))),
                      _action('Mark shipped', _saving ? null : () => _runAction(() => AdminOrdersController.instance.markShipped(order.id))),
                      _action('Mark delivered', _saving ? null : () => _runAction(() => AdminOrdersController.instance.markDelivered(order.id))),
                      _action('Cancel', _saving ? null : () => _runAction(() => AdminOrdersController.instance.cancelOrder(order.id))),
                      _action('Update payment', _saving ? null : () async {
                        final status = await showDialog<OrderPaymentStatus>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text('Update payment status'),
                            children: OrderPaymentStatus.values
                                .map((value) => SimpleDialogOption(
                                      onPressed: () => Navigator.of(context).pop(value),
                                      child: Text(value.key),
                                    ))
                                .toList(growable: false),
                          ),
                        );
                        if (status == null) return;
                        await _runAction(() => AdminOrdersController.instance.updatePaymentStatus(orderId: order.id, paymentStatus: status));
                      }),
                      _action('Add admin note', _saving ? null : () async {
                        final note = await _askText(title: 'Admin note', hint: 'Write a note', requiredValue: true);
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
