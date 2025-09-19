import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CrisisActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const CrisisActionButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: isPrimary ? 4.0 : 2.0,
          shadowColor: backgroundColor.withValues(alpha: 0.3),
          padding: EdgeInsets.symmetric(
            horizontal: 6.w,
            vertical: isPrimary ? 4.h : 3.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: isPrimary ? 14.w : 12.w,
              height: isPrimary ? 14.w : 12.w,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: textColor,
                  size: isPrimary ? 7.w : 6.w,
                ),
              ),
            ),

            SizedBox(width: 4.w),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: isPrimary ? 18.sp : 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor.withValues(alpha: 0.8),
                        fontSize: isPrimary ? 14.sp : 12.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Arrow Icon
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: textColor.withValues(alpha: 0.7),
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
