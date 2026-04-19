import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../cart/data/cart_controller.dart';
import '../../auth/presentation/login_screen.dart';
import '../../orders/data/order_controller.dart';
import '../../profile/data/profile_controller.dart';
import '../../orders/presentation/delivery_tracking_screen.dart';

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
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final profile = ProfileController.instance.value;
    if ((profile?.fullName ?? '').trim().isNotEmpty) {
      _nameController.text = profile!.fullName.trim();
    } else if ((user?.displayName ?? '').trim().isNotEmpty) {
      _nameController.text = user!.displayName!.trim();
    }
    if ((profile?.phone ?? '').trim().isNotEmpty) {
      _phoneController.text = profile!.phone.trim();
    } else if ((user?.phoneNumber ?? '').trim().isNotEmpty) {
      _phoneController.text = user!.phoneNumber!.trim();
    }
    if ((profile?.city ?? '').trim().isNotEmpty) {
      _cityController.text = profile!.city.trim();
    }
    if ((profile?.area ?? '').trim().isNotEmpty) {
      _areaController.text = profile!.area.trim();
    }
    if ((profile?.addressLine ?? '').trim().isNotEmpty) {
      _addressController.text = profile!.addressLine.trim();
    }
  }

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

  Future<void> _requireSignIn() async {
    _showMessage('Sign in first to place your order.');
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen(redirectToCheckout: true)),
    );
  }

  Future<void> _confirmOrder() async {
    final localeCode = Localizations.localeOf(context).languageCode;
    FocusScope.of(context).unfocus();
    if (FirebaseAuth.instance.currentUser == null) {
      await _requireSignIn();
      return;
    }
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
                    localeCode == 'ar' ? 'تم إرسال الطلب بنجاح' : localeCode == 'de' ? 'Bestellung erfolgreich erstellt' : localeCode == 'ru' ? 'Заказ успешно создан' : 'Order placed successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localeCode == 'ar' ? 'رقم الطلب: ${order.id}\nتم استلام طلبك وحالته الآن ${order.status.labelForLocale(localeCode)}.' : localeCode == 'de' ? 'Bestellnummer: ${order.id}\nDeine Bestellung wurde empfangen. Status: ${order.status.labelForLocale(localeCode)}.' : localeCode == 'ru' ? 'Номер заказа: ${order.id}\nВаш заказ принят. Статус: ${order.status.labelForLocale(localeCode)}.' : 'Order ID: ${order.id}\nYour order has been received with status ${order.status.labelForLocale(localeCode)}.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).maybePop();
                          },
                          child: Text(localeCode == 'ar' ? 'العودة للسلة' : localeCode == 'de' ? 'Zurück zum Warenkorb' : localeCode == 'ru' ? 'Назад в корзину' : 'Back to cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DeliveryTrackingScreen(order: order),
                              ),
                            );
                          },
                          child: Text(localeCode == 'ar' ? 'تتبع الطلب' : localeCode == 'de' ? 'Bestellung verfolgen' : localeCode == 'ru' ? 'Отследить заказ' : 'Track order'),
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
    } catch (error) {
      if (!mounted) return;
      _showMessage(localeCode == 'ar' ? 'تعذر إنشاء الطلب الآن. $error' : localeCode == 'de' ? 'Die Bestellung konnte gerade nicht erstellt werden. $error' : localeCode == 'ru' ? 'Не удалось оформить заказ сейчас. $error' : 'Could not place order right now. $error');
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
    final localeCode = Localizations.localeOf(context).languageCode;

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
                                localeCode == 'ar' ? 'أكمل بيانات الطلب لتأكيده فورًا.' : localeCode == 'de' ? 'Vervollständige deine Bestelldaten, um die Bestellung sofort zu bestätigen.' : localeCode == 'ru' ? 'Заполните данные заказа, чтобы сразу подтвердить его.' : 'Complete your order details to confirm it right away.',
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
                          _FieldLabel(label: localeCode == 'ar' ? 'الاسم الكامل' : localeCode == 'de' ? 'Vollständiger Name' : localeCode == 'ru' ? 'Полное имя' : 'Full name', isLight: isLight),
                          _CheckoutTextField(
                            controller: _nameController,
                            hintText: localeCode == 'ar' ? 'أحمد محمد' : 'Ahmed Mohamed',
                            validator: (value) => value == null || value.trim().isEmpty ? (localeCode == 'ar' ? 'من فضلك اكتب الاسم.' : localeCode == 'de' ? 'Bitte gib deinen Namen ein.' : localeCode == 'ru' ? 'Пожалуйста, введите имя.' : 'Please enter your name.') : null,
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(label: localeCode == 'ar' ? 'رقم الهاتف' : localeCode == 'de' ? 'Telefonnummer' : localeCode == 'ru' ? 'Номер телефона' : 'Phone number', isLight: isLight),
                          _CheckoutTextField(
                            controller: _phoneController,
                            hintText: '01xxxxxxxxx',
                            keyboardType: TextInputType.phone,
                            validator: (value) => value == null || value.trim().length < 10 ? (localeCode == 'ar' ? 'من فضلك اكتب رقم هاتف صحيح.' : localeCode == 'de' ? 'Bitte gib eine gültige Telefonnummer ein.' : localeCode == 'ru' ? 'Введите корректный номер телефона.' : 'Please enter a valid phone number.') : null,
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
                          _FieldLabel(label: localeCode == 'ar' ? 'تفاصيل العنوان' : localeCode == 'de' ? 'Adressdetails' : localeCode == 'ru' ? 'Адрес' : 'Address details', isLight: isLight),
                          _CheckoutTextField(
                            controller: _addressController,
                            hintText: 'Street, building, floor, apartment',
                            validator: (value) => value == null || value.trim().isEmpty ? (localeCode == 'ar' ? 'من فضلك اكتب تفاصيل العنوان.' : localeCode == 'de' ? 'Bitte gib deine Adressdetails ein.' : localeCode == 'ru' ? 'Пожалуйста, введите адрес.' : 'Please enter your address details.') : null,
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(label: localeCode == 'ar' ? 'ملاحظات' : localeCode == 'de' ? 'Hinweise' : localeCode == 'ru' ? 'Примечания' : 'Notes', isLight: isLight),
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
                            localeCode == 'ar' ? 'طريقة الدفع' : localeCode == 'de' ? 'Zahlungsmethode' : localeCode == 'ru' ? 'Способ оплаты' : 'Payment method',
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
                                label: Text(method.labelForLocale(localeCode)),
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
                            localeCode == 'ar' ? 'يتم إرسال الطلبات فور التأكيد لتتمكن الإدارة من مراجعتها وتحديث حالتها.' : localeCode == 'de' ? 'Bestellungen werden nach der Bestätigung sofort gesendet, damit das Team sie prüfen und aktualisieren kann.' : localeCode == 'ru' ? 'Заказы отправляются сразу после подтверждения, чтобы команда могла их проверить и обновить статус.' : 'Orders are sent immediately after confirmation so the team can review and update them.',
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
                            localeCode == 'ar' ? 'ملخص الطلب' : localeCode == 'de' ? 'Bestellübersicht' : localeCode == 'ru' ? 'Сводка заказа' : 'Order summary',
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
                            child: Text(_submitting ? context.l10n.loading : (localeCode == 'ar' ? 'تأكيد الطلب' : localeCode == 'de' ? 'Bestellung aufgeben' : localeCode == 'ru' ? 'Оформить заказ' : 'Place order')),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localeCode == 'ar' ? 'لا حاجة إلى لقطة شاشة للدفع. يتم إنشاء الطلب مباشرة بعد التأكيد.' : localeCode == 'de' ? 'Kein Zahlungsscreenshot erforderlich. Die Bestellung wird direkt nach der Bestätigung erstellt.' : localeCode == 'ru' ? 'Скриншот оплаты не требуется. Заказ создается сразу после подтверждения.' : 'No payment screenshot required. The order is created right after confirmation.',
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
