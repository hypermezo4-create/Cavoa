import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  void _showLinkSheet(
    BuildContext context, {
    required String title,
    required String subtitle,
    String? value,
    String? note,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              if (value != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (isLight
                            ? CavoColors.lightSurfaceSoft
                            : CavoColors.surfaceSoft)
                        .withOpacity(0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: border),
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (note != null) ...[
                const SizedBox(height: 10),
                Text(
                  note,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  if (value != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: value),
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: surface,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  '$title copied successfully.',
                                  style: TextStyle(color: primaryText),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: border),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Copy'),
                      ),
                    ),
                  if (value != null) const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Links',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'All CAVO contact points in one place',
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
                  color: surface.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: border),
                  boxShadow: [
                    if (isLight)
                      BoxShadow(
                        color: CavoColors.lightShadow.withOpacity(0.08),
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
                        color: CavoColors.gold.withOpacity(0.12),
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
                            'CAVO Contact Hub',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mirror Original • Premium Footwear',
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
                'Direct Contact',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              _LinkCard(
                title: 'WhatsApp',
                subtitle: 'Fast orders and direct communication',
                icon: Icons.chat_rounded,
                isLight: isLight,
                onTap: () => _showLinkSheet(
                  context,
                  title: 'WhatsApp',
                  subtitle: 'Use this number for direct contact and orders.',
                  value: '01221204322',
                  note: 'You can copy it now and we can connect direct opening later.',
                ),
              ),
              const SizedBox(height: 12),

              _LinkCard(
                title: 'Store Location',
                subtitle: 'Hurghada branch location details',
                icon: Icons.location_on_outlined,
                isLight: isLight,
                onTap: () => _showLinkSheet(
                  context,
                  title: 'Store Location',
                  subtitle: 'Current saved store location.',
                  value:
                      'كارفور طريق عربيا مول سيتي سنتر الغردقه الدور الاول أما ديفاكتو',
                ),
              ),

              const SizedBox(height: 22),
              Text(
                'Social',
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
                onTap: () => _showLinkSheet(
                  context,
                  title: 'Instagram',
                  subtitle: 'Official Instagram username',
                  value: 'Cavo_mirror',
                ),
              ),
              const SizedBox(height: 12),

              _LinkCard(
                title: 'Telegram',
                subtitle: 'Cavo_store channel',
                icon: Icons.send_rounded,
                isLight: isLight,
                onTap: () => _showLinkSheet(
                  context,
                  title: 'Telegram',
                  subtitle: 'Official Telegram link',
                  value: 'https://t.me/Cavo_store',
                ),
              ),
              const SizedBox(height: 12),

              _LinkCard(
                title: 'Facebook',
                subtitle: 'Official Facebook page',
                icon: Icons.facebook_rounded,
                isLight: isLight,
                onTap: () => _showLinkSheet(
                  context,
                  title: 'Facebook',
                  subtitle: 'Official Facebook link',
                  value: 'https://www.facebook.com/share/18ahZ8oWVH/',
                ),
              ),
              const SizedBox(height: 12),

              _LinkCard(
                title: 'TikTok',
                subtitle: '@cavo6159',
                icon: Icons.music_note_rounded,
                isLight: isLight,
                onTap: () => _showLinkSheet(
                  context,
                  title: 'TikTok',
                  subtitle: 'Official TikTok username',
                  value: 'cavo6159',
                ),
              ),

              const SizedBox(height: 22),
              Text(
                'Apps',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              _LinkCard(
                title: 'Android App',
                subtitle: 'Coming soon',
                icon: Icons.android_rounded,
                isLight: isLight,
                onTap: () => _showLinkSheet(
                  context,
                  title: 'Android App',
                  subtitle: 'The Android app link will be added here later.',
                  note: 'Not available yet.',
                ),
              ),
              const SizedBox(height: 12),

              _LinkCard(
                title: 'iOS App',
                subtitle: 'Coming soon',
                icon: Icons.phone_iphone_rounded,
                isLight: isLight,
                onTap: () => _showLinkSheet(
                  context,
                  title: 'iOS App',
                  subtitle: 'The iOS app link will be added here later.',
                  note: 'Not available yet.',
                ),
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
          color: surface.withOpacity(0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
          boxShadow: [
            if (isLight)
              BoxShadow(
                color: CavoColors.lightShadow.withOpacity(0.08),
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
                color: CavoColors.gold.withOpacity(0.12),
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