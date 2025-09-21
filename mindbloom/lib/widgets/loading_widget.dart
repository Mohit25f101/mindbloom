import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool overlay;

  const LoadingWidget({
    Key? key,
    this.message,
    this.overlay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingWidget = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (overlay) {
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: loadingWidget,
      );
    }

    return loadingWidget;
  }
}

/// A page widget that shows a loading indicator while initializing
class LoadingPage extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingMessage;

  const LoadingPage({
    Key? key,
    required this.isLoading,
    required this.child,
    this.loadingMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          LoadingWidget(
            message: loadingMessage,
            overlay: true,
          ),
      ],
    );
  }
}
