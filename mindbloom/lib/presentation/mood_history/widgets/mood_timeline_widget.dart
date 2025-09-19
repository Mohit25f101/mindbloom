import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MoodTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> moodEntries;
  final Function(int) onEditEntry;
  final Function(int) onDeleteEntry;

  const MoodTimelineWidget({
    super.key,
    required this.moodEntries,
    required this.onEditEntry,
    required this.onDeleteEntry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (moodEntries.isEmpty) {
      return _buildEmptyState(colorScheme, theme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Recent Entries',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: moodEntries.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final entry = moodEntries[index];
            return _buildTimelineCard(
                context, entry, index, colorScheme, theme);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: colorScheme.outline,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No mood entries yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start logging your mood to build your history',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(
    BuildContext context,
    Map<String, dynamic> entry,
    int index,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final date = DateTime.parse(entry['date'] as String);
    final rating = entry['rating'] as int;
    final notes = entry['notes'] as String? ?? '';
    final activities = (entry['activities'] as List?)?.cast<String>() ?? [];

    return Dismissible(
      key: Key('mood_entry_$index'),
      background: _buildSwipeBackground(colorScheme, true),
      secondaryBackground: _buildSwipeBackground(colorScheme, false),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDeleteEntry(index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Mood entry deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Undo functionality would be implemented here
                },
              ),
            ),
          );
        } else {
          onEditEntry(index);
        }
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getMoodColor(rating, colorScheme)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomIconWidget(
                    iconName: _getMoodIcon(rating),
                    color: _getMoodColor(rating, colorScheme),
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMoodLabel(rating),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getMoodColor(rating, colorScheme),
                        ),
                      ),
                      Text(
                        _formatDate(date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getMoodColor(rating, colorScheme)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '$rating/5',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getMoodColor(rating, colorScheme),
                    ),
                  ),
                ),
              ],
            ),
            if (notes.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                notes,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (activities.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: activities.take(3).map((activity) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      activity,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (activities.length > 3) ...[
                SizedBox(height: 1.h),
                Text(
                  '+${activities.length - 3} more activities',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(ColorScheme colorScheme, bool isEdit) {
    return Container(
      alignment: isEdit ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: isEdit ? colorScheme.primary : colorScheme.error,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isEdit ? 'edit' : 'delete',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isEdit ? 'Edit' : 'Delete',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference < 7) {
      final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      return '${weekdays[date.weekday % 7]} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _getMoodLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Neutral';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return 'Unknown';
    }
  }

  String _getMoodIcon(int rating) {
    switch (rating) {
      case 1:
        return 'sentiment_very_dissatisfied';
      case 2:
        return 'sentiment_dissatisfied';
      case 3:
        return 'sentiment_neutral';
      case 4:
        return 'sentiment_satisfied';
      case 5:
        return 'sentiment_very_satisfied';
      default:
        return 'sentiment_neutral';
    }
  }

  Color _getMoodColor(int rating, ColorScheme colorScheme) {
    switch (rating) {
      case 1:
        return colorScheme.error;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return colorScheme.primary;
    }
  }
}
