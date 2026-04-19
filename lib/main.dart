import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/cart/data/cart_controller.dart';
import 'features/favorites/data/favorites_controller.dart';
import 'features/notifications/data/notification_center_controller.dart';
import 'features/orders/data/order_controller.dart';
import 'features/profile/data/profile_controller.dart';
import 'features/search/data/search_history_controller.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'core/localization/app_locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await ThemeModeController.instance.init();
  await AppLocaleController.instance.init();
  await CartController.instance.init();
  await FavoritesController.instance.init();
  await SearchHistoryController.instance.init();
  await NotificationCenterController.instance.init();
  await ProfileController.instance.init();
  OrderController.instance;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CavoApp());
}

class CavoApp extends StatelessWidget {
  const CavoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeModeController.instance,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: AppLocaleController.instance,
          builder: (context, locale, __) {
            return MaterialApp(
              title: 'CAVO',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
