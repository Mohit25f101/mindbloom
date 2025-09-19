import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BreathingExerciseCard extends StatefulWidget {
  final VoidCallback? onStart;

  const BreathingExerciseCard({
    super.key,
    this.onStart,
  });

  @override
  State<BreathingExerciseCard> createState() => _BreathingExerciseCardState();
}

class _BreathingExerciseCardState extends State<BreathingExerciseCard>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  bool _isBreathing = false;
  String _breathingPhase = "Tap to start breathing exercise";

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() => _breathingPhase = "Breathe in slowly...");
      } else if (status == AnimationStatus.reverse) {
        setState(() => _breathingPhase = "Breathe out slowly...");
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  void _toggleBreathing() {
    if (_isBreathing) {
      _breathingController.stop();
      setState(() {
        _isBreathing = false;
        _breathingPhase = "Tap to start breathing exercise";
      });
    } else {
      setState(() => _isBreathing = true);
      _breathingController.repeat(reverse: true);
      widget.onStart?.call();
    }
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
                  color: colorScheme.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'air',
                    color: colorScheme.tertiary,
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
                      "Breathing Exercise",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "4-7-8 technique for immediate calm",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Breathing Circle
          GestureDetector(
            onTap: _toggleBreathing,
            child: AnimatedBuilder(
              animation: _breathingAnimation,
              builder: (context, child) {
                return Container(
                  width: 40.w * _breathingAnimation.value,
                  height: 40.w * _breathingAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.tertiary.withValues(alpha: 0.3),
                        colorScheme.tertiary.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                    border: Border.all(
                      color: colorScheme.tertiary,
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _isBreathing ? 'pause' : 'play_arrow',
                      color: colorScheme.tertiary,
                      size: 8.w,
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Breathing Phase Text
          Text(
            _breathingPhase,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          if (!_isBreathing) ...[
            SizedBox(height: 1.h),
            Text(
              "Inhale for 4, hold for 7, exhale for 8",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
