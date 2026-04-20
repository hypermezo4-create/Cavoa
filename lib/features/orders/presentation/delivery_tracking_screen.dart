import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../data/order_controller.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({
    super.key,
    required this.order,
  });

  final CavoOrder order;

  String _tr(
    String localeCode, {
    required String en,
    required String ar,
    required String de,
    required String ru,
  }) {
    switch (localeCode) {
      case 'ar':
        return ar;
      case 'de':
        return de;
      case 'ru':
        return ru;
      default:
        return en;
    }
  }

  List<_TrackingStep> _buildSteps(String localeCode) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.approved,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentIndex = statuses.indexOf(order.status);
    final safeIndex = currentIndex < 0 ? 0 : currentIndex;

    return [
      _TrackingStep(
        status: OrderStatus.pending,
        title: _tr(localeCode, en: 'Order placed', ar: 'تم إنشاء الطلب', de: 'Bestellung erstellt', ru: 'Заказ создан'),
        subtitle: _tr(
          localeCode,
          en: 'Your order has been received and is waiting for review.',
          ar: 'تم استلام طلبك وهو الآن بانتظار المراجعة.',
          de: 'Deine Bestellung wurde empfangen und wartet auf Prüfung.',
          ru: 'Ваш заказ получен и ожидает проверки.',
        ),
        state: safeIndex >= 0 ? _StepState.done : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.approved,
        title: _tr(localeCode, en: 'Approved', ar: 'تمت الموافقة', de: 'Bestätigt', ru: 'Подтверждено'),
        subtitle: _tr(
          localeCode,
          en: 'The order was approved from the admin side.',
          ar: 'تمت الموافقة على الطلب من جانب الإدارة.',
          de: 'Die Bestellung wurde von der Verwaltung bestätigt.',
          ru: 'Заказ был подтверждён со стороны администратора.',
        ),
        state: safeIndex > 1
            ? _StepState.done
            : safeIndex == 1
                ? _StepState.current
                : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.processing,
        title: _tr(localeCode, en: 'Preparing your order', ar: 'جارٍ تجهيز طلبك', de: 'Deine Bestellung wird vorbereitet', ru: 'Ваш заказ готовится'),
        subtitle: _tr(
          localeCode,
          en: 'Your pair is being checked and packed carefully.',
          ar: 'يتم فحص طلبك وتغليفه بعناية.',
          de: 'Dein Paar wird sorgfältig geprüft und verpackt.',
          ru: 'Вашу пару проверяют и аккуратно упаковывают.',
        ),
        state: safeIndex > 2
            ? _StepState.done
            : safeIndex == 2
                ? _StepState.current
                : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.shipped,
        title: _tr(localeCode, en: 'On the way', ar: 'في الطريق', de: 'Unterwegs', ru: 'В пути'),
        subtitle: _tr(
          localeCode,
          en: 'Your order has left and is moving to the delivery stage.',
          ar: 'خرج طلبك وأصبح الآن في مرحلة التوصيل.',
          de: 'Deine Bestellung hat das Lager verlassen und befindet sich in der Lieferung.',
          ru: 'Ваш заказ отправлен и находится на этапе доставки.',
        ),
        state: safeIndex > 3
            ? _StepState.done
            : safeIndex == 3
                ? _StepState.current
                : _StepState.todo,
      ),
      _TrackingStep(
        status: OrderStatus.delivered,
        title: _tr(localeCode, en: 'Delivered', ar: 'تم التسليم', de: 'Zugestellt', ru: 'Доставлен'),
        subtitle: _tr(
          localeCode,
          en: 'Your order arrived successfully. Enjoy your pair.',
          ar: 'وصل طلبك بنجاح. نتمنى لك تجربة رائعة.',
          de: 'Deine Bestellung wurde erfolgreich zugestellt. Viel Freude mit deinem Paar.',
          ru: 'Ваш заказ успешно доставлен. Приятного пользования.',
        ),
        state: safeIndex >= 4 ? _StepState.done : _StepState.todo,
      ),
    ];
  }

  Color _statusTint(OrderStatus status) {
    switch (status) {
      case OrderStatus.rejected:
        return const Color(0xFFDA5A5A);
      case OrderStatus.cancelled:
        return const Color(0xFFC8893A);
      case OrderStatus.delivered:
        return const Color(0xFF2DBA71);
      default:
        return CavoColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final localeCode = Localizations.localeOf(context).languageCode;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final accent = _statusTint(order.status);
    final steps = _buildSteps(localeCode);

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localeCode == 'ar' ? 'مراجعة الشحنة' : localeCode == 'de' ? 'Bestellstatus' : localeCode == 'ru' ? 'Статус доставки' : 'Shipment Review',
                          style: TextStyle(
                            color: primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localeCode == 'ar' ? 'تابع كل خطوة من طلب CAVO الخاص بك.' : localeCode == 'de' ? 'Verfolge jeden Schritt deiner CAVO-Bestellung.' : localeCode == 'ru' ? 'Следите за каждым этапом заказа CAVO.' : 'Track every step of your CAVO order.',
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
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MetaBlock(
                            label: localeCode == 'ar' ? 'رقم الطلب' : localeCode == 'de' ? 'Bestellnummer' : localeCode == 'ru' ? 'Номер заказа' : 'Order ID',
                            value: order.id,
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: accent.withValues(alpha: 0.16),
                            border: Border.all(color: accent.withValues(alpha: 0.20)),
                          ),
                          child: Text(
                            order.status.labelForLocale(localeCode),
                            style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _MetaBlock(
                            label: localeCode == 'ar' ? 'من' : localeCode == 'de' ? 'Von' : localeCode == 'ru' ? 'Откуда' : 'From',
                            value: _tr(localeCode, en: 'CAVO, Hurghada', ar: 'CAVO، الغردقة', de: 'CAVO, Hurghada', ru: 'CAVO, Хургада'),
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetaBlock(
                            label: localeCode == 'ar' ? 'إلى' : localeCode == 'de' ? 'Nach' : localeCode == 'ru' ? 'Куда' : 'To',
                            value: '${order.city}, ${order.area}',
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: isLight ? const Color(0xFFF7F4ED) : const Color(0xFF111318),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.status == OrderStatus.delivered ? (localeCode == 'ar' ? 'استمتع بطلبك' : localeCode == 'de' ? 'Viel Freude mit deiner Bestellung' : localeCode == 'ru' ? 'Наслаждайтесь заказом' : 'Enjoy your order') : (localeCode == 'ar' ? 'طلبك يتحرك الآن' : localeCode == 'de' ? 'Deine Bestellung bewegt sich jetzt' : localeCode == 'ru' ? 'Ваш заказ в пути' : 'Your order is moving'),
                                  style: TextStyle(
                                    color: primary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.7,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  order.status == OrderStatus.rejected
                                      ? localeCode == 'ar' ? 'تم رفض الطلب من جانب الإدارة. تواصل مع الدعم إذا احتجت.' : localeCode == 'de' ? 'Die Bestellung wurde von der Verwaltung abgelehnt. Bitte kontaktiere bei Bedarf den Support.' : localeCode == 'ru' ? 'Заказ был отклонен со стороны администратора. При необходимости свяжитесь с поддержкой.' : 'The order was rejected from the admin side. Please contact support if needed.'
                                      : localeCode == 'ar' ? 'نقوم بتحديث كل حالة باستمرار حتى تعرف المرحلة الدقيقة دائمًا.' : localeCode == 'de' ? 'Jeder Status wird laufend aktualisiert, damit du immer den genauen Schritt kennst.' : localeCode == 'ru' ? 'Каждый статус регулярно обновляется, чтобы вы всегда знали точный этап.' : 'We keep every status updated so you always know the exact step.',
                                  style: TextStyle(
                                    color: secondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  accent.withValues(alpha: 0.95),
                                  accent.withValues(alpha: 0.55),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.18),
                                  blurRadius: 22,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              order.status == OrderStatus.delivered
                                  ? Icons.check_rounded
                                  : order.status == OrderStatus.shipped
                                      ? Icons.local_shipping_rounded
                                      : Icons.inventory_2_outlined,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ],
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
                      localeCode == 'ar' ? 'الخط الزمني' : localeCode == 'de' ? 'Zeitachse' : localeCode == 'ru' ? 'Хронология' : 'Timeline',
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(steps.length, (index) {
                      final step = steps[index];
                      final showLine = index != steps.length - 1;
                      return _TimelineTile(
                        step: step,
                        showLine: showLine,
                        primary: primary,
                        secondary: secondary,
                      );
                    }),
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
                      localeCode == 'ar' ? 'تفاصيل التوصيل' : localeCode == 'de' ? 'Lieferdetails' : localeCode == 'ru' ? 'Детали доставки' : 'Delivery details',
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailRow(localeCode == 'ar' ? 'العميل' : localeCode == 'de' ? 'Kunde' : localeCode == 'ru' ? 'Клиент' : 'Customer', order.customerName, primary, secondary),
                    _detailRow(localeCode == 'ar' ? 'الهاتف' : localeCode == 'de' ? 'Telefon' : localeCode == 'ru' ? 'Телефон' : 'Phone', order.phoneNumber, primary, secondary),
                    _detailRow(
                      localeCode == 'ar' ? 'العنوان' : localeCode == 'de' ? 'Adresse' : localeCode == 'ru' ? 'Адрес' : 'Address',
                      '${order.city}, ${order.area}\n${order.addressLine}',
                      primary,
                      secondary,
                    ),
                    _detailRow(localeCode == 'ar' ? 'الدفع' : localeCode == 'de' ? 'Zahlung' : localeCode == 'ru' ? 'Оплата' : 'Payment', order.paymentMethod.labelForLocale(localeCode), primary, secondary),
                    _detailRow(localeCode == 'ar' ? 'الإجمالي' : localeCode == 'de' ? 'Gesamt' : localeCode == 'ru' ? 'Итого' : 'Total', '${order.total} EGP', primary, secondary),
                  ],
                ),
              ),
              if (order.status == OrderStatus.delivered) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await showCavoRatingSheet(context, order: order);
                    },
                    child: Text(order.isRated ? (localeCode == 'ar' ? 'تعديل التقييم' : localeCode == 'de' ? 'Bewertung bearbeiten' : localeCode == 'ru' ? 'Изменить оценку' : 'Update rating') : (localeCode == 'ar' ? 'قيّم التوصيل' : localeCode == 'de' ? 'Lieferung bewerten' : localeCode == 'ru' ? 'Оценить доставку' : 'Rate your delivery')),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, Color primary, Color secondary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: TextStyle(
                color: secondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showCavoRatingSheet(
  BuildContext context, {
  required CavoOrder order,
}) async {
  final isLight = Theme.of(context).brightness == Brightness.light;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _OrderRatingSheet(order: order, isLight: isLight),
  );
}

class _OrderRatingSheet extends StatefulWidget {
  const _OrderRatingSheet({
    required this.order,
    required this.isLight,
  });

  final CavoOrder order;
  final bool isLight;

  @override
  State<_OrderRatingSheet> createState() => _OrderRatingSheetState();
}

class _OrderRatingSheetState extends State<_OrderRatingSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  int _rating = 5;
  bool _saving = false;
  final Set<String> _tags = {'on_time'};

  static const _choices = [
    'on_time',
    'friendly',
    'careful',
    'communicative',
    'above_beyond',
  ];

  String get _localeCode => Localizations.localeOf(context).languageCode;

  String _tr({
    required String en,
    required String ar,
    required String de,
    required String ru,
  }) {
    switch (_localeCode) {
      case 'ar':
        return ar;
      case 'de':
        return de;
      case 'ru':
        return ru;
      default:
        return en;
    }
  }

  String _choiceLabel(String key) {
    switch (key) {
      case 'on_time':
        return _tr(en: 'On time', ar: 'في الموعد', de: 'Pünktlich', ru: 'Вовремя');
      case 'friendly':
        return _tr(en: 'Friendly', ar: 'تعامل راقٍ', de: 'Freundlich', ru: 'Дружелюбно');
      case 'careful':
        return _tr(en: 'Careful', ar: 'تغليف بعناية', de: 'Sorgfältig', ru: 'Аккуратно');
      case 'communicative':
        return _tr(en: 'Communicative', ar: 'تواصل ممتاز', de: 'Gute Kommunikation', ru: 'Хорошая связь');
      case 'above_beyond':
        return _tr(en: 'Above & beyond', ar: 'تجربة استثنائية', de: 'Über den Erwartungen', ru: 'Выше ожиданий');
      default:
        return key;
    }
  }

  @override
  void initState() {
    super.initState();
    _rating = widget.order.rating ?? 5;
    for (final tag in widget.order.ratingTags) {
      switch (tag) {
        case 'On time':
        case 'on_time':
          _tags.add('on_time');
          break;
        case 'Friendly':
        case 'friendly':
          _tags.add('friendly');
          break;
        case 'Careful':
        case 'careful':
          _tags.add('careful');
          break;
        case 'Communicative':
        case 'communicative':
          _tags.add('communicative');
          break;
        case 'Above & beyond':
        case 'above_beyond':
          _tags.add('above_beyond');
          break;
      }
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = widget.isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    return Padding(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 14,
      ),
      child: ScaleTransition(
        scale: _scale,
        child: CavoGlassCard(
          isLight: widget.isLight,
          borderRadius: const BorderRadius.all(Radius.circular(34)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 6,
                decoration: BoxDecoration(
                  color: (widget.isLight ? Colors.black : Colors.white).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              CircleAvatar(
                radius: 28,
                backgroundColor: CavoColors.gold.withValues(alpha: 0.14),
                child: const Text('👟', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 12),
              Text(
                _tr(
                  en: 'How was your delivery?',
                  ar: 'كيف كانت تجربة التوصيل؟',
                  de: 'Wie war deine Lieferung?',
                  ru: 'Как прошла доставка?',
                ),
                style: TextStyle(
                  color: primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _tr(
                  en: 'Rate the CAVO experience for order ${widget.order.id}.',
                  ar: 'قيّم تجربة CAVO للطلب ${widget.order.id}.',
                  de: 'Bewerte dein CAVO-Erlebnis für Bestellung ${widget.order.id}.',
                  ru: 'Оцените опыт CAVO по заказу ${widget.order.id}.',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final active = _rating >= index + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                      active ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: active ? CavoColors.gold : secondary,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _choices.map((choice) {
                  final selected = _tags.contains(choice);
                  return ChoiceChip(
                    label: Text(_choiceLabel(choice)),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          _tags.remove(choice);
                        } else {
                          _tags.add(choice);
                        }
                      });
                    },
                    selectedColor: CavoColors.gold.withValues(alpha: 0.20),
                    backgroundColor: widget.isLight ? Colors.white : CavoColors.surfaceSoft,
                    labelStyle: TextStyle(
                      color: selected ? primary : secondary,
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide(
                      color: selected
                          ? CavoColors.gold.withValues(alpha: 0.24)
                          : (widget.isLight ? CavoColors.lightBorder : CavoColors.border),
                    ),
                  );
                }).toList(growable: false),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          setState(() => _saving = true);
                          try {
                            await OrderController.instance.submitRating(
                              orderId: widget.order.id,
                              rating: _rating,
                              tags: _tags.toList(growable: false),
                            );
                            if (!mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _tr(
                                    en: 'Thanks — your rating was saved.',
                                    ar: 'شكرًا لك — تم حفظ تقييمك.',
                                    de: 'Danke — deine Bewertung wurde gespeichert.',
                                    ru: 'Спасибо — ваша оценка сохранена.',
                                  ),
                                ),
                              ),
                            );
                          } finally {
                            if (mounted) setState(() => _saving = false);
                          }
                        },
                  child: Text(
                    _saving
                        ? _tr(
                            en: 'Saving...',
                            ar: 'جارٍ الحفظ...',
                            de: 'Wird gespeichert...',
                            ru: 'Сохранение...',
                          )
                        : _tr(
                            en: 'Submit rating',
                            ar: 'إرسال التقييم',
                            de: 'Bewertung senden',
                            ru: 'Отправить оценку',
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: _saving ? null : () => Navigator.of(context).pop(),
                child: Text(
                  _tr(
                    en: 'Maybe later',
                    ar: 'لاحقًا',
                    de: 'Vielleicht später',
                    ru: 'Позже',
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

class _MetaBlock extends StatelessWidget {
  const _MetaBlock({
    required this.label,
    required this.value,
    required this.primary,
    required this.secondary,
  });

  final String label;
  final String value;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: secondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: primary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

enum _StepState { done, current, todo }

class _TrackingStep {
  const _TrackingStep({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final OrderStatus status;
  final String title;
  final String subtitle;
  final _StepState state;
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.step,
    required this.showLine,
    required this.primary,
    required this.secondary,
  });

  final _TrackingStep step;
  final bool showLine;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final accent = step.state == _StepState.todo
        ? secondary.withValues(alpha: 0.26)
        : step.state == _StepState.current
            ? CavoColors.gold
            : const Color(0xFF2DBA71);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: step.state == _StepState.todo ? 0.10 : 0.18),
                  border: Border.all(color: accent.withValues(alpha: 0.32)),
                ),
                child: Icon(
                  step.state == _StepState.done
                      ? Icons.check_rounded
                      : step.state == _StepState.current
                          ? Icons.radio_button_checked_rounded
                          : Icons.circle_outlined,
                  size: 15,
                  color: accent,
                ),
              ),
              if (showLine)
                Container(
                  width: 2,
                  height: 34,
                  color: accent.withValues(alpha: 0.24),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.subtitle,
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
      ],
    );
  }
}
