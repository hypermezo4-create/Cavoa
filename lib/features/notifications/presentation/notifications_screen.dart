import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/order.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../notifications/data/notification_center_controller.dart';
import '../../notifications/data/notification_types.dart';
import '../../orders/data/order_controller.dart';
import '../../orders/presentation/delivery_tracking_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _title(String code) {
    switch (code) {
      case 'ar':
        return 'الإشعارات';
      case 'de':
        return 'Benachrichtigungen';
      case 'ru':
        return 'Уведомления';
      default:
        return 'Notifications';
    }
  }

  String _subtitle(String code) {
    switch (code) {
      case 'ar':
        return 'كل تحديثات الطلبات تظهر هنا أولًا بأول.';
      case 'de':
        return 'Alle Bestellupdates erscheinen hier in Echtzeit.';
      case 'ru':
        return 'Все обновления заказов появляются здесь.';
      default:
        return 'Every order update appears here in real time.';
    }
  }

  String _emptyTitle(String code) {
    switch (code) {
      case 'ar':
        return 'لا توجد إشعارات حتى الآن';
      case 'de':
        return 'Noch keine Benachrichtigungen';
      case 'ru':
        return 'Пока нет уведомлений';
      default:
        return 'No notifications yet';
    }
  }

  String _emptyBody(String code) {
    switch (code) {
      case 'ar':
        return 'بمجرد إنشاء طلب أو تغيير حالته، ستجده هنا.';
      case 'de':
        return 'Sobald eine Bestellung erstellt oder aktualisiert wird, erscheint sie hier.';
      case 'ru':
        return 'Как только заказ будет создан или обновлён, он появится здесь.';
      default:
        return 'As soon as an order is created or updated, it will appear here.';
    }
  }

  String _markAll(String code) {
    switch (code) {
      case 'ar':
        return 'تحديد الكل كمقروء';
      case 'de':
        return 'Alle als gelesen markieren';
      case 'ru':
        return 'Отметить все как прочитанные';
      default:
        return 'Mark all as read';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ValueListenableBuilder<List<CavoNotificationItem>>(
            valueListenable: NotificationCenterController.instance,
            builder: (context, notifications, _) {
              return ListView(
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
                              _title(localeCode),
                              style: TextStyle(
                                color: primary,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _subtitle(localeCode),
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
                  if (notifications.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: NotificationCenterController.instance.markAllRead,
                        icon: const Icon(Icons.done_all_rounded, color: CavoColors.gold),
                        label: Text(
                          _markAll(localeCode),
                          style: const TextStyle(color: CavoColors.gold, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  if (notifications.isEmpty)
                    CavoGlassCard(
                      isLight: isLight,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Column(
                        children: [
                          const Icon(Icons.notifications_none_rounded, size: 42, color: CavoColors.gold),
                          const SizedBox(height: 12),
                          Text(
                            _emptyTitle(localeCode),
                            style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _emptyBody(localeCode),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: secondary, fontSize: 13, fontWeight: FontWeight.w600, height: 1.5),
                          ),
                        ],
                      ),
                    )
                  else
                    ...notifications.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _NotificationCard(item: item, isLight: isLight),
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

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.isLight});

  final CavoNotificationItem item;
  final bool isLight;

  String _title(BuildContext context, CavoOrder? order) {
    final code = Localizations.localeOf(context).languageCode;
    if (item.type == CavoNotificationType.ratingReminder) {
      switch (code) {
        case 'ar':
          return 'قيّم طلبك';
        case 'de':
          return 'Bestellung bewerten';
        case 'ru':
          return 'Оцените заказ';
        default:
          return 'Rate your order';
      }
    }
    if (item.type == CavoNotificationType.orderCreated) {
      switch (code) {
        case 'ar':
          return 'تم إنشاء الطلب';
        case 'de':
          return 'Bestellung erstellt';
        case 'ru':
          return 'Заказ создан';
        default:
          return 'Order created';
      }
    }
    switch (item.type) {
      case CavoNotificationType.orderApproved:
      case CavoNotificationType.orderRejected:
      case CavoNotificationType.orderProcessing:
      case CavoNotificationType.orderShipped:
      case CavoNotificationType.orderDelivered:
      case CavoNotificationType.orderCancelled:
        final status = order?.status;
        if (status == null) return item.title;
        switch (code) {
          case 'ar':
            return 'حالة الطلب: ${status.labelForLocale(code)}';
          case 'de':
            return 'Bestellstatus: ${status.labelForLocale(code)}';
          case 'ru':
            return 'Статус заказа: ${status.labelForLocale(code)}';
          default:
            return 'Order status: ${status.labelForLocale(code)}';
        }
      case CavoNotificationType.paymentConfirmed:
      case CavoNotificationType.paymentFailed:
      case CavoNotificationType.adminUpdate:
        return item.title;
      case CavoNotificationType.orderCreated:
      case CavoNotificationType.ratingReminder:
        return item.title;
    }
  }

  String _body(BuildContext context, CavoOrder? order) {
    final code = Localizations.localeOf(context).languageCode;
    if (order == null) return item.body;
    if (item.type == CavoNotificationType.ratingReminder) {
      switch (code) {
        case 'ar':
          return 'تم تسليم الطلب ${order.id}. اضغط لفتح التتبع وإضافة تقييمك.';
        case 'de':
          return 'Die Bestellung ${order.id} wurde zugestellt. Tippe hier, um eine Bewertung zu hinterlassen.';
        case 'ru':
          return 'Заказ ${order.id} доставлен. Нажмите, чтобы открыть отслеживание и оставить оценку.';
        default:
          return 'Order ${order.id} was delivered. Tap to open tracking and leave your rating.';
      }
    }
    if (item.type == CavoNotificationType.orderCreated) {
      switch (code) {
        case 'ar':
          return 'إجمالي طلبك ${order.total} EGP وهو الآن بانتظار المراجعة.';
        case 'de':
          return 'Dein Bestellwert beträgt ${order.total} EGP und wartet jetzt auf Prüfung.';
        case 'ru':
          return 'Сумма заказа ${order.total} EGP, сейчас он ожидает проверки.';
        default:
          return 'Your order total is ${order.total} EGP and it is now waiting for review.';
      }
    }
    switch (item.type) {
      case CavoNotificationType.orderApproved:
      case CavoNotificationType.orderRejected:
      case CavoNotificationType.orderProcessing:
      case CavoNotificationType.orderShipped:
      case CavoNotificationType.orderDelivered:
      case CavoNotificationType.orderCancelled:
        switch (order.status) {
          case OrderStatus.approved:
            return code == 'ar' ? 'تمت الموافقة على طلبك ${order.id}.' : code == 'de' ? 'Deine Bestellung ${order.id} wurde bestätigt.' : code == 'ru' ? 'Ваш заказ ${order.id} подтвержден.' : 'Your order ${order.id} was approved.';
          case OrderStatus.rejected:
            return code == 'ar' ? 'تم رفض طلبك ${order.id}. يمكنك التواصل مع الدعم.' : code == 'de' ? 'Deine Bestellung ${order.id} wurde abgelehnt.' : code == 'ru' ? 'Ваш заказ ${order.id} был отклонен.' : 'Your order ${order.id} was rejected.';
          case OrderStatus.processing:
            return code == 'ar' ? 'طلبك ${order.id} قيد التجهيز الآن.' : code == 'de' ? 'Deine Bestellung ${order.id} wird gerade vorbereitet.' : code == 'ru' ? 'Ваш заказ ${order.id} сейчас готовится.' : 'Your order ${order.id} is now being prepared.';
          case OrderStatus.shipped:
            return code == 'ar' ? 'طلبك ${order.id} في الطريق إلى ${order.city}, ${order.area}.' : code == 'de' ? 'Deine Bestellung ${order.id} ist auf dem Weg nach ${order.city}, ${order.area}.' : code == 'ru' ? 'Ваш заказ ${order.id} направляется в ${order.city}, ${order.area}.' : 'Your order ${order.id} is on the way to ${order.city}, ${order.area}.';
          case OrderStatus.delivered:
            return code == 'ar' ? 'تم تسليم طلبك ${order.id}. نتمنى لك تجربة رائعة.' : code == 'de' ? 'Deine Bestellung ${order.id} wurde zugestellt.' : code == 'ru' ? 'Ваш заказ ${order.id} доставлен.' : 'Your order ${order.id} has been delivered.';
          case OrderStatus.cancelled:
            return code == 'ar' ? 'تم إلغاء طلبك ${order.id}.' : code == 'de' ? 'Deine Bestellung ${order.id} wurde storniert.' : code == 'ru' ? 'Ваш заказ ${order.id} был отменён.' : 'Your order ${order.id} was cancelled.';
          case OrderStatus.pending:
            return code == 'ar' ? 'طلبك ${order.id} ما زال قيد المراجعة.' : code == 'de' ? 'Deine Bestellung ${order.id} wird noch geprüft.' : code == 'ru' ? 'Ваш заказ ${order.id} всё ещё на проверке.' : 'Your order ${order.id} is still under review.';
        }
      case CavoNotificationType.paymentConfirmed:
      case CavoNotificationType.paymentFailed:
      case CavoNotificationType.adminUpdate:
        return item.body;
      case CavoNotificationType.orderCreated:
      case CavoNotificationType.ratingReminder:
        return item.body;
    }
  }

  IconData _iconForType() {
    switch (item.type) {
      case CavoNotificationType.ratingReminder:
        return Icons.star_rounded;
      case CavoNotificationType.orderApproved:
      case CavoNotificationType.orderRejected:
      case CavoNotificationType.orderProcessing:
      case CavoNotificationType.orderShipped:
      case CavoNotificationType.orderDelivered:
      case CavoNotificationType.orderCancelled:
        return Icons.local_shipping_rounded;
      case CavoNotificationType.paymentConfirmed:
      case CavoNotificationType.paymentFailed:
        return Icons.credit_card_rounded;
      case CavoNotificationType.adminUpdate:
        return Icons.campaign_rounded;
      case CavoNotificationType.orderCreated:
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final order = OrderController.instance.findById(item.orderId);
    return InkWell(
      onTap: () async {
        await NotificationCenterController.instance.markRead(item.id);
        final order = OrderController.instance.findById(item.orderId);
        if (!context.mounted || order == null) return;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DeliveryTrackingScreen(order: order)),
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: CavoGlassCard(
        isLight: isLight,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        color: item.isRead
            ? null
            : (isLight ? const Color(0xFFFFFBF2) : const Color(0xFF17130C).withValues(alpha: 0.98)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CavoColors.gold.withValues(alpha: 0.14),
              ),
              child: Icon(_iconForType(), color: CavoColors.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _title(context, order),
                          style: TextStyle(color: primary, fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(color: CavoColors.gold, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _body(context, order),
                    style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w600, height: 1.45),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${item.createdAt.day.toString().padLeft(2, '0')}/${item.createdAt.month.toString().padLeft(2, '0')}/${item.createdAt.year} • ${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: secondary.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
