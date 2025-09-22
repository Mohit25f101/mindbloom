import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item for the bottom bar
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom navigation bar optimized for mental health app
/// with one-handed operation and therapeutic design principles
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool showLabels;
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    this.elevation = 8.0,
  });

  // Hardcoded navigation items for mental health app
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    BottomNavItem(
      icon: Icons.mood_outlined,
      activeIcon: Icons.mood,
      label: 'Mood Check',
      route: '/mood-check-in',
    ),
    BottomNavItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'AI Chat',
      route: '/ai-companion-chat',
    ),
    BottomNavItem(
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
      route: '/mood-history',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(20),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72.0,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onTap != null) {
                      onTap!(index);
                    } else {
                      Navigator.pushNamed(context, item.route);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon with therapeutic animation
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary.withAlpha(26)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            isSelected
                                ? (item.activeIcon ?? item.icon)
                                : item.icon,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface.withAlpha(153),
                            size: 24.0,
                          ),
                        ),

                        // Label with fade animation
                        if (showLabels) ...[
                          const SizedBox(height: 2.0),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withAlpha(153),
                            ),
                            child: Text(
                              item.label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
