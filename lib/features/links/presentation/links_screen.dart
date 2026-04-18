import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  static const _whatsAppNumber = '201221204322';
  static const _facebookUrl = 'https://www.facebook.com/share/18ahZ8oWVH/';
  static const _telegramUrl = 'https://t.me/Cavo_store';
  static const _instagramUrl = 'https://www.instagram.com/Cavo_mirror';
  static const _tiktokUrl = 'https://www.tiktok.com/@cavo6159';
  static const _mapsUrl = 'https://maps.google.com/?q=Carrefour+Arabia+Mall+City+Center+Hurghada';
  static const _websiteUrl = 'https://cavoproo.vercel.app/';

  Future<void> _openUrl(BuildContext context, String url) async {
    final opened = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unableToOpenLink)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
            children: [
              CavoSectionHeader(
                title: context.l10n.links,
                subtitle: context.l10n.linksIntro,
                isLight: isLight,
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(34)),
                child: Row(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: CavoColors.gold.withValues(alpha: 0.18),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/branding/cavo_logo_circle.png', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.contactHub,
                            style: TextStyle(
                              color: primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'All direct contact points for CAVO in one premium hub, including WhatsApp, social, maps, and the website.',
                            style: TextStyle(
                              color: secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _LinkTile(
                title: 'WhatsApp',
                subtitle: context.l10n.whatsAppSubtitle,
                icon: Icons.chat_rounded,
                accent: const Color(0xFF25D366),
                isLight: isLight,
                onTap: () => _openUrl(context, 'https://wa.me/$_whatsAppNumber'),
              ),
              const SizedBox(height: 12),
              _LinkTile(
                title: context.l10n.storeLocation,
                subtitle: context.l10n.storeLocationSubtitle,
                icon: Icons.location_on_rounded,
                accent: const Color(0xFF4285F4),
                isLight: isLight,
                onTap: () => _openUrl(context, _mapsUrl),
              ),
              const SizedBox(height: 12),
              _LinkTile(
                title: context.l10n.website,
                subtitle: context.l10n.websiteSubtitle,
                icon: Icons.language_rounded,
                accent: CavoColors.gold,
                isLight: isLight,
                onTap: () => _openUrl(context, _websiteUrl),
              ),
              const SizedBox(height: 18),
              CavoSectionHeader(
                title: context.l10n.social,
                subtitle: 'Native brand colors are preserved inside the cards for a more premium identity.',
                isLight: isLight,
              ),
              const SizedBox(height: 12),
              _LinkTile(
                title: 'Instagram',
                subtitle: '@Cavo_mirror',
                icon: Icons.camera_alt_rounded,
                accent: const Color(0xFFE4405F),
                isLight: isLight,
                onTap: () => _openUrl(context, _instagramUrl),
              ),
              const SizedBox(height: 12),
              _LinkTile(
                title: 'Telegram',
                subtitle: context.l10n.telegramSubtitle,
                icon: Icons.send_rounded,
                accent: const Color(0xFF229ED9),
                isLight: isLight,
                onTap: () => _openUrl(context, _telegramUrl),
              ),
              const SizedBox(height: 12),
              _LinkTile(
                title: 'Facebook',
                subtitle: context.l10n.facebookSubtitle,
                icon: Icons.facebook_rounded,
                accent: const Color(0xFF1877F2),
                isLight: isLight,
                onTap: () => _openUrl(context, _facebookUrl),
              ),
              const SizedBox(height: 12),
              _LinkTile(
                title: 'TikTok',
                subtitle: '@cavo6159',
                icon: Icons.music_note_rounded,
                accent: const Color(0xFFFE2C55),
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

class _LinkTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final bool isLight;
  final VoidCallback onTap;

  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: CavoGlassCard(
        isLight: isLight,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.14),
                border: Border.all(color: accent.withValues(alpha: 0.22)),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded, color: accent, size: 16),
          ],
        ),
      ),
    );
  }
}
