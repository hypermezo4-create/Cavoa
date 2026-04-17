import 'package:flutter/material.dart';

class MainNavigationController extends ValueNotifier<int> {
  MainNavigationController._() : super(0);

  static final MainNavigationController instance = MainNavigationController._();

  void goTo(int index) => value = index;
}
