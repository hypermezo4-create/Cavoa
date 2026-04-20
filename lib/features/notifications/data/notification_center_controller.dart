import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/order.dart';
import 'notification_types.dart';

class CavoNotificationItem {
  final String id;
  final String orderId;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final CavoNotificationType type;
  final NotificationChannel channel;

  const CavoNotificationItem({
    required this.id,
    required this.orderId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.channel = NotificationChannel.inApp,
  });

  CavoNotificationItem copyWith({bool? isRead}) {
    return CavoNotificationItem(
      id: id,
      orderId: orderId,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      type: type,
      channel: channel,
    );
  }
}

class NotificationCenterController extends ValueNotifier<List<CavoNotificationItem>> {
  NotificationCenterController._() : super(const <CavoNotificationItem>[]);

  static final NotificationCenterController instance = NotificationCenterController._();

  static const _readIdsKey = 'cavo_notification_read_ids';
  SharedPreferences? _prefs;
  final Set<String> _readIds = <String>{};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs?.getStringList(_readIdsKey) ?? const <String>[];
    _readIds
      ..clear()
      ..addAll(stored);
  }

  int get unreadCount => value.where((item) => !item.isRead).length;

  Future<void> markRead(String id) async {
    if (_readIds.add(id)) {
      await _prefs?.setStringList(_readIdsKey, _readIds.toList(growable: false));
    }
    value = value
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList(growable: false);
  }

  Future<void> markAllRead() async {
    _readIds
      ..clear()
      ..addAll(value.map((item) => item.id));
    await _prefs?.setStringList(_readIdsKey, _readIds.toList(growable: false));
    value = value.map((item) => item.copyWith(isRead: true)).toList(growable: false);
  }

  void syncFromOrders(List<CavoOrder> orders) {
    final byId = <String, CavoNotificationItem>{};

    for (final order in orders) {
      final stamp = order.updatedAt ?? order.createdAt;
      _addNotification(
        byId,
        CavoNotificationItem(
          id: '${order.id}:created',
          orderId: order.id,
          title: _titleForType(CavoNotificationType.orderCreated),
          body: _createdBody(order),
          createdAt: order.createdAt,
          isRead: _readIds.contains('${order.id}:created'),
          type: CavoNotificationType.orderCreated,
        ),
      );

      final customTypes = <CavoNotificationType>{};
      for (final custom in order.userNotifications) {
        final resolvedType = CavoNotificationTypeX.tryFromKey(custom.type) ?? CavoNotificationType.adminUpdate;
        customTypes.add(resolvedType);
        _addNotification(
          byId,
          CavoNotificationItem(
            id: custom.id,
            orderId: order.id,
            title: custom.title,
            body: custom.body,
            createdAt: custom.createdAt,
            isRead: _readIds.contains(custom.id),
            type: resolvedType,
          ),
        );
      }

      final statusType = _statusToNotificationType(order.status);
      if (statusType != null && !customTypes.contains(statusType)) {
        final statusId = '${order.id}:status:${order.status.key}';
        _addNotification(
          byId,
          CavoNotificationItem(
            id: statusId,
            orderId: order.id,
            title: _titleForType(statusType),
            body: _statusBody(order),
            createdAt: stamp,
            isRead: _readIds.contains(statusId),
            type: statusType,
          ),
        );
      }

      final paymentType = _paymentToNotificationType(order.paymentStatus);
      if (paymentType != null && !customTypes.contains(paymentType)) {
        final paymentId = '${order.id}:payment:${order.paymentStatus.key}';
        _addNotification(
          byId,
          CavoNotificationItem(
            id: paymentId,
            orderId: order.id,
            title: _titleForType(paymentType),
            body: _paymentBody(order),
            createdAt: stamp,
            isRead: _readIds.contains(paymentId),
            type: paymentType,
          ),
        );
      }

      if (order.status == OrderStatus.delivered && !order.isRated) {
        final rateId = '${order.id}:rate';
        _addNotification(
          byId,
          CavoNotificationItem(
            id: rateId,
            orderId: order.id,
            title: _titleForType(CavoNotificationType.ratingReminder),
            body: 'Your CAVO order ${order.id} was delivered. Tap to open tracking and leave your rating.',
            createdAt: stamp,
            isRead: _readIds.contains(rateId),
            type: CavoNotificationType.ratingReminder,
          ),
        );
      }
    }

    final notifications = byId.values.toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    value = notifications;
  }

  void _addNotification(Map<String, CavoNotificationItem> byId, CavoNotificationItem candidate) {
    final existing = byId[candidate.id];
    if (existing == null || candidate.createdAt.isAfter(existing.createdAt)) {
      byId[candidate.id] = candidate;
    }
  }

  CavoNotificationType? _statusToNotificationType(OrderStatus status) {
    switch (status) {
      case OrderStatus.approved:
        return CavoNotificationType.orderApproved;
      case OrderStatus.rejected:
        return CavoNotificationType.orderRejected;
      case OrderStatus.processing:
        return CavoNotificationType.orderProcessing;
      case OrderStatus.shipped:
        return CavoNotificationType.orderShipped;
      case OrderStatus.delivered:
        return CavoNotificationType.orderDelivered;
      case OrderStatus.cancelled:
        return CavoNotificationType.orderCancelled;
      case OrderStatus.pending:
        return null;
    }
  }

  CavoNotificationType? _paymentToNotificationType(OrderPaymentStatus status) {
    switch (status) {
      case OrderPaymentStatus.confirmed:
        return CavoNotificationType.paymentConfirmed;
      case OrderPaymentStatus.failed:
        return CavoNotificationType.paymentFailed;
      case OrderPaymentStatus.pending:
        return null;
    }
  }

  String _titleForType(CavoNotificationType type) {
    switch (type) {
      case CavoNotificationType.orderCreated:
        return 'Order created';
      case CavoNotificationType.orderApproved:
        return 'Order approved';
      case CavoNotificationType.orderRejected:
        return 'Order rejected';
      case CavoNotificationType.orderProcessing:
        return 'Order moved to processing';
      case CavoNotificationType.orderShipped:
        return 'Order shipped';
      case CavoNotificationType.orderDelivered:
        return 'Order delivered';
      case CavoNotificationType.orderCancelled:
        return 'Order cancelled';
      case CavoNotificationType.paymentConfirmed:
        return 'Payment confirmed';
      case CavoNotificationType.paymentFailed:
        return 'Payment failed';
      case CavoNotificationType.adminUpdate:
        return 'Order update';
      case CavoNotificationType.ratingReminder:
        return 'Rate your order';
    }
  }

  String _createdBody(CavoOrder order) =>
      'Your order total is ${order.total} EGP and it is now waiting for admin review.';

  String _statusBody(CavoOrder order) {
    switch (order.status) {
      case OrderStatus.approved:
        return 'Your order ${order.id} was approved and will move to preparation soon.';
      case OrderStatus.rejected:
        return 'Your order ${order.id} was rejected. Please contact support for help.';
      case OrderStatus.processing:
        return 'Your order ${order.id} is now being prepared by the CAVO team.';
      case OrderStatus.shipped:
        return 'Your order ${order.id} is on the way to ${order.city}, ${order.area}.';
      case OrderStatus.delivered:
        return 'Your order ${order.id} has arrived. Enjoy your pair.';
      case OrderStatus.cancelled:
        return 'Your order ${order.id} was cancelled.';
      case OrderStatus.pending:
        return 'Your order ${order.id} is still waiting for review.';
    }
  }

  String _paymentBody(CavoOrder order) {
    switch (order.paymentStatus) {
      case OrderPaymentStatus.confirmed:
        return 'Payment for order ${order.id} is confirmed.';
      case OrderPaymentStatus.failed:
        return 'Payment for order ${order.id} failed. Please contact support.';
      case OrderPaymentStatus.pending:
        return 'Payment for order ${order.id} is pending.';
    }
  }
}
