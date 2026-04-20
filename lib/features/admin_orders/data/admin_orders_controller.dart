import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/order.dart';

class AdminOrdersController {
  AdminOrdersController._();

  static final AdminOrdersController instance = AdminOrdersController._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  Stream<List<CavoOrder>> watchAllOrders() {
    return _ordersCollection.snapshots().map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => CavoOrder.fromMap(doc.data()))
          .toList(growable: false);
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  Stream<CavoOrder?> watchOrder(String orderId) {
    return _ordersCollection.doc(orderId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return CavoOrder.fromMap(data);
    });
  }

  Future<void> approveOrder(String orderId, {String adminNote = ''}) {
    return _applyUpdate(
      orderId: orderId,
      status: OrderStatus.approved,
      adminNote: adminNote,
      notificationTitle: 'Order approved',
      notificationBody:
          'Your order $orderId has been approved by the admin team.',
    );
  }

  Future<void> rejectOrder({
    required String orderId,
    required String rejectionReason,
    String adminNote = '',
  }) {
    if (rejectionReason.trim().isEmpty) {
      throw ArgumentError('Rejection reason is required when rejecting.');
    }
    return _applyUpdate(
      orderId: orderId,
      status: OrderStatus.rejected,
      rejectionReason: rejectionReason,
      adminNote: adminNote,
      notificationTitle: 'Order rejected',
      notificationBody:
          'Your order $orderId was rejected. Reason: ${rejectionReason.trim()}',
    );
  }

  Future<void> markProcessing(String orderId, {String adminNote = ''}) {
    return _applyUpdate(
      orderId: orderId,
      status: OrderStatus.processing,
      adminNote: adminNote,
      notificationTitle: 'Order is being processed',
      notificationBody:
          'Your order $orderId is now being prepared by the CAVO team.',
    );
  }

  Future<void> markShipped(String orderId, {String adminNote = ''}) {
    return _applyUpdate(
      orderId: orderId,
      status: OrderStatus.shipped,
      adminNote: adminNote,
      notificationTitle: 'Order shipped',
      notificationBody:
          'Your order $orderId has been shipped and is on the way.',
    );
  }

  Future<void> markDelivered(String orderId, {String adminNote = ''}) {
    return _applyUpdate(
      orderId: orderId,
      status: OrderStatus.delivered,
      adminNote: adminNote,
      notificationTitle: 'Order delivered',
      notificationBody: 'Your order $orderId has been marked as delivered.',
    );
  }

  Future<void> cancelOrder(String orderId, {String adminNote = ''}) {
    return _applyUpdate(
      orderId: orderId,
      status: OrderStatus.cancelled,
      adminNote: adminNote,
      notificationTitle: 'Order cancelled',
      notificationBody: 'Your order $orderId was cancelled by admin.',
    );
  }

  Future<void> updatePaymentStatus({
    required String orderId,
    required OrderPaymentStatus paymentStatus,
    String adminNote = '',
  }) {
    return _applyUpdate(
      orderId: orderId,
      paymentStatus: paymentStatus,
      adminNote: adminNote,
      notificationTitle: 'Payment status updated',
      notificationBody:
          'Payment status for order $orderId is now ${paymentStatus.key}.',
    );
  }

  Future<void> addAdminNote({
    required String orderId,
    required String adminNote,
  }) {
    if (adminNote.trim().isEmpty) {
      throw ArgumentError('Admin note cannot be empty.');
    }
    return _applyUpdate(
      orderId: orderId,
      adminNote: adminNote,
      notificationTitle: 'Order update',
      notificationBody:
          'There is a new update from admin on your order $orderId.',
    );
  }

  Future<void> _applyUpdate({
    required String orderId,
    OrderStatus? status,
    OrderPaymentStatus? paymentStatus,
    String? adminNote,
    String? rejectionReason,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    final now = DateTime.now();
    await _firestore.runTransaction((transaction) async {
      final docRef = _ordersCollection.doc(orderId);
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Order $orderId not found');
      }
      final data = snapshot.data() ?? <String, dynamic>{};
      final existingRaw = data['userNotifications'];
      final existing = existingRaw is List
          ? existingRaw.map((entry) {
              if (entry is Map<String, dynamic>) return Map<String, dynamic>.from(entry);
              if (entry is Map) return Map<String, dynamic>.from(entry);
              return <String, dynamic>{};
            }).toList(growable: true)
          : <Map<String, dynamic>>[];

      final notificationId =
          '$orderId:admin:${now.millisecondsSinceEpoch}:${notificationTitle.toLowerCase().replaceAll(' ', '_')}';

      existing.add(
        {
          'id': notificationId,
          'title': notificationTitle,
          'body': notificationBody,
          'createdAt': now,
        },
      );

      final payload = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
        'userNotifications': existing,
      };

      if (status != null) {
        payload['status'] = status.key;
      }
      if (paymentStatus != null) {
        payload['paymentStatus'] = paymentStatus.key;
        payload['payment'] = {
          'method': (data['payment'] is Map ? (data['payment']['method'] ?? 'instaPay') : 'instaPay').toString(),
          'status': paymentStatus.key,
        };
      }
      if (adminNote != null && adminNote.trim().isNotEmpty) {
        payload['adminNote'] = adminNote.trim();
      }
      if (status == OrderStatus.rejected) {
        payload['rejectionReason'] = rejectionReason?.trim() ?? '';
      }

      transaction.set(docRef, payload, SetOptions(merge: true));
    });
  }
}
