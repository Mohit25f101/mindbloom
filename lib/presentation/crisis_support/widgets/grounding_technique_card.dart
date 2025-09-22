import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GroundingTechniqueCard extends StatefulWidget {
  final VoidCallback? onStart;

  const GroundingTechniqueCard({
    super.key,
    this.onStart,
  });

  @override
  State<GroundingTechniqueCard> createState() => _GroundingTechniqueCardState();
}

class _GroundingTechniqueCardState extends State<GroundingTechniqueCard> {
  bool _isExpanded = false;
  int _currentStep = 0;

  final List<Map<String, dynamic>> _groundingSteps = [
    {
      "title": "5 things you can see",
      "description": "Look around and name 5 things you can see",
      "icon": "visibility",
    },
    {
      "title": "4 things you can touch",
      "description": "Feel and name 4 things you can touch",
      "icon": "touch_app",
    },
    {
      "title": "3 things you can hear",
      "description": "Listen and name 3 things you can hear",
      "icon": "hearing",
    },
    {
      "title": "2 things you can smell",
      "description": "Notice and name 2 things you can smell",
      "icon": "air",
    },
    {
      "title": "1 thing you can taste",
      "description": "Focus on 1 thing you can taste",
      "icon": "restaurant",
    },
  ];

  void _nextStep() {
    if (_currentStep < _groundingSteps.length - 1) {
      setState(() => _currentStep++);
    } else {
      setState(() {
        _currentStep = 0;
        _isExpanded = false;
      });
    }
  }

  void _startGrounding() {
    setState(() {
      _isExpanded = true;
      _currentStep = 0;
    });
    widget.onStart?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: colorScheme.secondary,
                    size: 5.w,
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "5-4-3-2-1 Grounding",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "Focus on your senses to stay present",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Expand/Collapse Button
              IconButton(
                onPressed: () {
                  if (_isExpanded) {
                    setState(() {
                      _isExpanded = false;
                      _currentStep = 0;
                    });
                  } else {
                    _startGrounding();
                  }
                },
                icon: CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 6.w,
                ),
              ),
            ],
          ),

          // Expanded Content
          if (_isExpanded) ...[
            SizedBox(height: 2.h),

            // Progress Indicator
            Row(
              children: List.generate(_groundingSteps.length, (index) {
                return Expanded(
                  child: Container(
                    height: 4.0,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? colorScheme.secondary
                          : colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 3.h),

            // Current Step
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: colorScheme.secondary.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  // Step Icon
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName:
                            _groundingSteps[_currentStep]["icon"] as String,
                        color: colorScheme.secondary,
                        size: 8.w,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Step Title
                  Text(
                    _groundingSteps[_currentStep]["title"] as String,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  // Step Description
                  Text(
                    _groundingSteps[_currentStep]["description"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 3.h),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        _currentStep < _groundingSteps.length - 1
                            ? "Next Step"
                            : "Complete",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
