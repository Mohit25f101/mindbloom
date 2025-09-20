import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../models/mood_emoji.dart';

class MoodSelectionWidget extends StatefulWidget {
  final void Function(MoodEmoji) onMoodSelected;
  final MoodEmoji? initialMood;
  final bool showDescription;

  const MoodSelectionWidget({
    super.key,
    required this.onMoodSelected,
    this.initialMood,
    this.showDescription = true,
  });

  @override
  State<MoodSelectionWidget> createState() => _MoodSelectionWidgetState();
}

class _MoodSelectionWidgetState extends State<MoodSelectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  MoodEmoji? _selectedMood;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleMoodTap(MoodEmoji mood) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedMood = mood;
      _isAnimating = true;
    });

    _controller.forward(from: 0).then((_) {
      setState(() {
        _isAnimating = false;
      });
    });

    widget.onMoodSelected(mood);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mood Selection Row
        Container(
          height: 12.h,
          margin: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: MoodEmoji.all.map((mood) {
              final isSelected = _selectedMood == mood;
              final scale = isSelected && _isAnimating
                  ? Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOutBack,
                    ))
                  : null;

              return GestureDetector(
                onTap: () => _handleMoodTap(mood),
                child: AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? mood.color.withOpacity(0.2)
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? mood.color
                            : colorScheme.outline.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: mood.color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: ScaleTransition(
                      scale: scale ?? const AlwaysStoppedAnimation(1.0),
                      child: Center(
                        child: Text(
                          mood.emoji,
                          style: TextStyle(fontSize: 7.w),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Mood Description
        if (widget.showDescription && _selectedMood != null) ...[
          SizedBox(height: 2.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Column(
              key: ValueKey(_selectedMood),
              children: [
                Text(
                  _selectedMood!.label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: _selectedMood!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _selectedMood!.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
