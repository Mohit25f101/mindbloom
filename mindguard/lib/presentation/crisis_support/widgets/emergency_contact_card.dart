import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmergencyContactCard extends StatelessWidget {
  final Map<String, dynamic> contact;
  final VoidCallback? onCall;
  final VoidCallback? onText;

  const EmergencyContactCard({
    super.key,
    required this.contact,
    this.onCall,
    this.onText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Contact Avatar
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'person',
                color: colorScheme.primary,
                size: 6.w,
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact["name"] as String? ?? "Emergency Contact",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  contact["relationship"] as String? ?? "Contact",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (contact["phone"] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    contact["phone"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Call Button
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  onPressed: onCall,
                  icon: CustomIconWidget(
                    iconName: 'phone',
                    color: colorScheme.primary,
                    size: 5.w,
                  ),
                  tooltip: 'Call ${contact["name"]}',
                ),
              ),

              SizedBox(width: 2.w),

              // Text Button
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  onPressed: onText,
                  icon: CustomIconWidget(
                    iconName: 'message',
                    color: colorScheme.secondary,
                    size: 5.w,
                  ),
                  tooltip: 'Text ${contact["name"]}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
