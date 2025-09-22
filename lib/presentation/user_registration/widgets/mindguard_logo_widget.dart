import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MindbloomLogoWidget extends StatelessWidget {
  final double? size;
  final bool showText;

  const MindbloomLogoWidget({
    super.key,
    this.size,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final logoSize = size ?? 20.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Container with therapeutic design
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(logoSize * 0.25),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background pattern
              Container(
                width: logoSize * 0.8,
                height: logoSize * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(logoSize * 0.2),
                ),
              ),

              // Main icon - shield with heart
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: Colors.white,
                    size: logoSize * 0.35,
                  ),
                  SizedBox(height: logoSize * 0.05),
                  CustomIconWidget(
                    iconName: 'favorite',
                    color: Colors.white.withValues(alpha: 0.9),
                    size: logoSize * 0.2,
                  ),
                ],
              ),
            ],
          ),
        ),

        // App name and tagline
        if (showText) ...[
          SizedBox(height: 3.h),
          Text(
            'Mindbloom',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your Mental Health Companion',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
