import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickSuggestionsWidget extends StatelessWidget {
  final Function(String) onSuggestionTap;
  final bool isVisible;

  const QuickSuggestionsWidget({
    super.key,
    required this.onSuggestionTap,
    this.isVisible = true,
  });

  static const List<Map<String, dynamic>> _suggestions = [
    {
      'text': 'I\'m feeling anxious',
      'icon': 'psychology',
      'category': 'mood',
    },
    {
      'text': 'Help me relax',
      'icon': 'spa',
      'category': 'wellness',
    },
    {
      'text': 'Study tips',
      'icon': 'school',
      'category': 'academic',
    },
    {
      'text': 'I can\'t sleep',
      'icon': 'bedtime',
      'category': 'sleep',
    },
    {
      'text': 'Breathing exercise',
      'icon': 'air',
      'category': 'wellness',
    },
    {
      'text': 'I\'m stressed',
      'icon': 'sentiment_stressed',
      'category': 'mood',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isVisible) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick suggestions',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _suggestions.map((suggestion) {
              return _buildSuggestionChip(
                context,
                suggestion['text'] as String,
                suggestion['icon'] as String,
                _getCategoryColor(theme, suggestion['category'] as String),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(
    BuildContext context,
    String text,
    String iconName,
    Color categoryColor,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onSuggestionTap(text),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.5.h,
        ),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: categoryColor,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(ThemeData theme, String category) {
    switch (category) {
      case 'mood':
        return theme.colorScheme.primary;
      case 'wellness':
        return theme.colorScheme.tertiary;
      case 'academic':
        return theme.colorScheme.secondary;
      case 'sleep':
        return const Color(0xFF6B46C1); // Purple
      default:
        return theme.colorScheme.primary;
    }
  }
}
