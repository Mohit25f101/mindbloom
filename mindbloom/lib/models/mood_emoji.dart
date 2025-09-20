import 'package:flutter/material.dart';

class MoodEmoji {
  final String emoji;
  final String label;
  final String description;
  final Color color;
  final double value;

  const MoodEmoji({
    required this.emoji,
    required this.label,
    required this.description,
    required this.color,
    required this.value,
  });

  static const terrible = MoodEmoji(
    emoji: '😢',
    label: 'Terrible',
    description: 'I\'m feeling really down',
    color: Color(0xFFE53935),
    value: 1.0,
  );

  static const bad = MoodEmoji(
    emoji: '😕',
    label: 'Not Good',
    description: 'I\'m feeling a bit low',
    color: Color(0xFFEF7A2C),
    value: 2.0,
  );

  static const okay = MoodEmoji(
    emoji: '😐',
    label: 'Okay',
    description: 'I\'m feeling neutral',
    color: Color(0xFFFDB913),
    value: 3.0,
  );

  static const good = MoodEmoji(
    emoji: '😊',
    label: 'Good',
    description: 'I\'m feeling pretty good',
    color: Color(0xFF7CB342),
    value: 4.0,
  );

  static const great = MoodEmoji(
    emoji: '😃',
    label: 'Great',
    description: 'I\'m feeling fantastic',
    color: Color(0xFF43A047),
    value: 5.0,
  );

  static const List<MoodEmoji> all = [
    terrible,
    bad,
    okay,
    good,
    great,
  ];

  static MoodEmoji fromValue(double value) {
    final index = ((value - 1) / 1).round().clamp(0, all.length - 1);
    return all[index];
  }
}
