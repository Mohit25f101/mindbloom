import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MindbloomLogoWidget extends StatelessWidget {
  const MindbloomLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/img_app_logo.svg',
          width: 80,
          height: 80,
          semanticsLabel: 'Mindbloom Logo',
        ),
        Text(
          'Mindbloom',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
