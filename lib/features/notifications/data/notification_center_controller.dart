import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/order.dart';

class CavoNotificationItem {
  final String id;
  final String orderId;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String type;

  const CavoNotificationItem({
    required this.id,
    required this.orderId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.type,
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
    final notifications = <CavoNotificationItem>[];

    for (final order in orders) {
      final stamp = order.updatedAt ?? order.createdAt;
      notifications.add(
        CavoNotificationItem(
          id: '${order.id}:created',
          orderId: order.id,
          title: _createdTitle(order),
          body: _createdBody(order),
          createdAt: order.createdAt,
          isRead: _readIds.contains('${order.id}:created'),
          type: 'created',
        ),
      );

      if (order.status != OrderStatus.pending) {
        final statusId = '${order.id}:status:${order.status.key}';
        notifications.add(
          CavoNotificationItem(
            id: statusId,
            orderId: order.id,
            title: _statusTitle(order.status),
            body: _statusBody(order),
            createdAt: stamp,
            isRead: _readIds.contains(statusId),
            type: 'status',
          ),
        );
      }

      if (order.status == OrderStatus.delivered && !order.isRated) {
        final rateId = '${order.id}:rate';
        notifications.add(
          CavoNotificationItem(
            id: rateId,
            orderId: order.id,
            title: 'Rate your order',
            body: 'Your CAVO order ${order.id} was delivered. Tap to open tracking and leave your rating.',
            createdAt: stamp,
            isRead: _readIds.contains(rateId),
            type: 'rating',
          ),
        );
      }
    }

    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    value = notifications;
  }

  String _createdTitle(CavoOrder order) => 'Order ${order.id} was created';

  String _createdBody(CavoOrder order) =>
      'Your order total is ${order.total} EGP and it is now waiting for admin review.';

  String _statusTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.approved:
        return 'Order approved';
      case OrderStatus.rejected:
        return 'Order rejected';
      case OrderStatus.processing:
        return 'Order is being prepared';
      case OrderStatus.shipped:
        return 'Order shipped';
      case OrderStatus.delivered:
        return 'Order delivered';
      case OrderStatus.cancelled:
        return 'Order cancelled';
      case OrderStatus.pending:
        return 'Order under review';
    }
  }

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
}
