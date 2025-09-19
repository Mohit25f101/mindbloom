import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivitySelectorWidget extends StatelessWidget {
  final String selectedActivity;
  final Function(String) onActivitySelected;

  const ActivitySelectorWidget({
    super.key,
    required this.selectedActivity,
    required this.onActivitySelected,
  });

  final List<Map<String, dynamic>> _activities = const [
    {"label": "Studying", "icon": "menu_book", "color": Color(0xFF4A90E2)},
    {"label": "Exams", "icon": "quiz", "color": Color(0xFFFF6B6B)},
    {"label": "Social", "icon": "groups", "color": Color(0xFF7B68EE)},
    {"label": "Work", "icon": "work", "color": Color(0xFF50C878)},
    {"label": "Exercise", "icon": "fitness_center", "color": Color(0xFFFFB347)},
    {"label": "Relaxing", "icon": "spa", "color": Color(0xFF9B86F5)},
    {"label": "Other", "icon": "more_horiz", "color": Color(0xFF6B7280)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Activity",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedActivity.isEmpty ? null : selectedActivity,
              hint: Text(
                "Select your current activity",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
              isExpanded: true,
              items: _activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity["label"] as String,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: activity["icon"] as String,
                        size: 18,
                        color: activity["color"] as Color,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        activity["label"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  onActivitySelected(value);
                }
              },
              dropdownColor: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
