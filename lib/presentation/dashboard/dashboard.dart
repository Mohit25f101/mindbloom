import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/local_storage_service.dart';
import '../../models/user_model.dart';
import './widgets/crisis_support_banner.dart';
import './widgets/mood_trends_card.dart';
import './widgets/quick_actions_card.dart';
import './widgets/today_insights_card.dart';
import './widgets/upcoming_checkins_card.dart';
import './widgets/wellness_score_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showCrisisBanner = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late LocalStorageService _storage;
  UserModel? _currentUser;

  // User data with defaults
  Map<String, dynamic> userData = {
    "currentMood": 7.8,
    "streak": 12,
    "lastCheckIn": "2 hours ago",
    "wellnessScore": 7.8,
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _tabController = TabController(length: 1, vsync: this);
    _checkCrisisPatterns();
  }

  Future<void> _loadUserData() async {
    _storage = await LocalStorageService.getInstance();
    final user = _storage.getUser();
    if (user != null && mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkCrisisPatterns() {
    final wellnessScore = userData["wellnessScore"] as double;
    setState(() {
      _showCrisisBanner = wellnessScore < 5.0;
    });
  }

  Future<void> _refreshDashboard() async {
    final loadingState = Provider.of<LoadingState>(context, listen: false);
    try {
      loadingState.startLoading('Refreshing dashboard...');
      await _loadUserData();
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
          icon: Semantics(
            button: true,
            label: 'Open menu',
            child: CustomIconWidget(
              iconName: 'menu',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Semantics(
              button: true,
              label: 'Settings',
              child: const Icon(Icons.settings),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          IconButton(
            icon: Semantics(
              button: true,
              label: 'Crisis Support',
              child: Container(
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
                          _buildHeaderSection(context),
                          SizedBox(height: 2.h),
                          CrisisSupportBanner(
                            isVisible: _showCrisisBanner,
                            onDismiss: () {
                              setState(() {
                                _showCrisisBanner = false;
                              });
                            },
                          ),
                          const MoodTrendsCard(),
                          const TodayInsightsCard(),
                          const UpcomingCheckinsCard(),
                          const QuickActionsCard(),
                          SizedBox(height: 10.h),
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
      floatingActionButton: Semantics(
        button: true,
        label: 'Log your current mood',
        child: FloatingActionButton.extended(
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
          Semantics(
            header: true,
            label: '${_getGreeting()}, ${_currentUser?.username ?? 'User'}!',
            child: Text(
              '${_getGreeting()}, ${_currentUser?.username ?? 'User'}!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Semantics(
            label: 'Last mood check-in: ${userData["lastCheckIn"]}',
            child: Text(
              'Last check-in: ${userData["lastCheckIn"]}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          SizedBox(height: 3.h),
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
                      _currentUser?.username.substring(0, 1).toUpperCase() ??
                          'U',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Semantics(
                    label: 'User name: ${_currentUser?.username ?? 'User'}',
                    child: Text(
                      _currentUser?.username ?? 'User',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Semantics(
                    label:
                        'Current wellness score: ${userData["wellnessScore"]} out of 10',
                    child: Text(
                      'Wellness Score: ${userData["wellnessScore"]}/10',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  return Semantics(
                    button: true,
                    label: item["title"],
                    child: ListTile(
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
                    ),
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
              Semantics(
                header: true,
                child: Text(
                  'Quick Mood Log',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                child: Semantics(
                  button: true,
                  label: 'Open detailed mood check-in form',
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/mood-check-in');
                    },
                    child: const Text('Detailed Check-in'),
                  ),
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

    return Semantics(
      button: true,
      label: 'Select mood: $label',
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mood logged: $label'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Column(
          children: [
            Text(
              emoji,
              style: theme.textTheme.headlineMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
