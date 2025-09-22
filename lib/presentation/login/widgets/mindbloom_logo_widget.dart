import 'package:flutter/material.dart';

class MindbloomLogoWidget extends StatelessWidget {
  const MindbloomLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 80,
          height: 80,
          semanticLabel: 'Mindbloom Logo',
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
