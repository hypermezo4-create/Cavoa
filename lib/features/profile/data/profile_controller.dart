import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/user_profile.dart';

class ProfileController extends ValueNotifier<CavoUserProfile?> {
  ProfileController._() : super(null);

  static final ProfileController instance = ProfileController._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferences? _prefs;
  StreamSubscription<User?>? _authSub;
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    _prefs = await SharedPreferences.getInstance();
    _authSub = FirebaseAuth.instance.authStateChanges().listen((_) {
      unawaited(loadForCurrentUser());
    });
    await loadForCurrentUser();
    _ready = true;
  }

  String _prefsKey(String uid) => 'cavo_profile_$uid';

  Future<void> loadForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      value = null;
      return;
    }

    CavoUserProfile profile = CavoUserProfile.empty(uid: user.uid, email: user.email ?? '')
        .copyWith(fullName: user.displayName ?? '');

    final raw = _prefs?.getString(_prefsKey(user.uid));
    if (raw != null && raw.isNotEmpty) {
      try {
        profile = CavoUserProfile.fromMap(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {}
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        profile = CavoUserProfile.fromMap({
          ...profile.toMap(),
          ...doc.data()!,
          'avatarPath': profile.avatarPath,
        });
      }
    } catch (_) {}

    profile = profile.copyWith(
      uid: user.uid,
      email: user.email ?? profile.email,
      fullName: (profile.fullName.trim().isNotEmpty ? profile.fullName : (user.displayName ?? '')).trim(),
    );

    value = profile;
    await _saveLocal(profile);
  }

  Future<void> _saveLocal(CavoUserProfile profile) async {
    await _prefs?.setString(_prefsKey(profile.uid), jsonEncode(profile.toMap()));
  }

  Future<void> saveProfile(CavoUserProfile profile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      value = profile;
      return;
    }

    final merged = profile.copyWith(uid: user.uid, email: user.email ?? profile.email, updatedAt: DateTime.now());
    value = merged;
    await _saveLocal(merged);

    if ((user.displayName ?? '') != merged.fullName && merged.fullName.trim().isNotEmpty) {
      try {
        await user.updateDisplayName(merged.fullName.trim());
      } catch (_) {}
    }

    try {
      await _firestore.collection('users').doc(user.uid).set(
        merged.toFirestoreMap(),
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  Future<void> seedBasicProfile({
    required String fullName,
    required String phone,
    required String gender,
    required int? age,
    required bool visitedBefore,
    String? avatarPath,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final current = value ?? CavoUserProfile.empty(uid: user.uid, email: user.email ?? '');
    await saveProfile(current.copyWith(
      fullName: fullName,
      phone: phone,
      gender: gender,
      age: age,
      visitedBefore: visitedBefore,
      avatarPath: avatarPath,
      city: current.city.isEmpty ? 'Hurghada' : current.city,
    ));
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
