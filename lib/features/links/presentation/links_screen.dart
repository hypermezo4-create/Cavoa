import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  static const String _websiteUrl = 'https://cavo-store.vercel.app/store';
  static const String _mapsUrl = 'https://maps.app.goo.gl/tiDQ6gDTZNtmHn5SA';
  static const String _whatsAppUrl = 'https://wa.me/201221204322';
  static const String _instagramUrl = 'https://instagram.com/Cavo_mirror';
  static const String _telegramUrl = 'https://t.me/Cavo_store';
  static const String _facebookUrl =
      'https://www.facebook.com/share/18ahZ8oWVH/';
  static const String _tiktokUrl = 'https://www.tiktok.com/@cavo6159';

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    var opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    opened = opened || await launchUrl(uri, mode: LaunchMode.platformDefault);

    if (!opened && context.mounted) {
      final l10n = context.l10n;
      final isLight = Theme.of(context).brightness == Brightness.light;
      final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
      final border = isLight ? CavoColors.lightBorder : CavoColors.border;
      final primaryText =
          isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: surface,
          behavior: SnackBarBehavior.floating,
          content: Text(
            l10n.unableToOpenLink,
            style: TextStyle(color: primaryText),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? CavoColors.lightBackground : CavoColors.background;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final mutedText =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? const [
                    Color(0xFFF8F6F1),
                    Color(0xFFF2EEE5),
                    Color(0xFFECE6DA),
                  ]
                : const [
                    Color(0xFF050505),
                    Color(0xFF080808),
                    Color(0xFF0D0A06),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            children: [
              Text(
                l10n.links,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.linksIntro,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: border),
                  boxShadow: [
                    if (isLight)
                      BoxShadow(
                        color: CavoColors.lightShadow.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CavoColors.gold.withValues(alpha: 0.12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: CavoColors.gold,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.contactHub,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.mirrorOriginalPremiumFootwear,
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.directContact,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _LinkCard(
                title: 'WhatsApp',
                subtitle: l10n.whatsAppSubtitle,
                icon: Icons.chat_rounded,
                isLight: isLight,
                onTap: () => _openUrl(context, _whatsAppUrl),
              ),
              const SizedBox(height: 12),
              _LinkCard(
                title: l10n.storeLocation,
                subtitle: l10n.storeLocationSubtitle,
                icon: Icons.location_on_outlined,
                isLight: isLight,
                onTap: () => _openUrl(context, _mapsUrl),
              ),
              const SizedBox(height: 12),
              _LinkCard(
                title: l10n.website,
                subtitle: l10n.websiteSubtitle,
                icon: Icons.language_rounded,
                isLight: isLight,
                onTap: () => _openUrl(context, _websiteUrl),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.social,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _LinkCard(
                title: 'Instagram',
                subtitle: '@Cavo_mirror',
                icon: Icons.camera_alt_outlined,
                isLight: isLight,
                onTap: () => _openUrl(context, _instagramUrl),
              ),
              const SizedBox(height: 12),
              _LinkCard(
                title: 'Telegram',
                subtitle: l10n.telegramSubtitle,
                icon: Icons.send_rounded,
                isLight: isLight,
                onTap: () => _openUrl(context, _telegramUrl),
              ),
              const SizedBox(height: 12),
              _LinkCard(
                title: 'Facebook',
                subtitle: l10n.facebookSubtitle,
                icon: Icons.facebook_rounded,
                isLight: isLight,
                onTap: () => _openUrl(context, _facebookUrl),
              ),
              const SizedBox(height: 12),
              _LinkCard(
                title: 'TikTok',
                subtitle: '@cavo6159',
                icon: Icons.music_note_rounded,
                isLight: isLight,
                onTap: () => _openUrl(context, _tiktokUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLight;
  final VoidCallback onTap;

  const _LinkCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final subtitleColor =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
          boxShadow: [
            if (isLight)
              BoxShadow(
                color: CavoColors.lightShadow.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CavoColors.gold.withValues(alpha: 0.12),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
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
              color: subtitleColor,
            ),
          ],
        ),
      ),
    );
  }
}
