import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class InsightsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> moodData;
  final String selectedPeriod;

  const InsightsWidget({
    super.key,
    required this.moodData,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (moodData.isEmpty) {
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...insights.map((insight) => _buildInsightItem(
                context,
                insight,
                colorScheme,
                theme,
              )),
          SizedBox(height: 2.h),
          _buildRecommendations(context, colorScheme, theme),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    Map<String, dynamic> insight,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  insight['description'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
                if (insight['trend'] != null) ...[
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: insight['trend'] == 'up'
                            ? 'trending_up'
                            : 'trending_down',
                        color: insight['trend'] == 'up'
                            ? Colors.green
                            : Colors.orange,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        insight['trendText'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: insight['trend'] == 'up'
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final recommendations = _getRecommendations();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        ...recommendations.map((rec) => Container(
              margin: EdgeInsets.only(bottom: 1.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: rec['icon'] as String,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      rec['text'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  List<Map<String, dynamic>> _generateInsights() {
    final insights = <Map<String, dynamic>>[];

    // Calculate average mood
    final avgMood =
        moodData.map((e) => e['rating'] as int).reduce((a, b) => a + b) /
            moodData.length;

    // Mood trend analysis
    if (moodData.length >= 2) {
      final recentMoods =
          moodData.take(7).map((e) => e['rating'] as int).toList();
      final olderMoods =
          moodData.skip(7).take(7).map((e) => e['rating'] as int).toList();

      if (olderMoods.isNotEmpty) {
        final recentAvg =
            recentMoods.reduce((a, b) => a + b) / recentMoods.length;
        final olderAvg = olderMoods.reduce((a, b) => a + b) / olderMoods.length;

        if (recentAvg > olderAvg) {
          insights.add({
            'title': 'Improving Trend',
            'description':
                'Your mood has been trending upward recently. Keep up the positive momentum!',
            'trend': 'up',
            'trendText':
                '+${((recentAvg - olderAvg) * 20).toStringAsFixed(0)}% improvement',
          });
        } else if (recentAvg < olderAvg) {
          insights.add({
            'title': 'Declining Trend',
            'description':
                'Your mood has been lower recently. Consider reaching out for support or trying stress-relief activities.',
            'trend': 'down',
            'trendText':
                '${((recentAvg - olderAvg) * 20).toStringAsFixed(0)}% decline',
          });
        }
      }
    }

    // Weekly pattern analysis
    final weekdayMoods = <int, List<int>>{};
    for (final entry in moodData) {
      final date = DateTime.parse(entry['date'] as String);
      final weekday = date.weekday;
      weekdayMoods.putIfAbsent(weekday, () => []).add(entry['rating'] as int);
    }

    if (weekdayMoods.isNotEmpty) {
      final weekdayAvgs = weekdayMoods.map((day, moods) =>
          MapEntry(day, moods.reduce((a, b) => a + b) / moods.length));

      final bestDay =
          weekdayAvgs.entries.reduce((a, b) => a.value > b.value ? a : b);
      final worstDay =
          weekdayAvgs.entries.reduce((a, b) => a.value < b.value ? a : b);

      final dayNames = [
        '',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];

      if (bestDay.key == 6 || bestDay.key == 7) {
        // Weekend
        insights.add({
          'title': 'Weekend Boost',
          'description':
              'Your mood tends to improve on weekends. Consider incorporating more relaxing activities during weekdays.',
        });
      }

      if (worstDay.key >= 1 && worstDay.key <= 5) {
        // Weekday
        insights.add({
          'title': 'Weekday Stress',
          'description':
              '${dayNames[worstDay.key]}s seem challenging for you. Try planning something enjoyable for these days.',
        });
      }
    }

    // Overall mood assessment
    if (avgMood >= 4.0) {
      insights.add({
        'title': 'Great Mental Health',
        'description':
            'You\'ve been maintaining excellent mental well-being. Your positive outlook is inspiring!',
      });
    } else if (avgMood >= 3.0) {
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

  List<Map<String, dynamic>> _getRecommendations() {
    final avgMood =
        moodData.map((e) => e['rating'] as int).reduce((a, b) => a + b) /
            moodData.length;

    if (avgMood >= 4.0) {
      return [
        {
          'icon': 'self_improvement',
          'text': 'Continue your current wellness routine'
        },
        {'icon': 'share', 'text': 'Share your positive energy with others'},
        {
          'icon': 'book',
          'text': 'Consider journaling about what\'s working well'
        },
      ];
    } else if (avgMood >= 3.0) {
      return [
        {
          'icon': 'fitness_center',
          'text': 'Try adding 15 minutes of exercise to your day'
        },
        {'icon': 'nature', 'text': 'Spend more time outdoors in nature'},
        {'icon': 'people', 'text': 'Connect with friends and family regularly'},
      ];
    } else {
      return [
        {'icon': 'psychology', 'text': 'Consider speaking with a counselor'},
        {'icon': 'spa', 'text': 'Practice relaxation techniques daily'},
        {'icon': 'phone', 'text': 'Reach out to your support network'},
      ];
    }
  }
}
