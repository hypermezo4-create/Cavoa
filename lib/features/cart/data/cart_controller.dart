import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/mock/cavo_catalog.dart';
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

  Map<String, dynamic> toMap() => {
        'productId': product.id,
        'size': size,
        'quantity': quantity,
      };
}

class CartController extends ValueNotifier<List<CartItem>> {
  CartController._() : super([]);

  static final CartController instance = CartController._();

  static const _prefsKey = 'cavo_cart_items';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        final restored = <CartItem>[];
        for (final item in decoded) {
          if (item is! Map) continue;
          final productId = item['productId'];
          final quantity = item['quantity'];
          if (productId is! String || quantity is! num) continue;
          final product = CavoCatalog.findById(productId);
          if (product == null) continue;
          restored.add(
            CartItem(
              product: product,
              size: item['size'] as String?,
              quantity: quantity.toInt().clamp(1, 99),
            ),
          );
        }
        value = restored;
      }
    } catch (_) {
      value = [];
    }
  }

  Future<void> addItem({
    required CavoProduct product,
    required String? size,
    required int quantity,
  }) async {
    final index = value.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index != -1) {
      value[index].quantity += quantity;
      value = List.from(value);
      await _persist();
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
    await _persist();
  }

  Future<void> increaseQuantity(int index) async {
    value[index].quantity++;
    value = List.from(value);
    await _persist();
  }

  Future<void> decreaseQuantity(int index) async {
    if (value[index].quantity > 1) {
      value[index].quantity--;
      value = List.from(value);
      await _persist();
    }
  }

  Future<void> removeItem(int index) async {
    final updated = List<CartItem>.from(value);
    updated.removeAt(index);
    value = updated;
    await _persist();
  }

  Future<void> clear() async {
    value = [];
    await _persist();
  }

  int get subtotal {
    return value.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  int get delivery => 0;

  int get total => subtotal + delivery;

  Future<void> _persist() async {
    await _prefs?.setString(
      _prefsKey,
      jsonEncode(value.map((item) => item.toMap()).toList(growable: false)),
    );
  }
}
