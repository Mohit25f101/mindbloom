import 'dart:math' show Point;
import '../models/mood_emoji.dart';

class MoodEntry {
  final int id;
  final DateTime timestamp;
  final MoodEmoji mood;
  final List<String> tags;
  final String? notes;
  final String? location;

  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.mood,
    required this.tags,
    this.notes,
    this.location,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      mood: MoodEmoji.fromValue(json['moodValue'] as double),
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'moodValue': mood.value,
      'tags': tags,
      'notes': notes,
      'location': location,
    };
  }
}

class MoodAnalytics {
  final List<MoodEntry> entries;

  MoodAnalytics(this.entries);

  // Get average mood for a specific day
  double getDayAverage(DateTime date) {
    final dayEntries = entries.where((entry) =>
        entry.timestamp.year == date.year &&
        entry.timestamp.month == date.month &&
        entry.timestamp.day == date.day);

    if (dayEntries.isEmpty) return 0;

    return dayEntries.map((e) => e.mood.value).reduce((a, b) => a + b) /
        dayEntries.length;
  }

  // Get mood entries for a date range
  List<MoodEntry> getEntriesInRange(DateTime start, DateTime end) {
    return entries
        .where((entry) =>
            entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Calculate mood trend (positive or negative)
  double calculateTrend(DateTime start, DateTime end) {
    final rangeEntries = getEntriesInRange(start, end);
    if (rangeEntries.length < 2) return 0;

    final values = rangeEntries.map((e) => e.mood.value).toList();
    final x = List.generate(values.length, (i) => i.toDouble());

    return _linearRegression(x, values);
  }

  // Calculate moving average
  List<Point> calculateMovingAverage(DateTime start, DateTime end,
      {int window = 7}) {
    final rangeEntries = getEntriesInRange(start, end);
    if (rangeEntries.isEmpty) return [];

    final points = <Point>[];
    for (var i = 0; i < rangeEntries.length - window + 1; i++) {
      final windowEntries = rangeEntries.sublist(i, i + window);
      final average =
          windowEntries.map((e) => e.mood.value).reduce((a, b) => a + b) /
              window;
      points.add(Point(
        windowEntries[window ~/ 2].timestamp.millisecondsSinceEpoch.toDouble(),
        average,
      ));
    }
    return points;
  }

  // Most common tags
  Map<String, int> getTopTags({int limit = 5}) {
    final tagCount = <String, int>{};
    for (var entry in entries) {
      for (var tag in entry.tags) {
        tagCount[tag] = (tagCount[tag] ?? 0) + 1;
      }
    }

    final sortedTags = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(
        sortedTags.take(limit).map((e) => MapEntry(e.key, e.value)));
  }

  // Calculate correlation between activities and mood
  Map<String?, double> getActivityMoodCorrelation() {
    final activityStats = <String?, _ActivityStats>{};

    for (var entry in entries) {
      for (var tag in entry.tags) {
        if (!activityStats.containsKey(tag)) {
          activityStats[tag] = _ActivityStats();
        }
        activityStats[tag]!.addMood(entry.mood.value);
      }
    }

    return Map.fromEntries(
      activityStats.entries.map(
        (e) => MapEntry(e.key, e.value.getAverageMood()),
      ),
    );
  }

  // Helper method for linear regression
  double _linearRegression(List<double> x, List<double> y) {
    final n = x.length;
    if (n != y.length || n == 0) return 0;

    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((x) => x * x).reduce((a, b) => a + b);

    // Calculate slope (trend)
    return (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  }
}

class _ActivityStats {
  int count = 0;
  double sum = 0;

  void addMood(double value) {
    count++;
    sum += value;
  }

  double getAverageMood() {
    return count > 0 ? sum / count : 0;
  }
}
