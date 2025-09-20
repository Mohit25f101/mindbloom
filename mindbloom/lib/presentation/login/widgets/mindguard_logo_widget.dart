import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class MindguardLogoWidget extends StatelessWidget {
  const MindguardLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/img_app_logo.svg',
          height: 15.h,
          semanticsLabel: 'MindGuard Logo',
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
