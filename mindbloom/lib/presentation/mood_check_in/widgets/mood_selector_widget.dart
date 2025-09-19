import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MoodSelectorWidget extends StatelessWidget {
  final int selectedMood;
  final Function(int) onMoodSelected;

  const MoodSelectorWidget({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  final List<Map<String, dynamic>> _moodData = const [
    {"emoji": "😢", "label": "Very Sad", "color": Color(0xFFFF6B6B)},
    {"emoji": "😞", "label": "Sad", "color": Color(0xFFFF8A8A)},
    {"emoji": "😐", "label": "Neutral", "color": Color(0xFFFFC266)},
    {"emoji": "🙂", "label": "Good", "color": Color(0xFF6BD085)},
    {"emoji": "😊", "label": "Happy", "color": Color(0xFF50C878)},
    {"emoji": "😄", "label": "Very Happy", "color": Color(0xFF4A90E2)},
    {"emoji": "🤗", "label": "Excited", "color": Color(0xFF7B68EE)},
    {"emoji": "😍", "label": "Loved", "color": Color(0xFFFF69B4)},
    {"emoji": "🤩", "label": "Amazing", "color": Color(0xFFFFD700)},
    {"emoji": "🥳", "label": "Fantastic", "color": Color(0xFF32CD32)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How are you feeling today?",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_moodData.length, (index) {
                  final mood = _moodData[index];
                  final isSelected = selectedMood == index + 1;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onMoodSelected(index + 1);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(right: 3.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (mood["color"] as Color).withValues(alpha: 0.2)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? (mood["color"] as Color)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (mood["color"] as Color)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.2 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              mood["emoji"] as String,
                              style: TextStyle(fontSize: 24.sp),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "${index + 1}",
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? (mood["color"] as Color)
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            mood["label"] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isSelected
                                  ? (mood["color"] as Color)
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
