import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MoodNotesWidget extends StatefulWidget {
  final String notes;
  final Function(String) onNotesChanged;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const MoodNotesWidget({
    super.key,
    required this.notes,
    required this.onNotesChanged,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  @override
  State<MoodNotesWidget> createState() => _MoodNotesWidgetState();
}

class _MoodNotesWidgetState extends State<MoodNotesWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onToggleExpanded,
          child: Row(
            children: [
              Text(
                "How are you feeling?",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              AnimatedRotation(
                turns: widget.isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: widget.isExpanded ? null : 0,
          child: widget.isExpanded
              ? Column(
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        onChanged: widget.onNotesChanged,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Share what's on your mind... (optional)",
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(4.w),
                        ),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          size: 16,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            "AI sentiment analysis will help track your emotional patterns",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
