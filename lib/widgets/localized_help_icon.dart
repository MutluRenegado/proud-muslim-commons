import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/deen_theme_tokens.dart';

class LocalizedHelpIcon extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final double size;
  final Color? color;
  final String? tooltip;

  const LocalizedHelpIcon({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.info_outline_rounded,
    this.size = 18,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;

    return IconButton(
      icon: Icon(icon, size: size, color: color ?? deen.textMuted),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: size + 8, minHeight: size + 8),
      splashRadius: size + 6,
      tooltip: tooltip ?? title,
      onPressed: () => _showHelpBottomSheet(context, deen),
    );
  }

  void _showHelpBottomSheet(BuildContext context, DeenThemeTokens deen) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: deen.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: deen.accentPrimary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: deen.accentPrimary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: deen.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    height: 1.5,
                    color: deen.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      foregroundColor: deen.accentGold,
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
