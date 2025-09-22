import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/mood_analytics.dart';
import '../../../models/mood_emoji.dart';

class MoodTrendGraph extends StatefulWidget {
  final List<MoodEntry> entries;
  final DateTime startDate;
  final DateTime endDate;
  final bool showMovingAverage;

  const MoodTrendGraph({
    super.key,
    required this.entries,
    required this.startDate,
    required this.endDate,
    this.showMovingAverage = true,
  });

  @override
  State<MoodTrendGraph> createState() => _MoodTrendGraphState();
}

class _MoodTrendGraphState extends State<MoodTrendGraph> {
  late MoodAnalytics _analytics;
  List<FlSpot> _spots = [];
  List<FlSpot> _trendSpots = [];

  @override
  void initState() {
    super.initState();
    _analytics = MoodAnalytics(widget.entries);
    _updateData();
  }

  @override
  void didUpdateWidget(MoodTrendGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _analytics = MoodAnalytics(widget.entries);
      _updateData();
    }
  }

  void _updateData() {
    final entries =
        _analytics.getEntriesInRange(widget.startDate, widget.endDate);

    // Create mood data points
    _spots = entries.map((entry) {
      return FlSpot(
        entry.timestamp.millisecondsSinceEpoch.toDouble(),
        entry.mood.value,
      );
    }).toList();

    // Calculate moving average if enabled
    if (widget.showMovingAverage) {
      final maPoints = _analytics.calculateMovingAverage(
        widget.startDate,
        widget.endDate,
      );
      _trendSpots = maPoints.map((point) {
        return FlSpot(point.x.toDouble(), point.y.toDouble());
      }).toList();
    }
  }

  String _getTooltipText(LineBarSpot spot) {
    final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
    final mood = MoodEmoji.fromValue(spot.y);
    return '${mood.emoji} ${mood.toString()}\n${_formatDate(date)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => colorScheme.surfaceContainerHighest
                    .withValues(alpha: 204), // 0.8 * 255 = 204
                tooltipBorder: const BorderSide(color: Colors.transparent),
                tooltipBorderRadius: const BorderRadius.all(Radius.circular(8)),
                tooltipPadding: const EdgeInsets.all(8),
                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    return LineTooltipItem(
                      _getTooltipText(spot),
                      TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value % 1 != 0) return const Text('');
                    final mood = MoodEmoji.fromValue(value);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        mood.emoji,
                        style: TextStyle(fontSize: 3.w),
                      ),
                    );
                  },
                  reservedSize: 8.w,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    if (date.hour != 0) return const Text('');
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${date.day}/${date.month}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface
                              .withValues(alpha: 179), // 0.7 * 255 = 179
                        ),
                      ),
                    );
                  },
                  reservedSize: 5.h,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: widget.startDate.millisecondsSinceEpoch.toDouble(),
            maxX: widget.endDate.millisecondsSinceEpoch.toDouble(),
            minY: 1,
            maxY: 5,
            lineBarsData: [
              // Mood points
              LineChartBarData(
                spots: _spots,
                isCurved: true,
                color: colorScheme.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: colorScheme.primary,
                      strokeWidth: 2,
                      strokeColor: colorScheme.surface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: colorScheme.primary
                      .withValues(alpha: 26), // 0.1 * 255 = 26
                ),
              ),
              // Trend line
              if (widget.showMovingAverage)
                LineChartBarData(
                  spots: _trendSpots,
                  isCurved: true,
                  color: colorScheme.secondary,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  dashArray: [5, 5],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
