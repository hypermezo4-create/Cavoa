import 'package:flutter/material.dart';
import '../../../data/models/product.dart';

class CartItem {
  final CavoProduct product;
  final String? size;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.quantity,
  });
}

class CartController extends ValueNotifier<List<CartItem>> {
  CartController._() : super([]);

  static final CartController instance = CartController._();

  void addItem({
    required CavoProduct product,
    required String? size,
    required int quantity,
  }) {
    final index = value.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index != -1) {
      value[index].quantity += quantity;
      value = List.from(value);
      return;
    }

    value = [
      ...value,
      CartItem(
        product: product,
        size: size,
        quantity: quantity,
      ),
    ];
  }

  void increaseQuantity(int index) {
    value[index].quantity++;
    value = List.from(value);
  }

  void decreaseQuantity(int index) {
    if (value[index].quantity > 1) {
      value[index].quantity--;
      value = List.from(value);
    }
  }

  void removeItem(int index) {
    final updated = List<CartItem>.from(value);
    updated.removeAt(index);
    value = updated;
  }

  void clear() {
    value = [];
  }

  int get subtotal {
    return value.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  int get delivery => value.isEmpty ? 0 : 75;

  int get total => subtotal + delivery;
}