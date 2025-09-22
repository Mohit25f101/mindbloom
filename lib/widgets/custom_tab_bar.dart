import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item for the custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
  });
}

/// Custom tab bar implementing therapeutic design principles
/// with smooth animations and accessibility features
class CustomTabBar extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final Function(int)? onTap;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double indicatorWeight;
  final TabBarIndicatorSize indicatorSize;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    this.onTap,
    this.isScrollable = false,
    this.padding,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorWeight = 3.0,
    this.indicatorSize = TabBarIndicatorSize.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withAlpha(51),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
          child: isScrollable
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildTabRow(context, colorScheme),
                )
              : _buildTabRow(context, colorScheme),
        ),
      ),
    );
  }

  Widget _buildTabRow(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: isScrollable
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceEvenly,
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final isSelected = currentIndex == index;

        return Flexible(
          flex: isScrollable ? 0 : 1,
          child: GestureDetector(
            onTap: () => onTap?.call(index),
            child: Container(
              margin: isScrollable
                  ? const EdgeInsets.only(right: 24.0)
                  : EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon if provided
                  if (tab.icon != null || tab.customIcon != null) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: tab.customIcon ??
                          Icon(
                            tab.icon,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface.withAlpha(153),
                            size: 20.0,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                  ],

                  // Label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(179),
                    ),
                    child: Text(
                      tab.label,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Indicator
                  const SizedBox(height: 8.0),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: indicatorWeight,
                    width: isSelected ? 24.0 : 0.0,
                    decoration: BoxDecoration(
                      color: indicatorColor ?? colorScheme.primary,
                      borderRadius: BorderRadius.circular(indicatorWeight / 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Tab bar controller for managing tab state
class CustomTabController extends ChangeNotifier {
  int _currentIndex = 0;
  final int length;

  CustomTabController({required this.length});

  int get currentIndex => _currentIndex;

  void animateTo(int index) {
    if (index >= 0 && index < length && index != _currentIndex) {
      _currentIndex = index;
      notifyListeners();
    }
  }

}
