import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterOptionsWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterOptionsWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 80.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Filter Options',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMoodRangeFilter(colorScheme, theme),
                  SizedBox(height: 3.h),
                  _buildActivitiesFilter(colorScheme, theme),
                  SizedBox(height: 3.h),
                  _buildTriggersFilter(colorScheme, theme),
                  SizedBox(height: 3.h),
                  _buildDateRangeFilter(colorScheme, theme),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersChanged(_filters);
                Navigator.pop(context);
              },
              child: Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodRangeFilter(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              RangeSlider(
                values: RangeValues(
                  (_filters['minMood'] as num?)?.toDouble() ?? 1.0,
                  (_filters['maxMood'] as num?)?.toDouble() ?? 5.0,
                ),
                min: 1.0,
                max: 5.0,
                divisions: 4,
                labels: RangeLabels(
                  _getMoodLabel((_filters['minMood'] as num?)?.toInt() ?? 1),
                  _getMoodLabel((_filters['maxMood'] as num?)?.toInt() ?? 5),
                ),
                onChanged: (values) {
                  setState(() {
                    _filters['minMood'] = values.start.toInt();
                    _filters['maxMood'] = values.end.toInt();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Very Low',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    'Great',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesFilter(ColorScheme colorScheme, ThemeData theme) {
    final activities = [
      'Study',
      'Exercise',
      'Social',
      'Work',
      'Sleep',
      'Meditation',
      'Entertainment',
      'Family Time',
      'Hobbies',
      'Travel'
    ];

    final selectedActivities =
        (_filters['activities'] as List?)?.cast<String>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activities',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: activities.map((activity) {
            final isSelected = selectedActivities.contains(activity);
            return FilterChip(
              label: Text(activity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedActivities.add(activity);
                  } else {
                    selectedActivities.remove(activity);
                  }
                  _filters['activities'] = selectedActivities;
                });
              },
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontSize: 12.sp,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTriggersFilter(ColorScheme colorScheme, ThemeData theme) {
    final triggers = [
      'Exams',
      'Deadlines',
      'Social Events',
      'Family Issues',
      'Health',
      'Financial Stress',
      'Relationship',
      'Academic Pressure',
      'Weather'
    ];

    final selectedTriggers =
        (_filters['triggers'] as List?)?.cast<String>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stress Triggers',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: triggers.map((trigger) {
            final isSelected = selectedTriggers.contains(trigger);
            return FilterChip(
              label: Text(trigger),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTriggers.add(trigger);
                  } else {
                    selectedTriggers.remove(trigger);
                  }
                  _filters['triggers'] = selectedTriggers;
                });
              },
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.errorContainer,
              checkmarkColor: colorScheme.error,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onErrorContainer
                    : colorScheme.onSurface,
                fontSize: 12.sp,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Date Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'From',
                _filters['startDate'] as DateTime?,
                (date) => setState(() => _filters['startDate'] = date),
                colorScheme,
                theme,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildDateField(
                'To',
                _filters['endDate'] as DateTime?,
                (date) => setState(() => _filters['endDate'] = date),
                colorScheme,
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime?) onChanged,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onChanged(selectedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  date != null
                      ? '${date.month}/${date.day}/${date.year}'
                      : 'Select date',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: date != null
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'minMood': 1,
        'maxMood': 5,
        'activities': <String>[],
        'triggers': <String>[],
        'startDate': null,
        'endDate': null,
      };
    });
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
        return '';
    }
  }
}
