import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../auth/presentation/login_screen.dart';
import '../../cart/data/cart_controller.dart';
import '../../orders/data/order_controller.dart';
import '../../orders/presentation/delivery_tracking_screen.dart';
import '../../profile/data/profile_controller.dart';

const String _fixedPickupBranchArabic = 'مول سيتي سنتر طريق عربيا';
const String _fixedPickupBranchEnglish = 'Mall City Center, Arabeya Road';

enum _FulfillmentType { delivery, branchPickup }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController(text: 'Hurghada');
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _notesController = TextEditingController();

  _FulfillmentType _fulfillmentType = _FulfillmentType.delivery;
  bool _submitting = false;

  bool get _isDelivery => _fulfillmentType == _FulfillmentType.delivery;

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
    _governorateController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final textColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

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
    final localeCode = Localizations.localeOf(context).languageCode;
    _showMessage(
      localeCode == 'ar'
          ? 'سجّل الدخول أولًا لإتمام طلبك.'
          : localeCode == 'de'
              ? 'Melde dich zuerst an, um deine Bestellung aufzugeben.'
              : localeCode == 'ru'
                  ? 'Сначала войдите, чтобы оформить заказ.'
                  : 'Sign in first to place your order.',
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(redirectToCheckout: true),
      ),
    );
  }

  String _fulfillmentLabel(String localeCode) {
    switch (localeCode) {
      case 'ar':
        return _isDelivery ? 'توصيل' : 'استلام من الفرع';
      case 'de':
        return _isDelivery ? 'Lieferung' : 'Filialabholung';
      case 'ru':
        return _isDelivery ? 'Доставка' : 'Самовывоз из филиала';
      default:
        return _isDelivery ? 'Delivery' : 'Branch Pickup';
    }
  }

  String _deliveryFeeLabel(String localeCode) {
    if (localeCode == 'ar') return 'رسوم التوصيل';
    if (localeCode == 'de') return 'Liefergebühr';
    if (localeCode == 'ru') return 'Стоимость доставки';
    return 'Delivery fee';
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
      final addressSegments = <String>[];
      if (_governorateController.text.trim().isNotEmpty) {
        addressSegments.add(
          localeCode == 'ar'
              ? 'المحافظة: ${_governorateController.text.trim()}'
              : localeCode == 'de'
                  ? 'Gouvernement: ${_governorateController.text.trim()}'
                  : localeCode == 'ru'
                      ? 'Губернаторство: ${_governorateController.text.trim()}'
                      : 'Governorate: ${_governorateController.text.trim()}',
        );
      }
      if (_landmarkController.text.trim().isNotEmpty) {
        addressSegments.add(
          localeCode == 'ar'
              ? 'العلامة المميزة: ${_landmarkController.text.trim()}'
              : localeCode == 'de'
                  ? 'Orientierungspunkt: ${_landmarkController.text.trim()}'
                  : localeCode == 'ru'
                      ? 'Ориентир: ${_landmarkController.text.trim()}'
                      : 'Landmark: ${_landmarkController.text.trim()}',
        );
      }
      if (!_isDelivery) {
        addressSegments.add(
          localeCode == 'ar'
              ? 'فرع الاستلام: $_fixedPickupBranchArabic ($_fixedPickupBranchEnglish)'
              : localeCode == 'de'
                  ? 'Abholfiliale: $_fixedPickupBranchArabic ($_fixedPickupBranchEnglish)'
                  : localeCode == 'ru'
                      ? 'Филиал самовывоза: $_fixedPickupBranchArabic ($_fixedPickupBranchEnglish)'
                      : 'Pickup branch: $_fixedPickupBranchArabic ($_fixedPickupBranchEnglish)',
        );
      }
      if (_addressController.text.trim().isNotEmpty && !_isDelivery) {
        addressSegments.add(
          localeCode == 'ar'
              ? 'ملاحظة عنوان إضافية: ${_addressController.text.trim()}'
              : localeCode == 'de'
                  ? 'Zusätzliche Adressnotiz: ${_addressController.text.trim()}'
                  : localeCode == 'ru'
                      ? 'Дополнительная заметка к адресу: ${_addressController.text.trim()}'
                      : 'Extra address note: ${_addressController.text.trim()}',
        );
      }

      final order = await OrderController.instance.createOrderFromCart(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        addressLine: addressSegments.isEmpty
            ? _addressController.text.trim()
            : '${_addressController.text.trim()}\n${addressSegments.join('\n')}'.trim(),
        notes: _notesController.text.trim(),
        paymentMethod: OrderPaymentMethod.instaPay,
        fulfillmentType: _isDelivery ? OrderFulfillmentType.delivery : OrderFulfillmentType.branchPickup,
      );

      CartController.instance.clear();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          final isLight = Theme.of(dialogContext).brightness == Brightness.light;
          final primary =
              isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
          final secondary =
              isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
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
                    child:
                        const Icon(Icons.check_rounded, color: CavoColors.gold, size: 40),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    localeCode == 'ar'
                        ? 'تم إرسال الطلب بنجاح'
                        : localeCode == 'de'
                            ? 'Bestellung erfolgreich erstellt'
                            : localeCode == 'ru'
                                ? 'Заказ успешно создан'
                                : 'Order placed successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localeCode == 'ar'
                        ? 'رقم الطلب: ${order.id}\nتم استلام طلبك وحالته الآن ${order.status.labelForLocale(localeCode)}.'
                        : localeCode == 'de'
                            ? 'Bestellnummer: ${order.id}\nDeine Bestellung wurde empfangen. Status: ${order.status.labelForLocale(localeCode)}.'
                            : localeCode == 'ru'
                                ? 'Номер заказа: ${order.id}\nВаш заказ принят. Статус: ${order.status.labelForLocale(localeCode)}.'
                                : 'Order ID: ${order.id}\nYour order has been received with status ${order.status.labelForLocale(localeCode)}.',
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
                          child: Text(
                            localeCode == 'ar'
                                ? 'العودة للسلة'
                                : localeCode == 'de'
                                    ? 'Zurück zum Warenkorb'
                                    : localeCode == 'ru'
                                        ? 'Назад в корзину'
                                        : 'Back to cart',
                          ),
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
                          child: Text(
                            localeCode == 'ar'
                                ? 'تتبع الطلب'
                                : localeCode == 'de'
                                    ? 'Bestellung verfolgen'
                                    : localeCode == 'ru'
                                        ? 'Отследить заказ'
                                        : 'Track order',
                          ),
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
      _showMessage(
        localeCode == 'ar'
            ? 'تعذر إنشاء الطلب الآن. $error'
            : localeCode == 'de'
                ? 'Die Bestellung konnte gerade nicht erstellt werden. $error'
                : localeCode == 'ru'
                    ? 'Не удалось оформить заказ сейчас. $error'
                    : 'Could not place order right now. $error',
      );
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
    final secondary =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
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
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 176),
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
                                localeCode == 'ar'
                                    ? 'أكمل بياناتك، اختر طريقة الاستلام، وراجع الطلب قبل التأكيد.'
                                    : localeCode == 'de'
                                        ? 'Vervollständige deine Daten, wähle die Erfüllungsart und prüfe die Bestellung vor dem Bestätigen.'
                                        : localeCode == 'ru'
                                            ? 'Заполните данные, выберите способ получения и проверьте заказ перед подтверждением.'
                                            : 'Complete your details, choose fulfillment type, and review your order before confirmation.',
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
                          Text(
                            localeCode == 'ar'
                                ? 'طريقة الاستلام'
                                : localeCode == 'de'
                                    ? 'Erfüllungsart'
                                    : localeCode == 'ru'
                                        ? 'Способ получения'
                                        : 'Fulfillment type',
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
                            children: [
                              _FulfillmentChoice(
                                isLight: isLight,
                                selected: _isDelivery,
                                label: localeCode == 'ar'
                                    ? 'توصيل'
                                    : localeCode == 'de'
                                        ? 'Lieferung'
                                        : localeCode == 'ru'
                                            ? 'Доставка'
                                            : 'Delivery',
                                icon: Icons.local_shipping_outlined,
                                onTap: () => setState(
                                  () => _fulfillmentType = _FulfillmentType.delivery,
                                ),
                              ),
                              _FulfillmentChoice(
                                isLight: isLight,
                                selected: !_isDelivery,
                                label: localeCode == 'ar'
                                    ? 'استلام من الفرع'
                                    : localeCode == 'de'
                                        ? 'Filialabholung'
                                        : localeCode == 'ru'
                                            ? 'Самовывоз из филиала'
                                            : 'Branch pickup',
                                icon: Icons.storefront_outlined,
                                onTap: () => setState(
                                  () =>
                                      _fulfillmentType = _FulfillmentType.branchPickup,
                                ),
                              ),
                            ],
                          ),
                          if (!_isDelivery) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: CavoColors.gold.withValues(alpha: 0.08),
                                border: Border.all(
                                  color: CavoColors.gold.withValues(alpha: 0.24),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localeCode == 'ar'
                                        ? 'فرع الاستلام'
                                        : localeCode == 'de'
                                            ? 'Abholfiliale'
                                            : localeCode == 'ru'
                                                ? 'Пункт самовывоза'
                                                : 'Pickup branch',
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _fixedPickupBranchArabic,
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _fixedPickupBranchEnglish,
                                    style: TextStyle(
                                      color: secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                          _FieldLabel(
                            label: localeCode == 'ar'
                                ? 'الاسم الكامل'
                                : localeCode == 'de'
                                    ? 'Vollständiger Name'
                                    : localeCode == 'ru'
                                        ? 'Полное имя'
                                        : 'Full name',
                            isLight: isLight,
                          ),
                          _CheckoutTextField(
                            controller: _nameController,
                            hintText: localeCode == 'ar'
                                ? 'أحمد محمد'
                                : localeCode == 'de'
                                    ? 'Ahmed Mohamed'
                                    : localeCode == 'ru'
                                        ? 'Ахмед Мохамед'
                                        : 'Ahmed Mohamed',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return localeCode == 'ar'
                                    ? 'من فضلك اكتب الاسم.'
                                    : localeCode == 'de'
                                        ? 'Bitte gib deinen Namen ein.'
                                        : localeCode == 'ru'
                                            ? 'Пожалуйста, введите имя.'
                                            : 'Please enter your name.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(
                            label: localeCode == 'ar'
                                ? 'رقم الهاتف'
                                : localeCode == 'de'
                                    ? 'Telefonnummer'
                                    : localeCode == 'ru'
                                        ? 'Номер телефона'
                                        : 'Phone number',
                            isLight: isLight,
                          ),
                          _CheckoutTextField(
                            controller: _phoneController,
                            hintText: localeCode == 'ar'
                                ? '01xxxxxxxxx'
                                : localeCode == 'de'
                                    ? '01xxxxxxxxx'
                                    : localeCode == 'ru'
                                        ? '01xxxxxxxxx'
                                        : '01xxxxxxxxx',
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().length < 10) {
                                return localeCode == 'ar'
                                    ? 'رقم الهاتف مطلوب ويجب أن يكون صالحًا.'
                                    : localeCode == 'de'
                                        ? 'Telefonnummer ist erforderlich und muss gültig sein.'
                                        : localeCode == 'ru'
                                            ? 'Номер телефона обязателен и должен быть корректным.'
                                            : 'Phone number is required and must be valid.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(
                            label: localeCode == 'ar'
                                ? 'المحافظة'
                                : localeCode == 'de'
                                    ? 'Gouvernement'
                                    : localeCode == 'ru'
                                        ? 'Губернаторство'
                                        : 'Governorate',
                            isLight: isLight,
                          ),
                          _CheckoutTextField(
                            controller: _governorateController,
                            hintText: localeCode == 'ar'
                                ? 'البحر الأحمر'
                                : localeCode == 'de'
                                    ? 'Rotes Meer'
                                    : localeCode == 'ru'
                                        ? 'Красное море'
                                        : 'Red Sea',
                            validator: (value) {
                              if (!_isDelivery) return null;
                              if (value == null || value.trim().isEmpty) {
                                return localeCode == 'ar'
                                    ? 'المحافظة مطلوبة للتوصيل.'
                                    : localeCode == 'de'
                                        ? 'Das Gouvernement ist für die Lieferung erforderlich.'
                                        : localeCode == 'ru'
                                            ? 'Для доставки требуется губернаторство.'
                                            : 'Governorate is required for delivery.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(
                                      label: localeCode == 'ar'
                                          ? 'المدينة'
                                          : localeCode == 'de'
                                              ? 'Stadt'
                                              : localeCode == 'ru'
                                                  ? 'Город'
                                                  : 'City',
                                      isLight: isLight,
                                    ),
                                    _CheckoutTextField(
                                      controller: _cityController,
                                      hintText: localeCode == 'ar'
                                          ? 'الغردقة'
                                          : localeCode == 'de'
                                              ? 'Hurghada'
                                              : localeCode == 'ru'
                                                  ? 'Хургада'
                                                  : 'Hurghada',
                                      validator: (value) {
                                        if (!_isDelivery) return null;
                                        if (value == null || value.trim().isEmpty) {
                                          return localeCode == 'ar'
                                              ? 'المدينة مطلوبة للتوصيل.'
                                              : localeCode == 'de'
                                                  ? 'Die Stadt ist für die Lieferung erforderlich.'
                                                  : localeCode == 'ru'
                                                      ? 'Город обязателен для доставки.'
                                                      : 'City is required for delivery.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(
                                      label: localeCode == 'ar'
                                          ? 'المنطقة'
                                          : localeCode == 'de'
                                              ? 'Gebiet'
                                              : localeCode == 'ru'
                                                  ? 'Район'
                                                  : 'Area',
                                      isLight: isLight,
                                    ),
                                    _CheckoutTextField(
                                      controller: _areaController,
                                      hintText: localeCode == 'ar'
                                          ? 'العربية / الكوثر'
                                          : localeCode == 'de'
                                              ? 'Arabia / El Kawther'
                                              : localeCode == 'ru'
                                                  ? 'Арабия / Эль-Каусер'
                                                  : 'Arabia / El Kawther',
                                      validator: (value) {
                                        if (!_isDelivery) return null;
                                        if (value == null || value.trim().isEmpty) {
                                          return localeCode == 'ar'
                                              ? 'المنطقة مطلوبة للتوصيل.'
                                              : localeCode == 'de'
                                                  ? 'Das Gebiet ist für die Lieferung erforderlich.'
                                                  : localeCode == 'ru'
                                                      ? 'Район обязателен для доставки.'
                                                      : 'Area is required for delivery.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(
                            label: localeCode == 'ar'
                                ? 'تفاصيل العنوان'
                                : localeCode == 'de'
                                    ? 'Adressdetails'
                                    : localeCode == 'ru'
                                        ? 'Подробный адрес'
                                        : 'Detailed address',
                            isLight: isLight,
                          ),
                          _CheckoutTextField(
                            controller: _addressController,
                            hintText: localeCode == 'ar'
                                ? 'الشارع، العمارة، الدور، الشقة'
                                : localeCode == 'de'
                                    ? 'Straße, Gebäude, Etage, Wohnung'
                                    : localeCode == 'ru'
                                        ? 'Улица, дом, этаж, квартира'
                                        : 'Street, building, floor, apartment',
                            validator: (value) {
                              if (!_isDelivery) return null;
                              if (value == null || value.trim().isEmpty) {
                                return localeCode == 'ar'
                                    ? 'تفاصيل العنوان مطلوبة للتوصيل.'
                                    : localeCode == 'de'
                                        ? 'Adressdetails sind für die Lieferung erforderlich.'
                                        : localeCode == 'ru'
                                            ? 'Для доставки нужен подробный адрес.'
                                            : 'Detailed address is required for delivery.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(
                            label: localeCode == 'ar'
                                ? 'علامة مميزة'
                                : localeCode == 'de'
                                    ? 'Orientierungspunkt'
                                    : localeCode == 'ru'
                                        ? 'Ориентир'
                                        : 'Landmark',
                            isLight: isLight,
                          ),
                          _CheckoutTextField(
                            controller: _landmarkController,
                            hintText: localeCode == 'ar'
                                ? 'بجوار ...'
                                : localeCode == 'de'
                                    ? 'In der Nähe von ...'
                                    : localeCode == 'ru'
                                        ? 'Рядом с ...'
                                        : 'Near ...',
                          ),
                          const SizedBox(height: 12),
                          _FieldLabel(
                            label: localeCode == 'ar'
                                ? 'ملاحظات العميل'
                                : localeCode == 'de'
                                    ? 'Kundennotizen'
                                    : localeCode == 'ru'
                                        ? 'Примечания клиента'
                                        : 'Customer notes',
                            isLight: isLight,
                          ),
                          _CheckoutTextField(
                            controller: _notesController,
                            hintText: localeCode == 'ar'
                                ? 'اختياري'
                                : localeCode == 'de'
                                    ? 'Optionale Notizen'
                                    : localeCode == 'ru'
                                        ? 'Необязательные заметки'
                                        : 'Optional notes',
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
                            localeCode == 'ar'
                                ? 'طريقة الدفع'
                                : localeCode == 'de'
                                    ? 'Zahlungsmethode'
                                    : localeCode == 'ru'
                                        ? 'Способ оплаты'
                                        : 'Payment method',
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: CavoColors.gold.withValues(alpha: 0.11),
                              border: Border.all(
                                color: CavoColors.gold.withValues(alpha: 0.30),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: CavoColors.gold,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'InstaPay',
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  localeCode == 'ar'
                                      ? 'نشط'
                                      : localeCode == 'de'
                                          ? 'Aktiv'
                                          : localeCode == 'ru'
                                              ? 'Активно'
                                              : 'Active',
                                  style: TextStyle(
                                    color: secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            localeCode == 'ar'
                                ? 'يتم تأكيد الطلب مباشرة، ثم تراجع الإدارة الدفع يدويًا.'
                                : localeCode == 'de'
                                    ? 'Die Bestellung wird sofort erstellt, danach prüft das Admin-Team die Zahlung manuell.'
                                    : localeCode == 'ru'
                                        ? 'Заказ создается сразу, после чего администрация проверяет оплату вручную.'
                                        : 'Order is created instantly, then payment is reviewed manually by admin.',
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
                            localeCode == 'ar'
                                ? 'ملخص الطلب'
                                : localeCode == 'de'
                                    ? 'Bestellübersicht'
                                    : localeCode == 'ru'
                                        ? 'Сводка заказа'
                                        : 'Order summary',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.product.title} • x${item.quantity}${item.size == null ? '' : ' • ${item.size}'}',
                                      style: TextStyle(
                                        color: primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
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
                          _SummaryRow(
                            label: context.l10n.subtotal,
                            value: '${CartController.instance.subtotal} EGP',
                            isLight: isLight,
                          ),
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: _deliveryFeeLabel(localeCode),
                            value:
                                '${_isDelivery ? CartController.instance.delivery : 0} EGP',
                            isLight: isLight,
                          ),
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: context.l10n.total,
                            value:
                                '${CartController.instance.subtotal + (_isDelivery ? CartController.instance.delivery : 0)} EGP',
                            isLight: isLight,
                            highlight: true,
                          ),
                          const SizedBox(height: 14),
                          _SummaryRow(
                            label: localeCode == 'ar'
                                ? 'طريقة الدفع'
                                : localeCode == 'de'
                                    ? 'Zahlungsmethode'
                                    : localeCode == 'ru'
                                        ? 'Способ оплаты'
                                        : 'Payment method',
                            value: 'InstaPay',
                            isLight: isLight,
                          ),
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: localeCode == 'ar'
                                ? 'طريقة الاستلام'
                                : localeCode == 'de'
                                    ? 'Erfüllungsart'
                                    : localeCode == 'ru'
                                        ? 'Способ получения'
                                        : 'Fulfillment type',
                            value: _fulfillmentLabel(localeCode),
                            isLight: isLight,
                          ),
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
                            child: Text(
                              _submitting
                                  ? context.l10n.loading
                                  : (localeCode == 'ar'
                                      ? 'تأكيد الطلب'
                                      : localeCode == 'de'
                                          ? 'Bestellung aufgeben'
                                          : localeCode == 'ru'
                                              ? 'Оформить заказ'
                                              : 'Place order'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localeCode == 'ar'
                              ? 'لا حاجة إلى لقطة شاشة للدفع. يتم إنشاء الطلب مباشرة بعد التأكيد.'
                              : localeCode == 'de'
                                  ? 'Kein Zahlungsscreenshot erforderlich. Die Bestellung wird direkt nach der Bestätigung erstellt.'
                                  : localeCode == 'ru'
                                      ? 'Скриншот оплаты не требуется. Заказ создается сразу после подтверждения.'
                                      : 'No payment screenshot required. The order is created right after confirmation.',
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

class _FulfillmentChoice extends StatelessWidget {
  const _FulfillmentChoice({
    required this.isLight,
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool isLight;
  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? CavoColors.gold.withValues(alpha: 0.34) : CavoColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? CavoColors.gold.withValues(alpha: 0.15)
              : (isLight ? Colors.white : CavoColors.surfaceSoft),
          border: Border.all(
            color: isLight && !selected ? CavoColors.lightBorder : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? CavoColors.gold
                  : (isLight
                      ? CavoColors.lightTextSecondary
                      : CavoColors.textSecondary),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutTextField extends StatelessWidget {
  const _CheckoutTextField({
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

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
  const _FieldLabel({required this.label, required this.isLight});

  final String label;
  final bool isLight;

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
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isLight,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool isLight;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color = highlight
        ? CavoColors.gold
        : (isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary);
    final valueColor = highlight
        ? CavoColors.gold
        : (isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: valueColor,
              fontSize: highlight ? 17 : 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
