import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../models/mood_emoji.dart';
import '../../models/mood_analytics.dart';
import './widgets/filter_options_widget.dart';
import './widgets/insights_widget_new.dart';

import './widgets/mood_trend_graph.dart';
import './widgets/mood_entry_timeline.dart';
import './widgets/time_period_selector_widget.dart';

class MoodHistory extends StatefulWidget {
  const MoodHistory({super.key});

  @override
  State<MoodHistory> createState() => _MoodHistoryState();
}

class _MoodHistoryState extends State<MoodHistory> {
  String _selectedPeriod = 'Week';
  bool _isLoading = false;
  Map<String, dynamic> _currentFilters = {
    'minMood': 1,
    'maxMood': 5,
    'activities': <String>[],
    'triggers': <String>[],
    'startDate': null,
    'endDate': null,
  };

  // Mock data for mood history
  final List<MoodEntry> _allMoodData = [
    MoodEntry(
      id: 1,
      timestamp: DateTime.parse("2025-01-15T10:30:00.000Z"),
      mood: MoodEmoji.good,
      notes:
          "Had a great morning workout and felt energized for classes. The weather was perfect for a walk between lectures.",
      tags: ["Exercise", "Study", "Social"],
      location: "Campus Gym",
    ),
    MoodEntry(
      id: 2,
      timestamp: DateTime.parse("2025-01-14T16:45:00.000Z"),
      mood: MoodEmoji.okay,
      notes:
          "Neutral day overall. Completed assignments but felt a bit overwhelmed with upcoming deadlines.",
      tags: ["Study", "Work", "Deadlines"],
      location: "Library",
    ),
    MoodEntry(
      id: 3,
      timestamp: DateTime.parse("2025-01-13T20:15:00.000Z"),
      mood: MoodEmoji.great,
      notes:
          "Amazing day! Aced my presentation and celebrated with friends. Feeling confident and happy.",
      tags: ["Study", "Social", "Entertainment"],
      location: "Student Center",
    ),
    MoodEntry(
      id: 4,
      timestamp: DateTime.parse("2025-01-12T14:20:00.000Z"),
      mood: MoodEmoji.bad,
      notes:
          "Stressful day with back-to-back exams. Didn't sleep well last night and it showed in my performance.",
      tags: ["Study", "Exams", "Sleep"],
      location: "Exam Hall",
    ),
    MoodEntry(
      id: 5,
      timestamp: DateTime.parse("2025-01-11T11:00:00.000Z"),
      mood: MoodEmoji.good,
      notes:
          "Good study session with friends. We helped each other understand difficult concepts.",
      tags: ["Study", "Social"],
      location: "Study Room",
    ),
    MoodEntry(
      id: 6,
      timestamp: DateTime.parse("2025-01-10T18:30:00.000Z"),
      mood: MoodEmoji.okay,
      notes:
          "Regular day. Attended all classes and did some light exercise. Nothing particularly exciting.",
      tags: ["Study", "Exercise"],
      location: "Campus",
    ),
    MoodEntry(
      id: 7,
      timestamp: DateTime.parse("2025-01-09T09:45:00.000Z"),
      mood: MoodEmoji.terrible,
      notes:
          "Very difficult day. Received disappointing grade on important project. Feeling discouraged about academic progress.",
      tags: ["Study", "Academic Pressure", "Grades"],
      location: "Professor's Office",
    ),
    MoodEntry(
      id: 8,
      timestamp: DateTime.parse("2025-01-08T15:10:00.000Z"),
      mood: MoodEmoji.good,
      notes:
          "Productive day working on group project. Team collaboration went smoothly and we made good progress.",
      tags: ["Study", "Social", "Work"],
      location: "Group Study Area",
    ),
    MoodEntry(
      id: 9,
      timestamp: DateTime.parse("2025-01-07T12:25:00.000Z"),
      mood: MoodEmoji.okay,
      notes:
          "Average day with mixed emotions. Some classes were interesting, others felt boring.",
      tags: ["Study"],
      location: "Lecture Hall",
    ),
    MoodEntry(
      id: 10,
      timestamp: DateTime.parse("2025-01-06T19:40:00.000Z"),
      mood: MoodEmoji.great,
      notes:
          "Weekend relaxation was exactly what I needed. Spent quality time with family and recharged completely.",
      tags: ["Family Time", "Entertainment", "Sleep"],
      location: "Home",
    ),
    MoodEntry(
      id: 11,
      timestamp: DateTime.parse("2025-01-05T13:15:00.000Z"),
      mood: MoodEmoji.bad,
      notes:
          "Struggled with motivation today. The rainy weather made it hard to get out of bed and be productive.",
      tags: ["Sleep", "Weather", "Motivation"],
      location: "Dorm Room",
    ),
    MoodEntry(
      id: 12,
      timestamp: DateTime.parse("2025-01-04T17:50:00.000Z"),
      mood: MoodEmoji.good,
      notes:
          "Great workout session followed by healthy meal prep. Taking care of my body makes me feel accomplished.",
      tags: ["Exercise", "Self-care"],
      location: "Fitness Center",
    ),
    MoodEntry(
      id: 13,
      timestamp: DateTime.parse("2025-01-03T10:05:00.000Z"),
      mood: MoodEmoji.okay,
      notes:
          "Back to routine after break. Mixed feelings about starting new semester but optimistic overall.",
      tags: ["Study", "Planning", "Change"],
      location: "Campus",
    ),
    MoodEntry(
      id: 14,
      timestamp: DateTime.parse("2025-01-02T21:30:00.000Z"),
      mood: MoodEmoji.great,
      notes:
          "New Year celebration with close friends was incredible. Feeling grateful for the relationships in my life.",
      tags: ["Social", "Entertainment", "Celebration"],
      location: "Friend's House",
    ),
    MoodEntry(
      id: 15,
      timestamp: DateTime.parse("2025-01-01T14:00:00.000Z"),
      mood: MoodEmoji.good,
      notes:
          "Reflective start to the new year. Set some meaningful goals and feeling motivated for positive changes.",
      tags: ["Reflection", "Goal Setting"],
      location: "Home",
    ),
  ];

