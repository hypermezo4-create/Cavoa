import 'package:flutter/material.dart';

import '../../core/localization/app_locale_controller.dart';
import '../../core/localization/l10n_ext.dart';
import '../../core/theme/app_colors.dart';

class CavoLanguagePicker extends StatelessWidget {
  final bool isLight;
  final bool expanded;

  const CavoLanguagePicker({
    super.key,
    required this.isLight,
    this.expanded = false,
  });

  static const _options = <_LanguageOption>[
    _LanguageOption(code: 'EN', flag: '🇬🇧', localeCode: 'en'),
    _LanguageOption(code: 'AR', flag: '🇪🇬', localeCode: 'ar'),
    _LanguageOption(code: 'RU', flag: '🇷🇺', localeCode: 'ru'),
    _LanguageOption(code: 'DE', flag: '🇩🇪', localeCode: 'de'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocaleController.instance,
      builder: (context, locale, _) {
        final current = _options.firstWhere(
          (option) => option.localeCode == locale.languageCode,
          orElse: () => _options.first,
        );

        final child = expanded
            ? Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CavoColors.gold.withValues(alpha: 0.12),
                      ),
                      child: const Icon(
                        Icons.public_rounded,
                        color: CavoColors.gold,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.language,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${current.flag} ${_labelForLocale(context, current.localeCode)}',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: secondaryText,
                    ),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.public_rounded,
                      color: CavoColors.gold,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      current.flag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      current.code,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: secondaryText,
                      size: 18,
                    ),
                  ],
                ),
              );

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(expanded ? 24 : 18),
            onTap: () => _showLanguageSheet(context),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _showLanguageSheet(BuildContext context) async {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final currentCode = AppLocaleController.instance.value.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final l10n = context.l10n;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chooseLanguage,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.languageSelectionDescription,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                ..._options.map((option) {
                  final selected = currentCode == option.localeCode;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          AppLocaleController.instance.setByCode(option.localeCode);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selected
                                ? CavoColors.gold.withValues(alpha: 0.12)
                                : surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? CavoColors.gold.withValues(alpha: 0.35)
                                  : border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(option.flag, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _labelForLocale(context, option.localeCode),
                                      style: TextStyle(
                                        color: primaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option.code,
                                      style: TextStyle(
                                        color: secondaryText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                color: selected ? CavoColors.gold : secondaryText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  String _labelForLocale(BuildContext context, String code) {
    final l10n = context.l10n;
    switch (code) {
      case 'ar':
        return l10n.arabic;
      case 'ru':
        return l10n.russian;
      case 'de':
        return l10n.german;
      default:
        return l10n.english;
    }
  }
}

class _LanguageOption {
  final String code;
  final String flag;
  final String localeCode;

  const _LanguageOption({
    required this.code,
    required this.flag,
    required this.localeCode,
  });
}
