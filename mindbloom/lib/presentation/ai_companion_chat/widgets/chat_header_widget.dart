import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ChatHeaderWidget extends StatelessWidget {
  final VoidCallback? onClearChat;
  final VoidCallback? onCrisisResources;
  final VoidCallback? onSettings;
  final bool isOnline;

  const ChatHeaderWidget({
    super.key,
    this.onClearChat,
    this.onCrisisResources,
    this.onSettings,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back_ios',
                color: theme.colorScheme.onSurface,
                size: 6.w,
              ),
              tooltip: 'Back',
            ),

            SizedBox(width: 2.w),

            // AI Avatar
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // AI Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MindGuard AI',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: isOnline
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.outline,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Options menu
            PopupMenuButton<String>(
              onSelected: _handleMenuSelection,
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: theme.colorScheme.onSurface,
                size: 6.w,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'clear_all',
                        color: theme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text('Clear Chat'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'crisis',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'emergency',
                        color: theme.colorScheme.error,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Crisis Resources',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'settings',
                        color: theme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text('Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'clear':
        onClearChat?.call();
        break;
      case 'crisis':
        onCrisisResources?.call();
        break;
      case 'settings':
        onSettings?.call();
        break;
    }
  }
}
