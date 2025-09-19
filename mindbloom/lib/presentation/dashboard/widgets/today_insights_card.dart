import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodayInsightsCard extends StatefulWidget {
  const TodayInsightsCard({super.key});

  @override
  State<TodayInsightsCard> createState() => _TodayInsightsCardState();
}

class _TodayInsightsCardState extends State<TodayInsightsCard> {
  int currentInsightIndex = 0;

  final List<Map<String, dynamic>> insights = [
    {
      "title": "Sleep Pattern Analysis",
      "description":
          "You've been getting 7.2 hours of sleep on average. Consider maintaining this healthy pattern for optimal mental wellness.",
      "icon": "bedtime",
      "type": "positive",
      "action": "View Sleep Tips",
    },
    {
      "title": "Stress Level Alert",
      "description":
          "Your stress indicators have increased by 20% this week. Try some breathing exercises or take a short walk.",
      "icon": "psychology",
      "type": "warning",
      "action": "Start Breathing Exercise",
    },
    {
      "title": "Social Connection",
      "description":
          "You haven't logged social activities in 3 days. Connecting with friends can boost your mood significantly.",
      "icon": "people",
      "type": "suggestion",
      "action": "Connect with Friends",
    },
  ];

  void _nextInsight() {
    setState(() {
      currentInsightIndex = (currentInsightIndex + 1) % insights.length;
    });
  }

  void _previousInsight() {
    setState(() {
      currentInsightIndex =
          (currentInsightIndex - 1 + insights.length) % insights.length;
    });
  }

  Color _getInsightColor(String type) {
    switch (type) {
      case 'positive':
        return AppTheme.successLight;
      case 'warning':
        return AppTheme.warningLight;
      case 'suggestion':
        return AppTheme.primaryLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentInsight = insights[currentInsightIndex];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _previousInsight,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: 'chevron_left',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: _nextInsight,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: 'chevron_right',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(currentInsightIndex),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: _getInsightColor(currentInsight["type"])
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: currentInsight["icon"],
                            color: _getInsightColor(currentInsight["type"]),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            currentInsight["title"],
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      currentInsight["description"],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle action based on insight type
                          switch (currentInsight["type"]) {
                            case 'warning':
                              // Navigate to breathing exercises or coping strategies
                              break;
                            case 'suggestion':
                              // Navigate to social features or community
                              break;
                            default:
                              // Navigate to relevant feature
                              break;
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _getInsightColor(currentInsight["type"]),
                          ),
                          foregroundColor:
                              _getInsightColor(currentInsight["type"]),
                        ),
                        child: Text(currentInsight["action"]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Insight indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: insights.asMap().entries.map((entry) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: entry.key == currentInsightIndex ? 6.w : 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: entry.key == currentInsightIndex
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
