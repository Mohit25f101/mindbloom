import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/mood_analytics.dart';
import '../../../widgets/custom_icon_widget.dart';

class MoodAnalyticsInsights extends StatelessWidget {
  final List<MoodEntry> entries;
  final String selectedPeriod;

  const MoodAnalyticsInsights({
    super.key,
    required this.entries,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final insights = _generateInsights();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Insights',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          for (final insight in insights) _buildInsightItem(context, insight),
        ],
      ),
    );
  }

  List<String> _generateInsights() {
    final insights = <String>[];
    final now = DateTime.now();
    final analytics = MoodAnalytics(entries);

    // Analyze overall mood trend
    final startDate = selectedPeriod == 'Week'
        ? now.subtract(const Duration(days: 7))
        : selectedPeriod == 'Month'
            ? DateTime(now.year, now.month - 1, now.day)
            : DateTime(now.year, now.month - 3, now.day);

    final trend = analytics.calculateTrend(startDate, now);
    if (trend.abs() > 0.1) {
      insights.add(
        trend > 0
            ? 'Your mood has been improving over this $selectedPeriod.'
            : 'Your mood has been declining over this $selectedPeriod.',
      );
    } else {
      insights
          .add('Your mood has been relatively stable this $selectedPeriod.');
    }

    // Analyze correlations
    final correlations = analytics.getActivityMoodCorrelation();
    if (correlations.isNotEmpty) {
      final sortedActivities = correlations.entries
          .where((e) => e.key != null)
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (sortedActivities.isNotEmpty) {
        final topActivity = sortedActivities.first;
        insights.add(
          'Activities like "${topActivity.key}" seem to positively impact your mood.',
        );
      }
    }

    // Get most common tags
    final tagCounts = analytics.getTopTags(limit: 3);
    if (tagCounts.isNotEmpty) {
      insights.add(
        'Your most frequent activities this $selectedPeriod were: ${tagCounts.keys.join(", ")}.',
      );
    }

    // Analyze patterns by weekday
    final weekdayMoods = <int, List<double>>{};
    for (final entry in entries) {
      final weekday = entry.timestamp.weekday;
      weekdayMoods.putIfAbsent(weekday, () => []).add(entry.mood.value);
    }

    if (weekdayMoods.isNotEmpty) {
      var bestDay = weekdayMoods.entries.first;
      var worstDay = weekdayMoods.entries.first;

      for (final entry in weekdayMoods.entries) {
        final avgMood =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
        final bestAvg =
            bestDay.value.reduce((a, b) => a + b) / bestDay.value.length;
        final worstAvg =
            worstDay.value.reduce((a, b) => a + b) / worstDay.value.length;

        if (avgMood > bestAvg) {
          bestDay = entry;
        }
        if (avgMood < worstAvg) {
          worstDay = entry;
        }
      }

      final bestDayName = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ][bestDay.key - 1];
      insights.add('You tend to feel best on $bestDayName.');
    }

    return insights;
  }

  Widget _buildInsightItem(BuildContext context, String insight) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              insight,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
