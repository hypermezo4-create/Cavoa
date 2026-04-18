import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../cart/data/cart_controller.dart';
import '../../orders/data/order_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController(text: 'Hurghada');
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  OrderPaymentMethod _paymentMethod = OrderPaymentMethod.vodafoneCash;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final textColor = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: surface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
      ),
    );
  }

  Future<void> _confirmOrder() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (CartController.instance.value.isEmpty) {
      _showMessage(context.l10n.yourCartIsEmpty);
      return;
    }

    setState(() => _submitting = true);
    try {
      final order = await OrderController.instance.createOrderFromCart(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        addressLine: _addressController.text.trim(),
        notes: _notesController.text.trim(),
        paymentMethod: _paymentMethod,
      );

      CartController.instance.clear();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          final isLight = Theme.of(dialogContext).brightness == Brightness.light;
          final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
          final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
          return Dialog(
            backgroundColor: Colors.transparent,
            child: CavoGlassCard(
              isLight: isLight,
              borderRadius: const BorderRadius.all(Radius.circular(34)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CavoColors.gold.withValues(alpha: 0.12),
                    ),
                    child: const Icon(Icons.check_rounded, color: CavoColors.gold, size: 40),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Order placed successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Order ID: ${order.id}\nYour order is now saved in Firebase with status ${order.status.label}.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).maybePop();
                      },
                      child: const Text('Back to cart'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage('Could not place order right now. $error');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
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
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 160),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.checkout,
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Complete your order details and send the order directly to Firebase.',
                                style: TextStyle(
                                  color: secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    CavoGlassCard(
                      isLight: isLight,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel(label: 'Full name', isLight: isLight),
                          _CheckoutTextField(
                            controller: _nameController,
                            hintText: 'Ahmed Mohamed',
                            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name.' : null,
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(label: 'Phone number', isLight: isLight),
                          _CheckoutTextField(
                            controller: _phoneController,
                            hintText: '01xxxxxxxxx',
                            keyboardType: TextInputType.phone,
                            validator: (value) => value == null || value.trim().length < 10 ? 'Please enter a valid phone number.' : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(label: 'City', isLight: isLight),
                                    _CheckoutTextField(
                                      controller: _cityController,
                                      hintText: 'Hurghada',
                                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your city.' : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(label: 'Area', isLight: isLight),
                                    _CheckoutTextField(
                                      controller: _areaController,
                                      hintText: 'Arabia / El Kawther',
                                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your area.' : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(label: 'Address details', isLight: isLight),
                          _CheckoutTextField(
                            controller: _addressController,
                            hintText: 'Street, building, floor, apartment',
                            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your address details.' : null,
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(label: 'Notes', isLight: isLight),
                          _CheckoutTextField(
                            controller: _notesController,
                            hintText: 'Optional delivery notes',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CavoGlassCard(
                      isLight: isLight,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment method',
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: OrderPaymentMethod.values.map((method) {
                              final selected = method == _paymentMethod;
                              return ChoiceChip(
                                selected: selected,
                                label: Text(method.label),
                                onSelected: (_) => setState(() => _paymentMethod = method),
                                selectedColor: CavoColors.gold.withValues(alpha: 0.20),
                                backgroundColor: isLight ? Colors.white : CavoColors.surfaceSoft,
                                labelStyle: TextStyle(
                                  color: selected ? primary : secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                                side: BorderSide(
                                  color: selected ? CavoColors.gold.withValues(alpha: 0.28) : (isLight ? CavoColors.lightBorder : CavoColors.border),
                                ),
                              );
                            }).toList(growable: false),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Orders are sent to Firebase immediately after confirmation so you can approve or reject them from the admin side.',
                            style: TextStyle(
                              color: secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CavoGlassCard(
                      isLight: isLight,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order summary',
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...CartController.instance.value.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.product.title} x${item.quantity}${item.size == null ? '' : ' • ${item.size}'}',
                                      style: TextStyle(
                                        color: primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${item.product.price * item.quantity} EGP',
                                    style: const TextStyle(
                                      color: CavoColors.gold,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 22, color: CavoColors.border),
                          _SummaryRow(label: context.l10n.subtotal, value: '${CartController.instance.subtotal} EGP', isLight: isLight),
                          const SizedBox(height: 8),
                          _SummaryRow(label: context.l10n.storePickup, value: '${CartController.instance.delivery} EGP', isLight: isLight),
                          const SizedBox(height: 8),
                          _SummaryRow(label: context.l10n.total, value: '${CartController.instance.total} EGP', isLight: isLight, highlight: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: SafeArea(
                  child: CavoGlassCard(
                    isLight: isLight,
                    padding: const EdgeInsets.all(14),
                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitting ? null : _confirmOrder,
                            child: Text(_submitting ? context.l10n.loading : 'Place order'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No payment screenshot required. The order is created directly in Firebase.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                      ],
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

class _CheckoutTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

  const _CheckoutTextField({
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isLight;

  const _FieldLabel({required this.label, required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLight;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isLight,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlight
        ? CavoColors.gold
        : (isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary);
    final valueColor = highlight
        ? CavoColors.gold
        : (isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: highlight ? 17 : 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
