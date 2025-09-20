import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class InsightsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> moodEntries;
  final String selectedPeriod;

  const InsightsWidget({
    super.key,
    required this.moodEntries,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (moodEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    final insights = _generateInsights();
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
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
                'Insights',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...insights.map((insight) => _buildInsightItem(context, insight)),
        ],
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, Map<String, String> insight) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title']!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  insight['description']!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _generateInsights() {
    List<Map<String, String>> insights = [];

    // Calculate average mood
    if (moodEntries.isEmpty) return insights;

    final averageMood =
        moodEntries.map((e) => e['rating'] as int).reduce((a, b) => a + b) /
            moodEntries.length;

    // Check for mood trend
    if (moodEntries.length >= 2) {
      final recentMoods =
          moodEntries.take(7).map((e) => e['rating'] as int).toList();
      final previousMoods =
          moodEntries.skip(7).take(7).map((e) => e['rating'] as int).toList();

      if (recentMoods.isNotEmpty && previousMoods.isNotEmpty) {
        final recentAvg =
            recentMoods.reduce((a, b) => a + b) / recentMoods.length;
        final previousAvg =
            previousMoods.reduce((a, b) => a + b) / previousMoods.length;

        if (recentAvg > previousAvg + 0.5) {
          insights.add({
            'title': 'Improving Trend',
            'description':
                'Your mood has been trending upward recently. Keep up the positive momentum!',
          });
        } else if (previousAvg > recentAvg + 0.5) {
          insights.add({
            'title': 'Declining Trend',
            'description':
                'Your mood has been lower recently. Consider reaching out for support or trying stress-reducing activities.',
          });
        }
      }
    }

    // Analyze day of week patterns
    Map<int, double> dayAverages = {};
    Map<int, int> dayCounts = {};

    for (final entry in moodEntries) {
      final dayOfWeek = DateTime.parse(entry['date'] as String).weekday;
      final rating = entry['rating'] as int;

      dayAverages[dayOfWeek] = (dayAverages[dayOfWeek] ?? 0) + rating;
      dayCounts[dayOfWeek] = (dayCounts[dayOfWeek] ?? 0) + 1;
    }

    dayAverages.forEach((day, total) {
      dayAverages[day] = total / dayCounts[day]!;
    });

    if (dayAverages.isNotEmpty) {
      final bestDay =
          dayAverages.entries.reduce((a, b) => a.value > b.value ? a : b);
      final worstDay =
          dayAverages.entries.reduce((a, b) => a.value < b.value ? a : b);

      final dayNames = {
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday',
        7: 'Sunday'
      };

      if (bestDay.key > 5 && worstDay.key <= 5) {
        insights.add({
          'title': 'Weekend Boost',
          'description':
              'Your mood tends to improve on weekends. Consider incorporating more relaxing activities during weekdays.',
        });
      } else if (worstDay.key <= 5) {
        insights.add({
          'title': 'Weekday Stress',
          'description':
              '${dayNames[worstDay.key]}s seem challenging for you. Try planning something enjoyable for these days.',
        });
      }
    }

    // Overall mood assessment
    if (averageMood > 4.0) {
      insights.add({
        'title': 'Great Mental Health',
        'description':
            'You\'ve been maintaining excellent mental well-being. Your positive outlook is inspiring!',
      });
    } else if (averageMood > 3.0) {
      insights.add({
        'title': 'Stable Mood',
        'description':
            'Your mood has been relatively stable. Consider activities that could boost your happiness further.',
      });
    } else {
      insights.add({
        'title': 'Challenging Period',
        'description':
            'You\'ve been going through a tough time. Remember that it\'s okay to seek support when needed.',
      });
    }

    return insights;
  }
}
