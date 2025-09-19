import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MoodHistoryTimelineWidget extends StatelessWidget {
  const MoodHistoryTimelineWidget({super.key});

  final List<Map<String, dynamic>> _recentMoods = const [
    {
      "date": "Today",
      "mood": 7,
      "emoji": "😊",
      "color": Color(0xFF50C878),
      "time": "Morning"
    },
    {
      "date": "Yesterday",
      "mood": 5,
      "emoji": "😐",
      "color": Color(0xFFFFC266),
      "time": "Evening"
    },
    {
      "date": "2 days ago",
      "mood": 8,
      "emoji": "😄",
      "color": Color(0xFF4A90E2),
      "time": "Afternoon"
    },
    {
      "date": "3 days ago",
      "mood": 4,
      "emoji": "😞",
      "color": Color(0xFFFF8A8A),
      "time": "Night"
    },
    {
      "date": "4 days ago",
      "mood": 9,
      "emoji": "🤗",
      "color": Color(0xFF7B68EE),
      "time": "Morning"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Recent Mood History",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/mood-history'),
              child: Text(
                "View All",
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _recentMoods.length,
            itemBuilder: (context, index) {
              final mood = _recentMoods[index];

              return Container(
                width: 20.w,
                margin: EdgeInsets.only(right: 3.w),
                child: Column(
                  children: [
                    Container(
                      width: 12.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: (mood["color"] as Color).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: mood["color"] as Color,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          mood["emoji"] as String,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      mood["date"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      mood["time"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
