import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import './widgets/breathing_exercise_card.dart';
import './widgets/crisis_action_button.dart';
import './widgets/emergency_contact_card.dart';
import './widgets/grounding_technique_card.dart';
import './widgets/location_services_card.dart';

class CrisisSupport extends StatefulWidget {
  const CrisisSupport({super.key});

  @override
  State<CrisisSupport> createState() => _CrisisSupportState();
}

class _CrisisSupportState extends State<CrisisSupport> {
  bool _isSafeNow = false;
  final String _currentLocation = "University Campus";

  // Mock emergency contacts data
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "name": "Sarah Johnson",
      "relationship": "Best Friend",
      "phone": "(555) 123-4567",
    },
    {
      "name": "Dr. Michael Chen",
      "relationship": "Campus Counselor",
      "phone": "(555) 987-6543",
    },
    {
      "name": "Mom",
      "relationship": "Mother",
      "phone": "(555) 456-7890",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Prevent accidental back navigation
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Text(
            "Leave Crisis Support?",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            "Are you sure you want to leave the crisis support screen? If you're still in crisis, please stay and use the available resources.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Stay Here",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Leave",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _markAsSafe() {
    setState(() => _isSafeNow = true);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text("Crisis resolved. Returning to supportive dashboard..."),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate back to dashboard after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      }
    });
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
    );

    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch phone call to $phoneNumber'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching phone call: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _launchSMS(String phoneNumber, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch SMS to $phoneNumber'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching SMS: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _callCrisisHotline() async {
    const phoneNumber = '14416'; // Tele-MANAS Mental Health Helpline
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connecting to Tele-MANAS Mental Health Helpline..."),
        duration: Duration(seconds: 2),
      ),
    );
    await _launchPhoneCall(phoneNumber);
  }

  Future<void> _textCrisisLine() async {
    const phoneNumber = '741741';
    const message = 'HOME';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Opening crisis text line..."),
        duration: Duration(seconds: 2),
      ),
    );
    await _launchSMS(phoneNumber, message);
  }

  Future<void> _callCampusCounseling() async {
    const phoneNumber = '9999666555'; // Vandrevala Foundation number
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connecting to counseling helpline..."),
        duration: Duration(seconds: 2),
      ),
    );
    await _launchPhoneCall(phoneNumber);
  }

  Future<void> _handleEmergencyContact(
      Map<String, dynamic> contact, bool isCall) async {
    final name = contact['name'] as String;
    final phone =
        (contact['phone'] as String).replaceAll(RegExp(r'[^\d+]'), '');

    if (isCall) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Calling $name..."),
          duration: const Duration(seconds: 2),
        ),
      );
      await _launchPhoneCall(phone);
    } else {
      final message = "Hi $name, I need help. Can we talk?";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Opening text conversation with $name..."),
          duration: const Duration(seconds: 2),
        ),
      );
      await _launchSMS(phone, message);
    }
  }

  Future<void> _callEmergencyServices() async {
    const phoneNumber = '112';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Calling Emergency Services (112)..."),
        duration: Duration(seconds: 2),
      ),
    );
    await _launchPhoneCall(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmation();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.error,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: _showExitConfirmation,
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: Colors.white,
              size: 6.w,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Crisis Support",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Location: $_currentLocation",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 4.w),
              child: CustomIconWidget(
                iconName: 'emergency',
                color: Colors.white,
                size: 6.w,
              ),
            ),
          ],
        ),
        body: _isSafeNow ? _buildSafeConfirmation() : _buildCrisisContent(),
      ),
    );
  }

  Widget _buildSafeConfirmation() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.tertiary,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "You're Safe Now",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              "Crisis resolved. Returning to your supportive dashboard with resources for continued wellbeing.",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            CircularProgressIndicator(
              color: colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

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
            color: colorScheme.error.withValues(alpha: 0.1),
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
                    "If you're in immediate danger, call 112 or go to your nearest emergency room",
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
                  subtitle: "Tele-MANAS - 14416",
                  iconName: "phone",
                  backgroundColor: colorScheme.error,
                  textColor: Colors.white,
                  isPrimary: true,
                  onPressed: _callCrisisHotline,
                ),

                // Text Crisis Line
                CrisisActionButton(
                  title: "Text Crisis Line",
                  subtitle: "Text HOME to 741741",
                  iconName: "message",
                  backgroundColor: colorScheme.primary,
                  textColor: Colors.white,
                  onPressed: _textCrisisLine,
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
                  backgroundColor: Colors.red.shade900,
                  textColor: Colors.white,
                  onPressed: _callEmergencyServices,
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Location Services
          LocationServicesCard(
            onFindNearbyHelp: () {
              // Handle find nearby help action
            },
          ),

          SizedBox(height: 2.h),

          // Emergency Contacts Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Emergency Contacts",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _emergencyContacts.length,
                  itemBuilder: (context, index) {
                    final contact = _emergencyContacts[index];
                    return EmergencyContactCard(
                      contact: contact,
                      onCall: () => _handleEmergencyContact(contact, true),
                      onText: () => _handleEmergencyContact(contact, false),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Immediate Coping Support
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Immediate Coping Support",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                BreathingExerciseCard(
                  onStart: () {
                    // Log breathing exercise start
                  },
                ),
                GroundingTechniqueCard(
                  onStart: () {
                    // Log grounding technique start
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // I'm Safe Now Button
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: ElevatedButton(
              onPressed: _markAsSafe,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.tertiary,
                foregroundColor: Colors.white,
                elevation: 4.0,
                shadowColor: colorScheme.tertiary.withValues(alpha: 0.3),
                padding: EdgeInsets.symmetric(vertical: 4.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    "I'm Safe Now",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Privacy Notice
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              "All crisis support interactions are logged anonymously to improve services while maintaining your privacy. Your safety is our priority.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