  List<MoodEntry> get _filteredMoodData {
    return _allMoodData.where((entry) {
      final moodValue = entry.mood.value;
      final tags = entry.tags;
      final date = entry.timestamp;

      // Mood range filter
      if (moodValue < (_currentFilters['minMood'] as int) ||
          moodValue > (_currentFilters['maxMood'] as int)) {
        return false;
      }

      // Activities filter
      final selectedActivities =
          (_currentFilters['activities'] as List).cast<String>();
      if (selectedActivities.isNotEmpty &&
          !selectedActivities.any((activity) => tags.contains(activity))) {
        return false;
      }

      // Triggers filter
      final selectedTriggers =
          (_currentFilters['triggers'] as List).cast<String>();
      if (selectedTriggers.isNotEmpty &&
          !selectedTriggers.any((trigger) => tags.contains(trigger))) {
        return false;
      }

      // Date range filter
      final startDate = _currentFilters['startDate'] as DateTime?;
      final endDate = _currentFilters['endDate'] as DateTime?;
      if (startDate != null && date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null &&
          date.isAfter(endDate.add(const Duration(days: 1)))) {
        return false;
      }

      return true;
    }).toList();
  }

  List<MoodEntry> get _periodFilteredData {
    final now = DateTime.now();
    final filteredData = _filteredMoodData;

    switch (_selectedPeriod) {
      case 'Week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return filteredData
            .where((entry) => entry.timestamp.isAfter(weekAgo))
            .toList();
      case 'Month':
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return filteredData
            .where((entry) => entry.timestamp.isAfter(monthAgo))
            .toList();
      case '3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return filteredData
            .where((entry) => entry.timestamp.isAfter(threeMonthsAgo))
            .toList();
      case 'Year':
        final yearAgo = DateTime(now.year - 1, now.month, now.day);
        return filteredData
            .where((entry) => entry.timestamp.isAfter(yearAgo))
            .toList();
      default:
        return filteredData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Mood History',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Filter Options',
          ),
          IconButton(
            onPressed: _exportData,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Export Data',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            // Sticky header with time period selector
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: Container(
                  color: colorScheme.surface,
                  padding: EdgeInsets.all(4.w),
                  child: TimePeriodSelectorWidget(
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: (period) {
                      setState(() {
                        _selectedPeriod = period;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Main content
            SliverToBoxAdapter(
              child: _isLoading
                  ? _buildLoadingState()
                  : Column(
                      children: [
                        SizedBox(height: 2.h),

                        // Mood trend graph
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: MoodTrendGraph(
                            entries: _allMoodData,
                            startDate: DateTime.now().subtract(Duration(
                                days: _selectedPeriod == 'Week'
                                    ? 7
                                    : _selectedPeriod == 'Month'
                                        ? 30
                                        : 90)),
                            endDate: DateTime.now(),
                            showMovingAverage: true,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // AI Insights
                        if (_periodFilteredData.isNotEmpty) ...[
                          InsightsWidget(
                            moodData: _periodFilteredData,
                            selectedPeriod: _selectedPeriod,
                          ),
                          SizedBox(height: 3.h),
                        ],

                        // Mood timeline
                        MoodEntryTimeline(
                          entries: _periodFilteredData,
                          onEditEntry: _editMoodEntry,
                          onDeleteEntry: _deleteMoodEntry,
                        ),

                        SizedBox(height: 10.h), // Bottom padding for FAB
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToMoodCheckIn,
        icon: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Log Mood',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 50.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 2.h),
            Text(
              'Loading mood history...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mood history updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: FilterOptionsWidget(
          currentFilters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
          },
        ),
      ),
    );
  }

  void _exportData() async {
    // Show export options
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Mood Data'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'csv'),
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'pdf'),
            child: const Text('PDF Report'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exporting mood data as ${result.toUpperCase()}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Simulate export process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Mood data exported successfully as ${result.toUpperCase()}'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                // Open exported file
              },
            ),
          ),
        );
      }
    }
  }

  void _editMoodEntry(int index) {
    // Navigate to mood check-in with pre-filled data
    Navigator.pushNamed(context, '/mood-check-in');
  }

  void _deleteMoodEntry(int index) {
    // Handle delete entry logic
    setState(() {
      // In a real app, this would delete from the backend
    });
  }

  void _navigateToMoodCheckIn() {
    Navigator.pushNamed(context, '/mood-check-in');
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 80.0;

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
