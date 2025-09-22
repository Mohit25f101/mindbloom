import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> quickActions = [
      {
        "title": "Breathing Exercise",
        "subtitle": "5 min guided session",
        "icon": "air",
        "color": AppTheme.primaryLight,
        "route": "/breathing-exercise",
      },
      {
        "title": "Journal Entry",
        "subtitle": "Express your thoughts",
        "icon": "edit_note",
        "color": AppTheme.secondaryLight,
        "route": "/journal",
      },
      {
        "title": "AI Companion",
        "subtitle": "Chat for support",
        "icon": "psychology",
        "color": AppTheme.successLight,
        "route": "/ai-companion-chat",
      },
      {
        "title": "Meditation",
        "subtitle": "10 min mindfulness",
        "icon": "self_improvement",
        "color": AppTheme.warningLight,
        "route": "/meditation",
      },
    ];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1.2,
              ),
              itemCount: quickActions.length,
              itemBuilder: (context, index) {
                final action = quickActions[index];
                return GestureDetector(
                  onTap: () {
                    if (action["route"] != null) {
                      Navigator.pushNamed(context, action["route"]);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: (action["color"] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            (action["color"] as Color).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: action["color"],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: action["icon"],
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Text(
                          action["title"],
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: action["color"],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          action["subtitle"],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
