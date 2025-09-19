import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MoodTagsWidget extends StatelessWidget {
  final List<String> selectedTags;
  final Function(String) onTagToggle;

  const MoodTagsWidget({
    super.key,
    required this.selectedTags,
    required this.onTagToggle,
  });

  final List<Map<String, dynamic>> _moodTags = const [
    {
      "label": "Stressed",
      "icon": "stress_management",
      "color": Color(0xFFFF6B6B)
    },
    {"label": "Anxious", "icon": "psychology", "color": Color(0xFFFFB347)},
    {"label": "Excited", "icon": "celebration", "color": Color(0xFF7B68EE)},
    {"label": "Tired", "icon": "bedtime", "color": Color(0xFF6B7280)},
    {
      "label": "Focused",
      "icon": "center_focus_strong",
      "color": Color(0xFF4A90E2)
    },
    {"label": "Overwhelmed", "icon": "waves", "color": Color(0xFFFF8A8A)},
    {"label": "Motivated", "icon": "trending_up", "color": Color(0xFF50C878)},
    {"label": "Lonely", "icon": "person_outline", "color": Color(0xFF9B86F5)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What's on your mind?",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _moodTags.map((tag) {
            final isSelected = selectedTags.contains(tag["label"] as String);

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onTagToggle(tag["label"] as String);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (tag["color"] as Color).withValues(alpha: 0.15)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (tag["color"] as Color)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: tag["icon"] as String,
                      size: 16,
                      color: isSelected
                          ? (tag["color"] as Color)
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      tag["label"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? (tag["color"] as Color)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
