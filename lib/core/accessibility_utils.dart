// Utility functions for accessibility features
import 'package:flutter/material.dart';

class AccessibilityUtils {
  // Add semantic labels to widgets
  static Widget addSemanticLabel(Widget child, String label) {
    return Semantics(
      label: label,
      child: child,
    );
  }

  // Add semantic buttons
  static Widget addSemanticButton(
      Widget child, VoidCallback onTap, String label) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  // Add heading level semantics
  static Widget addHeading(Widget child, {int level = 1}) {
    return Semantics(
      header: true,
      container: true,
      child: child,
    );
  }

  // Add value semantics (for progress indicators, sliders, etc.)
  static Widget addValue(Widget child, String value) {
    return Semantics(
      value: value,
      child: child,
    );
  }

  // Add live region for dynamic content
  static Widget addLiveRegion(Widget child) {
    return Semantics(
      liveRegion: true,
      child: child,
    );
  }
}
