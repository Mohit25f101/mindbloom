import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget implementing therapeutic minimalism design
/// for mental health applications with crisis support accessibility
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showCrisisButton;
  final VoidCallback? onCrisisPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.showCrisisButton = false,
    this.onCrisisPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Semantics(
        header: true,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: foregroundColor ?? colorScheme.onSurface,
          ),
        ),
      ),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? Semantics(
                  button: true,
                  label: 'Go back to previous screen',
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      semanticLabel: 'Back arrow',
                    ),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Back',
                  ),
                )
              : null),
      actions: [
        // Crisis support button for immediate accessibility
        if (showCrisisButton)
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: Semantics(
              button: true,
              label: 'Access crisis support',
              hint: 'Get immediate help and support',
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withAlpha(26),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    Icons.emergency,
                    color: theme.colorScheme.error,
                    size: 20,
                    semanticLabel: 'Emergency',
                  ),
                ),
                onPressed: onCrisisPressed ??
                    () {
                      Navigator.pushNamed(context, '/crisis-support');
                    },
                tooltip: 'Crisis Support',
              ),
            ),
          ),
        ..._wrapActionsWithSemantics(actions),
        const SizedBox(width: 8.0),
      ],
      surfaceTintColor: Colors.transparent,
      shadowColor: theme.colorScheme.shadow,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Merges additional actions with the crisis support button
  List<Widget> _wrapActionsWithSemantics(List<Widget>? actions) {
    if (actions == null) return [];
    return actions.map((action) {
      // If action is already a Semantics widget, return as is
      if (action is Semantics) return action;
      // If action is an IconButton or TextButton, wrap with Semantics
      if (action is IconButton || action is TextButton) {
        return Semantics(
          button: true,
          label: (action as dynamic).tooltip ?? 'Action button',
          child: action,
        );
      }
      return action;
    }).toList();
  }
}
