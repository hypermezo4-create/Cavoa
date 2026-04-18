import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends ValueNotifier<Set<String>> {
  FavoritesController._() : super(<String>{});

  static final FavoritesController instance = FavoritesController._();

  static const _prefsKey = 'cavo_favorite_product_ids';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        value = decoded.whereType<String>().toSet();
      }
    } catch (_) {
      value = <String>{};
    }
  }

  bool isFavorite(String productId) => value.contains(productId);

  Future<bool> toggle(String productId) async {
    final updated = Set<String>.from(value);
    final added = !updated.remove(productId);
    if (added) {
      updated.add(productId);
    }
    value = updated;
    await _persist();
    return added;
  }

  Future<void> remove(String productId) async {
    if (!value.contains(productId)) return;
    final updated = Set<String>.from(value)..remove(productId);
    value = updated;
    await _persist();
  }

  Future<void> clear() async {
    value = <String>{};
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_prefsKey, jsonEncode(value.toList(growable: false)));
  }
}
