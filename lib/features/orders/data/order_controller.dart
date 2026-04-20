import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/order.dart';
import '../../cart/data/cart_controller.dart';
import '../../notifications/data/notification_center_controller.dart';

class OrderController extends ValueNotifier<List<CavoOrder>> {
  OrderController._() : super([]) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      _bindCurrentUserOrders();
    });
    _bindCurrentUserOrders();
  }

  static final OrderController instance = OrderController._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;
  StreamSubscription<User?>? _authSubscription;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');


  void _bindCurrentUserOrders() {
    _ordersSubscription?.cancel();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      value = const <CavoOrder>[];
      NotificationCenterController.instance.syncFromOrders(value);
      return;
    }

    _ordersSubscription = _ordersCollection
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      final orders = snapshot.docs
          .map((doc) => CavoOrder.fromMap(doc.data()))
          .toList(growable: false);
      orders.sort((a, b) => (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));
      value = orders;
      NotificationCenterController.instance.syncFromOrders(orders);
    });
  }

  String _generateOrderId() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final h = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    return 'CAVO-$y$m$d-$h$min$s';
  }

  Future<CavoOrder> createOrderFromCart({
    required String customerName,
    required String phoneNumber,
    required String city,
    required String area,
    required String addressLine,
    required String notes,
    required OrderPaymentMethod paymentMethod,
    String pickupType = 'delivery',
  }) async {
    final cartItems = CartController.instance.value;
    final user = FirebaseAuth.instance.currentUser;

    final items = cartItems
        .map(
          (item) => CavoOrderItem(
            productId: item.product.id,
            title: item.product.title,
            brand: item.product.brand,
            size: item.size,
            unitPrice: item.product.price,
            quantity: item.quantity,
          ),
        )
        .toList(growable: false);

    final order = CavoOrder(
      id: _generateOrderId(),
      userId: user?.uid,
      userEmail: user?.email,
      customerName: customerName,
      phoneNumber: phoneNumber,
      city: city,
      area: area,
      addressLine: addressLine,
      notes: notes,
      paymentMethod: paymentMethod,
      items: items,
      subtotal: CartController.instance.subtotal,
      pickupFee: CartController.instance.delivery,
      total: CartController.instance.total,
      pickupType: pickupType,
      status: OrderStatus.pendingReview,
      createdAt: DateTime.now(),
    );

    await _ordersCollection.doc(order.id).set(order.toMap());
    value = [order, ...value];
    NotificationCenterController.instance.syncFromOrders(value);
    return order;
  }

  Stream<List<CavoOrder>> watchCurrentUserOrders() {
    _bindCurrentUserOrders();
    return Stream<List<CavoOrder>>.multi((controller) {
      controller.add(value);
      void listener() => controller.add(value);
      addListener(listener);
      controller.onCancel = () => removeListener(listener);
    });
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    final existing = findById(orderId);
    if (existing != null) {
      value = value
          .map((order) => order.id == orderId
              ? order.copyWith(status: status, updatedAt: DateTime.now())
              : order)
          .toList(growable: false);
      NotificationCenterController.instance.syncFromOrders(value);
    }

    await _ordersCollection.doc(orderId).set(
      {
        'status': status.key,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> submitRating({
    required String orderId,
    required int rating,
    required List<String> tags,
  }) async {
    final ratedAt = DateTime.now();

    value = value
        .map((order) => order.id == orderId
            ? order.copyWith(
                rating: rating,
                ratingTags: tags,
                ratedAt: ratedAt,
                updatedAt: ratedAt,
              )
            : order)
        .toList(growable: false);
    NotificationCenterController.instance.syncFromOrders(value);

    await _ordersCollection.doc(orderId).set(
      {
        'rating': rating,
        'ratingTags': tags,
        'ratedAt': ratedAt,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  CavoOrder? findById(String orderId) {
    try {
      return value.firstWhere((order) => order.id == orderId);
    } catch (_) {
      return null;
    }
  }

  void clearAll() {
    value = [];
  }
}
