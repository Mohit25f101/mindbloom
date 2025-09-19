import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MoodChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> moodData;
  final String selectedPeriod;
  final Function(int) onDataPointTap;

  const MoodChartWidget({
    super.key,
    required this.moodData,
    required this.selectedPeriod,
    required this.onDataPointTap,
  });

  @override
  State<MoodChartWidget> createState() => _MoodChartWidgetState();
}

class _MoodChartWidgetState extends State<MoodChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 35.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Trends',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: widget.moodData.isEmpty
                ? _buildEmptyState(colorScheme)
                : _buildChart(colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'mood',
            color: colorScheme.outline,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No mood data available',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start tracking your mood to see trends',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ColorScheme colorScheme) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colorScheme.outline.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < widget.moodData.length) {
                  final data = widget.moodData[value.toInt()];
                  final date = DateTime.parse(data['date'] as String);
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _formatDateLabel(date),
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  _getMoodLabel(value.toInt()),
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 10.sp,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        minX: 0,
        maxX: (widget.moodData.length - 1).toDouble(),
        minY: 1,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: widget.moodData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                (entry.value['rating'] as num).toDouble(),
              );
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.8),
                colorScheme.primary,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: touchedIndex == index ? 6 : 4,
                  color: colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.2),
                  colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            setState(() {
              if (touchResponse != null && touchResponse.lineBarSpots != null) {
                touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
                widget.onDataPointTap(touchedIndex);
              } else {
                touchedIndex = -1;
              }
            });
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: colorScheme.inverseSurface,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final dataIndex = flSpot.x.toInt();
                if (dataIndex >= 0 && dataIndex < widget.moodData.length) {
                  final data = widget.moodData[dataIndex];
                  final date = DateTime.parse(data['date'] as String);
                  return LineTooltipItem(
                    '${_getMoodLabel(flSpot.y.toInt())}\n${_formatTooltipDate(date)}',
                    TextStyle(
                      color: colorScheme.onInverseSurface,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  String _formatDateLabel(DateTime date) {
    switch (widget.selectedPeriod) {
      case 'Week':
        return [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat'
        ][date.weekday % 7];
      case 'Month':
        return '${date.day}';
      case '3 Months':
        return '${date.month}/${date.day}';
      case 'Year':
        return [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ][date.month - 1];
      default:
        return '${date.day}';
    }
  }

  String _formatTooltipDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _getMoodLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Neutral';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return '';
    }
  }
}