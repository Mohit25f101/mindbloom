import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MindguardLogoWidget extends StatelessWidget {
  const MindguardLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 15.h,
          semanticLabel: 'MindGuard Logo',
        ),
        SizedBox(height: 2.h),
        Text(
          'MindGuard',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
