import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CavoColors.background,
      body: Center(
        child: Text(
          'Links',
          style: TextStyle(
            color: CavoColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}