import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryController extends ValueNotifier<List<String>> {
  SearchHistoryController._() : super(const []);

  static final SearchHistoryController instance = SearchHistoryController._();

  static const _prefsKey = 'cavo_search_history';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        value = decoded.whereType<String>().toList(growable: false);
      }
    } catch (_) {
      value = const [];
    }
  }

  Future<void> addTerm(String term) async {
    final normalized = term.trim();
    if (normalized.isEmpty) return;
    final updated = List<String>.from(value)
      ..removeWhere((item) => item.toLowerCase() == normalized.toLowerCase())
      ..insert(0, normalized);
    if (updated.length > 10) {
      updated.removeRange(10, updated.length);
    }
    value = updated;
    await _persist();
  }

  Future<void> removeTerm(String term) async {
    final updated = List<String>.from(value)
      ..removeWhere((item) => item.toLowerCase() == term.toLowerCase());
    value = updated;
    await _persist();
  }

  Future<void> clear() async {
    value = const [];
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_prefsKey, jsonEncode(value));
  }
}
