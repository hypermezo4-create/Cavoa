import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum PaymentMethod { vodafoneCash, instaPay }

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _notesController = TextEditingController();

  PaymentMethod? _paymentMethod;
  File? _paymentScreenshot;
  bool _submitting = false;

  static const String _pickupCity = 'Hurghada';
  static const String _vodafoneCashNumber = '01221204322';
  static const String _instaPayLink = 'https://ipn.eg/S/hishamgoudah/instapay/6uMHYp';
  static const String _instaPayHandle = 'hishamgoudah@instapay';
  static const String _ordersWhatsappNumber = '201507433733';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickPaymentScreenshot() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
    );

    if (file == null) return;

    setState(() {
      _paymentScreenshot = File(file.path);
    });
  }

  Future<void> _copyText(String text, String successMessage) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    _showMessage(successMessage);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showMessage('Unable to open this link right now.');
    }
  }

  void _showMessage(String message) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: surface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: primaryText),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
    );
  }

  String _buildOrderMessage() {
    final items = CartController.instance.value;
    final summaryLines = items.map((item) {
      final sizeText = item.size == null ? '' : ' | Size: ${item.size}';
      return '- ${item.product.title} x${item.quantity}$sizeText | ${item.product.price} EGP';
    }).join('\n');

    final paymentLabel = _paymentMethod == PaymentMethod.vodafoneCash
        ? 'Vodafone Cash'
        : 'InstaPay';
    final paymentNote = _paymentMethod == PaymentMethod.vodafoneCash
        ? 'Vodafone Cash Number: $_vodafoneCashNumber'
        : 'InstaPay: $_instaPayHandle';

    final notes = _notesController.text.trim().isEmpty
        ? 'No notes'
        : _notesController.text.trim();

    return 'CAVO Order\n'
        'Name: ${_nameController.text.trim()}\n'
        'Phone: ${_phoneController.text.trim()}\n'
        'City: Hurghada\n'
        'Area: ${_areaController.text.trim()}\n'
        'Pickup: From CAVO store in Hurghada\n'
        'Payment Method: $paymentLabel\n'
        '$paymentNote\n'
        'Order Notes: $notes\n\n'
        'Order Summary:\n'
        '$summaryLines\n\n'
        'Subtotal: ${CartController.instance.subtotal} EGP\n'
        'Store Pickup: 0 EGP\n'
        'Total: ${CartController.instance.total} EGP\n\n'
        'Payment screenshot is prepared by the customer. Please attach it in WhatsApp before sending if it is not attached automatically.';
  }

  Future<void> _openWhatsAppOrder() async {
    final message = Uri.encodeComponent(_buildOrderMessage());
    final url = 'https://wa.me/$_ordersWhatsappNumber?text=$message';
    await _openUrl(url);
  }

  Future<void> _confirmOrder() async {
    FocusScope.of(context).unfocus();

    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _areaController.text.trim().isEmpty) {
      _showMessage('Please complete name, phone number, and area before confirming.');
      return;
    }

    if (_paymentMethod == null) {
      _showMessage('Please choose a payment method before confirming.');
      return;
    }

    if (_paymentScreenshot == null) {
      _showMessage('Please upload a payment screenshot before confirming your order.');
      return;
    }

    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _submitting = false);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final isLight = Theme.of(dialogContext).brightness == Brightness.light;
        final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
        final border = isLight ? CavoColors.lightBorder : CavoColors.border;
        final primaryText = isLight
            ? CavoColors.lightTextPrimary
            : CavoColors.textPrimary;
        final secondaryText = isLight
            ? CavoColors.lightTextSecondary
            : CavoColors.textSecondary;

        return Dialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CavoColors.gold.withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: CavoColors.gold,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Your order has been registered successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'We will contact you soon. Pickup is from the CAVO store in Hurghada only.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Next step: open WhatsApp, review the order text, then attach the same payment screenshot before sending.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    await _openWhatsAppOrder();
                    CartController.instance.clear();
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Open WhatsApp Order'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? CavoColors.lightBackground : CavoColors.background;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final soft = isLight ? CavoColors.lightSurfaceSoft : CavoColors.surfaceSoft;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final mutedText =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    final items = CartController.instance.value;

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? const [
                    Color(0xFFF8F6F1),
                    Color(0xFFF2EEE5),
                    Color(0xFFECE6DA),
                  ]
                : const [
                    Color(0xFF050505),
                    Color(0xFF080808),
                    Color(0xFF0D0A06),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: surface.withOpacity(0.96),
                        shape: BoxShape.circle,
                        border: Border.all(color: border),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: primaryText,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Checkout',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Hurghada only • Pickup from CAVO store only',
                style: TextStyle(
                  color: mutedText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              _CheckoutCard(
                surface: surface,
                border: border,
                isLight: isLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer details',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _CheckoutField(
                      controller: _nameController,
                      hintText: 'Full name',
                      icon: Icons.person_outline_rounded,
                      primaryText: primaryText,
                      fillColor: soft,
                      border: border,
                    ),
                    const SizedBox(height: 14),
                    _CheckoutField(
                      controller: _phoneController,
                      hintText: 'Phone number',
                      icon: Icons.phone_outlined,
                      primaryText: primaryText,
                      fillColor: soft,
                      border: border,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    _LockedField(
                      label: 'City',
                      value: _pickupCity,
                      icon: Icons.location_city_outlined,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      fillColor: soft,
                      border: border,
                    ),
                    const SizedBox(height: 14),
                    _CheckoutField(
                      controller: _areaController,
                      hintText: 'Area / location in Hurghada',
                      icon: Icons.map_outlined,
                      primaryText: primaryText,
                      fillColor: soft,
                      border: border,
                    ),
                    const SizedBox(height: 14),
                    _CheckoutField(
                      controller: _notesController,
                      hintText: 'Order notes',
                      icon: Icons.notes_rounded,
                      primaryText: primaryText,
                      fillColor: soft,
                      border: border,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _CheckoutCard(
                surface: surface,
                border: border,
                isLight: isLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment method',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _PaymentOptionCard(
                      title: 'Vodafone Cash',
                      subtitle: 'Transfer to $_vodafoneCashNumber',
                      selected: _paymentMethod == PaymentMethod.vodafoneCash,
                      isLight: isLight,
                      onTap: () {
                        setState(() => _paymentMethod = PaymentMethod.vodafoneCash);
                      },
                      extra: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Send the total amount to Vodafone Cash number $_vodafoneCashNumber, then upload the payment screenshot before confirming the order.',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () => _copyText(
                              _vodafoneCashNumber,
                              'Vodafone Cash number copied successfully.',
                            ),
                            child: const Text('Copy Vodafone Cash Number'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentOptionCard(
                      title: 'InstaPay',
                      subtitle: 'Pay using the live InstaPay link',
                      selected: _paymentMethod == PaymentMethod.instaPay,
                      isLight: isLight,
                      onTap: () {
                        setState(() => _paymentMethod = PaymentMethod.instaPay);
                      },
                      extra: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Use the real payment link or send directly to $_instaPayHandle, then upload the payment screenshot before confirming.',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _openUrl(_instaPayLink),
                                  child: const Text('Open InstaPay Link'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () => _copyText(
                              _instaPayHandle,
                              'InstaPay ID copied successfully.',
                            ),
                            child: const Text('Copy InstaPay ID'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _CheckoutCard(
                surface: surface,
                border: border,
                isLight: isLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment screenshot',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Upload the transfer screenshot before confirming your order. This is required.',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_paymentScreenshot != null)
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: border),
                          image: DecorationImage(
                            image: FileImage(_paymentScreenshot!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
                        decoration: BoxDecoration(
                          color: soft,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              color: CavoColors.gold,
                              size: 34,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No payment screenshot selected yet',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: _pickPaymentScreenshot,
                      child: Text(
                        _paymentScreenshot == null
                            ? 'Upload Payment Screenshot'
                            : 'Change Payment Screenshot',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _CheckoutCard(
                surface: surface,
                border: border,
                isLight: isLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order summary',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...items.map(
                      (item) {
                        final sizeText = item.size == null ? '' : ' • Size ${item.size}';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.product.title} x${item.quantity}$sizeText',
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${item.product.price * item.quantity} EGP',
                                style: const TextStyle(
                                  color: CavoColors.gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: border, height: 1),
                    ),
                    _SummaryRow(
                      label: 'Subtotal',
                      value: '${CartController.instance.subtotal} EGP',
                      textColor: secondaryText,
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: 'Store Pickup',
                      value: '0 EGP',
                      textColor: secondaryText,
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: 'Total',
                      value: '${CartController.instance.total} EGP',
                      textColor: primaryText,
                      highlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: _submitting ? null : _confirmOrder,
                child: Text(_submitting ? 'Confirming...' : 'Confirm Order'),
              ),
              const SizedBox(height: 12),
              Text(
                'All required details must be completed. Orders are for Hurghada pickup only, and we will contact you after review.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutCard extends StatelessWidget {
  final Widget child;
  final Color surface;
  final Color border;
  final bool isLight;

  const _CheckoutCard({
    required this.child,
    required this.surface,
    required this.border,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
        boxShadow: [
          if (isLight)
            BoxShadow(
              color: CavoColors.lightShadow.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: child,
    );
  }
}

class _CheckoutField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color primaryText;
  final Color fillColor;
  final Color border;
  final int maxLines;
  final TextInputType? keyboardType;

  const _CheckoutField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.primaryText,
    required this.fillColor,
    required this.border,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: primaryText),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: CavoColors.gold,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _LockedField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color primaryText;
  final Color secondaryText;
  final Color fillColor;
  final Color border;

  const _LockedField({
    required this.label,
    required this.value,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
    required this.fillColor,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, color: CavoColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final bool isLight;
  final VoidCallback onTap;
  final Widget? extra;

  const _PaymentOptionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.isLight,
    required this.onTap,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final subtitleColor =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? CavoColors.gold.withOpacity(0.10)
              : surface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? CavoColors.gold.withOpacity(0.32)
                : border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected ? CavoColors.gold : subtitleColor,
                ),
              ],
            ),
            if (selected && extra != null) extra!,
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textColor,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: highlight ? 15 : 13,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? CavoColors.gold : textColor,
            fontSize: highlight ? 16 : 13,
            fontWeight: highlight ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
