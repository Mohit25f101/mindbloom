import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/mood_emoji.dart';
import './widgets/activity_selector_widget.dart';
import './widgets/mood_history_timeline_widget.dart';
import './widgets/mood_notes_widget.dart';
import './widgets/mood_selection_widget.dart';
import './widgets/mood_tags_widget.dart';
import './widgets/streak_counter_widget.dart';
import './widgets/voice_recording_widget.dart';

class MoodCheckIn extends StatefulWidget {
  const MoodCheckIn({super.key});

  @override
  State<MoodCheckIn> createState() => _MoodCheckInState();
}

class _MoodCheckInState extends State<MoodCheckIn>
    with TickerProviderStateMixin {
  MoodEmoji? _selectedMood;
  final List<String> _selectedTags = [];
  String _selectedActivity = "";
  String _notes = "";
  bool _isNotesExpanded = false;
  bool _isLoading = false;
  int _streakCount = 7;
  final String _userName = "Alex";
  late TabController _tabController;

  final List<String> _motivationalMessages = [
    "You're doing great! Keep tracking your mood daily.",
    "Consistency is key to understanding your mental health patterns.",
    "Every day you check in is a step towards better self-awareness.",
    "Your mental health journey matters. Keep going!",
    "Building healthy habits one day at a time.",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTagToggle(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _onActivitySelected(String activity) {
    setState(() {
      _selectedActivity = activity;
    });
  }

  void _onNotesChanged(String notes) {
    setState(() {
      _notes = notes;
    });
  }

  void _toggleNotesExpanded() {
    setState(() {
      _isNotesExpanded = !_isNotesExpanded;
    });
  }

  void _onVoiceRecorded(String transcription) {
    setState(() {
      _notes = transcription;
      _isNotesExpanded = true;
    });
  }

  Future<void> _logMood() async {
    if (_selectedMood == null) {
      _showErrorMessage("Please select your mood level");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _streakCount++;
    });

    _showSuccessAnimation();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                size: 48,
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Mood Logged Successfully!",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              "Keep up the great work with your daily check-ins!",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/ai-companion-chat');
                    },
                    child: const Text("Chat with AI"),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetForm();
                    },
                    child: const Text("Done"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedMood = null;
      _selectedTags.clear();
      _selectedActivity = "";
      _notes = "";
      _isNotesExpanded = false;
    });
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _streakCount = 7 + (DateTime.now().day % 5);
    });
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
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
    ];

    return "${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Tab Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Dashboard"),
                  Tab(text: "Mood Check"),
                  Tab(text: "AI Chat"),
                  Tab(text: "History"),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.pushNamed(context, '/dashboard');
                      break;
                    case 1:
                      // Current screen
                      break;
                    case 2:
                      Navigator.pushNamed(context, '/ai-companion-chat');
                      break;
                    case 3:
                      Navigator.pushNamed(context, '/mood-history');
                      break;
                  }
                },
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppTheme.lightTheme.colorScheme.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_getGreeting()}, $_userName!",
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  _getCurrentDateTime(),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/crisis-support'),
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.error
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: CustomIconWidget(
                                iconName: 'emergency',
                                size: 20,
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Streak Counter
                      StreakCounterWidget(
                        streakCount: _streakCount,
                        motivationalMessage: _motivationalMessages[
                            _streakCount % _motivationalMessages.length],
                      ),

                      SizedBox(height: 4.h),

                      // Mood Selector
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: MoodSelectionWidget(
                          initialMood: _selectedMood,
                          onMoodSelected: (mood) {
                            setState(() {
                              _selectedMood = mood;
                            });
                            // Provide haptic feedback
                            HapticFeedback.mediumImpact();
                          },
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Mood Tags
                      MoodTagsWidget(
                        selectedTags: _selectedTags,
                        onTagToggle: _onTagToggle,
                      ),

                      SizedBox(height: 4.h),

                      // Activity Selector
                      ActivitySelectorWidget(
                        selectedActivity: _selectedActivity,
                        onActivitySelected: _onActivitySelected,
                      ),

                      SizedBox(height: 4.h),

                      // Mood Notes
                      MoodNotesWidget(
                        notes: _notes,
                        onNotesChanged: _onNotesChanged,
                        isExpanded: _isNotesExpanded,
                        onToggleExpanded: _toggleNotesExpanded,
                      ),

                      SizedBox(height: 4.h),

                      // Voice Recording
                      VoiceRecordingWidget(
                        onVoiceRecorded: _onVoiceRecorded,
                      ),

                      SizedBox(height: 4.h),

                      // Log Mood Button
                      SizedBox(
                        width: double.infinity,
                        height: 7.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _logMood,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      "Logging Mood...",
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomIconWidget(
                                      iconName: 'favorite',
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      "Log My Mood",
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Quick Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/ai-companion-chat'),
                              icon: CustomIconWidget(
                                iconName: 'psychology',
                                size: 18,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                              label: const Text("AI Support"),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Navigate to breathing exercises
                                _showBreathingExercise();
                              },
                              icon: CustomIconWidget(
                                iconName: 'air',
                                size: 18,
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                              ),
                              label: const Text("Breathe"),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Mood History Timeline
                      const MoodHistoryTimelineWidget(),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBreathingExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    "Quick Breathing Exercise",
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Take a moment to center yourself with this simple breathing technique.",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 40.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'air',
                        size: 48,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Breathe in for 4 seconds\nHold for 4 seconds\nBreathe out for 6 seconds",
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Start Exercise"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
