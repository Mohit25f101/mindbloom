import 'package:flutter/material.dart';
import '../presentation/login/login.dart';
import '../presentation/mood_check_in/mood_check_in.dart';
import '../presentation/crisis_support/crisis_support.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/ai_companion_chat/ai_companion_chat.dart';
import '../presentation/user_registration/user_registration.dart';
import '../presentation/mood_history/mood_history.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String login = '/login';
  static const String moodCheckIn = '/mood-check-in';
  static const String crisisSupport = '/crisis-support';
  static const String dashboard = '/dashboard';
  static const String aiCompanionChat = '/ai-companion-chat';
  static const String userRegistration = '/user-registration';
  static const String moodHistory = '/mood-history';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const Login(),
    login: (context) => const Login(),
    moodCheckIn: (context) => const MoodCheckIn(),
    crisisSupport: (context) => const CrisisSupport(),
    dashboard: (context) => const Dashboard(),
    aiCompanionChat: (context) => const AiCompanionChat(),
    userRegistration: (context) => const UserRegistration(),
    moodHistory: (context) => const MoodHistory(),
  };
}
