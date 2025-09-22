import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/crisis_support_banner.dart';
import './widgets/mood_trends_card.dart';
import './widgets/quick_actions_card.dart';
import './widgets/today_insights_card.dart';
import './widgets/upcoming_checkins_card.dart';
import './widgets/wellness_score_widget.dart';

class Dashboard extends StatefulWidget {
  final String userName;

  const Dashboard({super.key, required this.userName});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showCrisisBanner = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Sarah",
    "currentMood": 7.8,
    "streak": 12,
    "lastCheckIn": "2 hours ago",
    "wellnessScore": 7.8,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _checkCrisisPatterns();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkCrisisPatterns() {
    // Simulate crisis detection algorithm
    final wellnessScore = userData["wellnessScore"] as double;
    setState(() {
      _showCrisisBanner = wellnessScore < 5.0; // Show if score is concerning
    });
  }

  Future<void> _refreshDashboard() async {
    final loadingState = Provider.of<LoadingState>(context, listen: false);
    try {
      loadingState.startLoading('Refreshing dashboard...');
      // Simulate data refresh
      await Future.delayed(const Duration(seconds: 2));
      _checkCrisisPatterns();
    } finally {
      loadingState.stopLoading();
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mindbloom'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'menu',
            color: colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.errorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const CustomIconWidget(
                iconName: 'emergency',
                color: AppTheme.errorLight,
                size: 20,
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, '/crisis-support'),
            tooltip: 'Crisis Support',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      drawer: _buildNavigationDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Home'),
                ],
                labelColor: colorScheme.primary,
                unselectedLabelColor:
                    colorScheme.onSurface.withValues(alpha: 0.6),
                indicatorColor: colorScheme.primary,
              ),
            ),
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: _refreshDashboard,
                    color: colorScheme.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          // Header Section
                          _buildHeaderSection(context),
                          SizedBox(height: 2.h),
                          // Crisis Support Banner
                          CrisisSupportBanner(
                            isVisible: _showCrisisBanner,
                            onDismiss: () {
                              setState(() {
                                _showCrisisBanner = false;
                              });
                            },
                          ),
                          // Main Content Cards
                          const MoodTrendsCard(),
                          const TodayInsightsCard(),
                          const UpcomingCheckinsCard(),
                          const QuickActionsCard(),
                          SizedBox(height: 10.h), // Space for FAB
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickMoodLog(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const CustomIconWidget(
          iconName: 'mood',
          color: Colors.white,
          size: 24,
        ),
        label: const Text('Log Mood'),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            '${_getGreeting()}, ${widget.userName}!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Last check-in: ${userData["lastCheckIn"]}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 3.h),
          // Wellness Score Widget
          WellnessScoreWidget(
            score: userData["wellnessScore"],
            streak: userData["streak"],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> drawerItems = [
      {"title": "Dashboard", "icon": "dashboard", "route": "/dashboard"},
      {"title": "Mood History", "icon": "history", "route": "/mood-history"},
      {
        "title": "AI Companion",
        "icon": "psychology",
        "route": "/ai-companion-chat"
      },
      {
        "title": "Crisis Support",
        "icon": "emergency",
        "route": "/crisis-support"
      },
      {"title": "Settings", "icon": "settings", "route": "/settings"},
      {"title": "Resources", "icon": "library_books", "route": "/resources"},
    ];

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.1),
                    colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      widget.userName.substring(0, 1).toUpperCase(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.userName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Wellness Score: ${userData["wellnessScore"]}/10',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  return ListTile(
                    leading: CustomIconWidget(
                      iconName: item["icon"],
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      size: 24,
                    ),
                    title: Text(
                      item["title"],
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (item["route"] != "/dashboard") {
                        Navigator.pushNamed(context, item["route"]);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickMoodLog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Quick Mood Log',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodButton(context, '😢', 'Sad', 2),
                  _buildMoodButton(context, '😐', 'Okay', 5),
                  _buildMoodButton(context, '😊', 'Good', 7),
                  _buildMoodButton(context, '😄', 'Great', 9),
                ],
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/mood-check-in');
                  },
                  child: const Text('Detailed Check-in'),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodButton(
      BuildContext context, String emoji, String label, int value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // Handle quick mood log
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood logged: $label'),
            backgroundColor: colorScheme.primary,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              emoji,
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
