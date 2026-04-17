import 'package:flutter/material.dart';

import '../../../data/models/order.dart';
import '../../cart/data/cart_controller.dart';

class OrderController extends ValueNotifier<List<CavoOrder>> {
  OrderController._() : super([]);

  static final OrderController instance = OrderController._();

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

  CavoOrder createOrderFromCart({
    required String customerName,
    required String phoneNumber,
    required String city,
    required String area,
    required String notes,
    required OrderPaymentMethod paymentMethod,
  }) {
    final cartItems = CartController.instance.value;

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
        .toList();

    final order = CavoOrder(
      id: _generateOrderId(),
      customerName: customerName,
      phoneNumber: phoneNumber,
      city: city,
      area: area,
      notes: notes,
      paymentMethod: paymentMethod,
      items: items,
      subtotal: CartController.instance.subtotal,
      pickupFee: 0,
      total: CartController.instance.total,
      pickupType: 'Store Pickup',
      status: OrderStatus.pendingReview,
      createdAt: DateTime.now(),
    );

    value = [order, ...value];
    return order;
  }

  void updateStatus(String orderId, OrderStatus status) {
    value = value
        .map(
          (order) => order.id == orderId
              ? CavoOrder(
                  id: order.id,
                  customerName: order.customerName,
                  phoneNumber: order.phoneNumber,
                  city: order.city,
                  area: order.area,
                  notes: order.notes,
                  paymentMethod: order.paymentMethod,
                  items: order.items,
                  subtotal: order.subtotal,
                  pickupFee: order.pickupFee,
                  total: order.total,
                  pickupType: order.pickupType,
                  status: status,
                  createdAt: order.createdAt,
                )
              : order,
        )
        .toList();
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