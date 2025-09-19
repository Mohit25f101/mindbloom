import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_options_widget.dart';
import './widgets/insights_widget.dart';
import './widgets/mood_chart_widget.dart';
import './widgets/mood_timeline_widget.dart';
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
  final List<Map<String, dynamic>> _allMoodData = [
    {
      "id": 1,
      "date": "2025-01-15T10:30:00.000Z",
      "rating": 4,
      "notes":
          "Had a great morning workout and felt energized for classes. The weather was perfect for a walk between lectures.",
      "activities": ["Exercise", "Study", "Social"],
      "triggers": [],
      "location": "Campus Gym"
    },
    {
      "id": 2,
      "date": "2025-01-14T16:45:00.000Z",
      "rating": 3,
      "notes":
          "Neutral day overall. Completed assignments but felt a bit overwhelmed with upcoming deadlines.",
      "activities": ["Study", "Work"],
      "triggers": ["Deadlines"],
      "location": "Library"
    },
    {
      "id": 3,
      "date": "2025-01-13T20:15:00.000Z",
      "rating": 5,
      "notes":
          "Amazing day! Aced my presentation and celebrated with friends. Feeling confident and happy.",
      "activities": ["Study", "Social", "Entertainment"],
      "triggers": [],
      "location": "Student Center"
    },
    {
      "id": 4,
      "date": "2025-01-12T14:20:00.000Z",
      "rating": 2,
      "notes":
          "Stressful day with back-to-back exams. Didn't sleep well last night and it showed in my performance.",
      "activities": ["Study"],
      "triggers": ["Exams", "Sleep"],
      "location": "Exam Hall"
    },
    {
      "id": 5,
      "date": "2025-01-11T11:00:00.000Z",
      "rating": 4,
      "notes":
          "Good study session with friends. We helped each other understand difficult concepts.",
      "activities": ["Study", "Social"],
      "triggers": [],
      "location": "Study Room"
    },
    {
      "id": 6,
      "date": "2025-01-10T18:30:00.000Z",
      "rating": 3,
      "notes":
          "Regular day. Attended all classes and did some light exercise. Nothing particularly exciting.",
      "activities": ["Study", "Exercise"],
      "triggers": [],
      "location": "Campus"
    },
    {
      "id": 7,
      "date": "2025-01-09T09:45:00.000Z",
      "rating": 1,
      "notes":
          "Very difficult day. Received disappointing grade on important project. Feeling discouraged about academic progress.",
      "activities": ["Study"],
      "triggers": ["Academic Pressure", "Grades"],
      "location": "Professor's Office"
    },
    {
      "id": 8,
      "date": "2025-01-08T15:10:00.000Z",
      "rating": 4,
      "notes":
          "Productive day working on group project. Team collaboration went smoothly and we made good progress.",
      "activities": ["Study", "Social", "Work"],
      "triggers": [],
      "location": "Group Study Area"
    },
    {
      "id": 9,
      "date": "2025-01-07T12:25:00.000Z",
      "rating": 3,
      "notes":
          "Average day with mixed emotions. Some classes were interesting, others felt boring.",
      "activities": ["Study"],
      "triggers": [],
      "location": "Lecture Hall"
    },
    {
      "id": 10,
      "date": "2025-01-06T19:40:00.000Z",
      "rating": 5,
      "notes":
          "Weekend relaxation was exactly what I needed. Spent quality time with family and recharged completely.",
      "activities": ["Family Time", "Entertainment", "Sleep"],
      "triggers": [],
      "location": "Home"
    },
    {
      "id": 11,
      "date": "2025-01-05T13:15:00.000Z",
      "rating": 2,
      "notes":
          "Struggled with motivation today. The rainy weather made it hard to get out of bed and be productive.",
      "activities": ["Sleep"],
      "triggers": ["Weather", "Motivation"],
      "location": "Dorm Room"
    },
    {
      "id": 12,
      "date": "2025-01-04T17:50:00.000Z",
      "rating": 4,
      "notes":
          "Great workout session followed by healthy meal prep. Taking care of my body makes me feel accomplished.",
      "activities": ["Exercise", "Self-care"],
      "triggers": [],
      "location": "Fitness Center"
    },
    {
      "id": 13,
      "date": "2025-01-03T10:05:00.000Z",
      "rating": 3,
      "notes":
          "Back to routine after break. Mixed feelings about starting new semester but optimistic overall.",
      "activities": ["Study", "Planning"],
      "triggers": ["Change"],
      "location": "Campus"
    },
    {
      "id": 14,
      "date": "2025-01-02T21:30:00.000Z",
      "rating": 5,
      "notes":
          "New Year celebration with close friends was incredible. Feeling grateful for the relationships in my life.",
      "activities": ["Social", "Entertainment", "Celebration"],
      "triggers": [],
      "location": "Friend's House"
    },
    {
      "id": 15,
      "date": "2025-01-01T14:00:00.000Z",
      "rating": 4,
      "notes":
          "Reflective start to the new year. Set some meaningful goals and feeling motivated for positive changes.",
      "activities": ["Reflection", "Goal Setting"],
      "triggers": [],
      "location": "Home"
    }
  ];

  List<Map<String, dynamic>> get _filteredMoodData {
    return _allMoodData.where((entry) {
      final rating = entry['rating'] as int;
      final activities = (entry['activities'] as List).cast<String>();
      final triggers = (entry['triggers'] as List).cast<String>();
      final date = DateTime.parse(entry['date'] as String);

      // Mood range filter
      if (rating < (_currentFilters['minMood'] as int) ||
          rating > (_currentFilters['maxMood'] as int)) {
        return false;
      }

      // Activities filter
      final selectedActivities =
          (_currentFilters['activities'] as List).cast<String>();
      if (selectedActivities.isNotEmpty &&
          !selectedActivities
              .any((activity) => activities.contains(activity))) {
        return false;
      }

      // Triggers filter
      final selectedTriggers =
          (_currentFilters['triggers'] as List).cast<String>();
      if (selectedTriggers.isNotEmpty &&
          !selectedTriggers.any((trigger) => triggers.contains(trigger))) {
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

  List<Map<String, dynamic>> get _periodFilteredData {
    final now = DateTime.now();
    final filteredData = _filteredMoodData;

    switch (_selectedPeriod) {
      case 'Week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return filteredData.where((entry) {
          final date = DateTime.parse(entry['date'] as String);
          return date.isAfter(weekAgo);
        }).toList();
      case 'Month':
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return filteredData.where((entry) {
          final date = DateTime.parse(entry['date'] as String);
          return date.isAfter(monthAgo);
        }).toList();
      case '3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return filteredData.where((entry) {
          final date = DateTime.parse(entry['date'] as String);
          return date.isAfter(threeMonthsAgo);
        }).toList();
      case 'Year':
        final yearAgo = DateTime(now.year - 1, now.month, now.day);
        return filteredData.where((entry) {
          final date = DateTime.parse(entry['date'] as String);
          return date.isAfter(yearAgo);
        }).toList();
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

                        // Mood chart
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: MoodChartWidget(
                            moodData: _periodFilteredData,
                            selectedPeriod: _selectedPeriod,
                            onDataPointTap: _onChartDataPointTap,
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
                        MoodTimelineWidget(
                          moodEntries: _periodFilteredData,
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
    return Container(
      height: 50.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
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

  void _onChartDataPointTap(int index) {
    if (index >= 0 && index < _periodFilteredData.length) {
      final entry = _periodFilteredData[index];
      _showMoodEntryDetails(entry);
    }
  }

  void _showMoodEntryDetails(Map<String, dynamic> entry) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final date = DateTime.parse(entry['date'] as String);
    final rating = entry['rating'] as int;
    final notes = entry['notes'] as String? ?? '';
    final activities = (entry['activities'] as List?)?.cast<String>() ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: 70.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood Entry Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${date.month}/${date.day}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          'Mood Rating: ',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          '$rating/5',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (notes.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'Notes:',
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        notes,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    if (activities.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'Activities:',
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: activities.map((activity) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              activity,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    final theme = Theme.of(context);

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
