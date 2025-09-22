import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/crisis_action_button.dart';

class CrisisSupport extends StatefulWidget {
  const CrisisSupport({super.key});

  @override
  State<CrisisSupport> createState() => _CrisisSupportState();
}

class _CrisisSupportState extends State<CrisisSupport> {
  void _callCrisisHotline() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            "Connecting to KIRAN Mental Health Helpline (1800-599-0019)..."),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _callCampusCounseling() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connecting to campus counseling center..."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _callEmergencyServices() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Calling Emergency Services (112)..."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ... (call/text emergency contact methods remain the same)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Support'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildCrisisContent(),
      ),
    );
  }

  // ... (_buildSafeConfirmation remains the same)

  Widget _buildCrisisContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Emergency Alert Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            color: colorScheme.error.withOpacity(0.1),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: colorScheme.error,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    "If you're in immediate danger, call 112 or go to your nearest emergency room.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Primary Crisis Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    "Immediate Help",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // Crisis Hotline - Primary Action
                CrisisActionButton(
                  title: "Call Mental Health Helpline",
                  subtitle: "KIRAN - 1800-599-0019 (24/7)",
                  iconName: "phone",
                  backgroundColor: colorScheme.error,
                  textColor: Colors.white,
                  isPrimary: true,
                  onPressed: _callCrisisHotline,
                ),

                // Another Helpline
                CrisisActionButton(
                  title: "Vandrevala Foundation",
                  subtitle: "24/7 Helpline - 9999666555",
                  iconName: "phone_forwarded",
                  backgroundColor: colorScheme.primary,
                  textColor: Colors.white,
                  onPressed: () {/* Add call logic */},
                ),

                // Campus Counseling
                CrisisActionButton(
                  title: "Campus Counseling",
                  subtitle: "24/7 student support services",
                  iconName: "school",
                  backgroundColor: colorScheme.secondary,
                  textColor: Colors.white,
                  onPressed: _callCampusCounseling,
                ),

                // Emergency Services
                CrisisActionButton(
                  title: "Emergency Services",
                  subtitle: "Call 112 for immediate emergency",
                  iconName: "local_hospital",
                  backgroundColor: Colors.red.shade700,
                  textColor: Colors.white,
                  onPressed: _callEmergencyServices,
                ),
              ],
            ),
          ),

          // ... (rest of the widgets like Location, Emergency Contacts, etc. remain the same)
        ],
      ),
    );
  }
}
