import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/deen_theme_tokens.dart';

class ModernNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const ModernNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ModernNavItem> items;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;

    return Container(
      decoration: BoxDecoration(
        color: deen.navBackground,
        border: Border(top: BorderSide(color: deen.navBorder, width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: deen.isDark
                ? Colors.black.withOpacity(0.65)
                : Colors.black.withOpacity(0.18),
            blurRadius: 22,
            spreadRadius: -4,
            offset: const Offset(0, -9),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(deen.isDark ? 0.04 : 0.65),
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 16 : 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? deen.navPill : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.22),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(
                                        deen.isDark ? 0.06 : 0.65,
                                      ),
                                      blurRadius: 2,
                                      offset: const Offset(-1, -1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            isSelected
                                ? (item.activeIcon ?? item.icon)
                                : item.icon,
                            size: 22,
                            color:
                                isSelected ? deen.navActive : deen.navInactive,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected ? deen.navActive : deen.navInactive,
                            letterSpacing: -0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
