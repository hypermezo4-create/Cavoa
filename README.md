# CAVO i18n starter pack

This pack adds a real Flutter localization foundation for:
- English (default)
- Arabic
- Russian
- German

## Files included
- `lib/main.dart`
- `lib/core/localization/app_locale_controller.dart`
- `lib/core/localization/l10n_ext.dart`
- `lib/features/welcome/presentation/welcome_placeholder_screen.dart`
- `lib/features/auth/presentation/login_screen.dart`
- `lib/features/auth/presentation/register_screen.dart`
- `lib/features/profile/presentation/profile_screen.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ar.arb`
- `lib/l10n/app_ru.arb`
- `lib/l10n/app_de.arb`
- `l10n.yaml`
- `pubspec.yaml`

## After copying files
Run:

```bash
flutter pub get
flutter gen-l10n
flutter run
```

## Important
To make the whole app multilingual, every visible string in the remaining screens
must be moved into the ARB files and replaced with `context.l10n.yourKey`.
