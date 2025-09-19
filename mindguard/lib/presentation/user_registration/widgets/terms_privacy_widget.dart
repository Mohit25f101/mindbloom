import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TermsPrivacyWidget extends StatelessWidget {
  const TermsPrivacyWidget({super.key});

  void _showTermsOfService(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheetContent(
        context,
        'Terms of Service',
        _getTermsOfServiceContent(),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheetContent(
        context,
        'Privacy Policy',
        _getPrivacyPolicyContent(),
      ),
    );
  }

  Widget _buildBottomSheetContent(
      BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(6.w),
              child: Text(
                content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTermsOfServiceContent() {
    return '''
MINDGUARD TERMS OF SERVICE

Last Updated: September 15, 2025

1. ACCEPTANCE OF TERMS
By creating an account and using MindGuard, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, please do not use our service.

2. DESCRIPTION OF SERVICE
MindGuard is a mental health monitoring and support application designed specifically for students. Our service includes:
- Continuous mental health monitoring through self-assessments
- AI-driven sentiment analysis and mood tracking
- Personalized coping strategies and recommendations
- Crisis intervention protocols and emergency support
- AI companion chatbot for emotional support
- Secure data storage and privacy protection

3. USER ELIGIBILITY
You must be at least 13 years old to use MindGuard. Users under 18 require parental consent. By using our service, you represent that you meet these age requirements.

4. USER RESPONSIBILITIES
You agree to:
- Provide accurate and complete information during registration
- Maintain the security of your account credentials
- Use the service only for its intended mental health support purposes
- Not share your account with others
- Comply with all applicable laws and regulations

5. MENTAL HEALTH DISCLAIMER
MindGuard is not a substitute for professional medical care or emergency services. Our service:
- Does not provide medical diagnosis or treatment
- Should not be used in place of professional therapy or counseling
- Cannot guarantee prevention of mental health crises
- Is designed to supplement, not replace, professional care

6. CRISIS INTERVENTION
By using MindGuard, you consent to our crisis intervention protocols, which may include:
- Automatic detection of severe mental health risks
- Contact with emergency services when necessary
- Notification of designated emergency contacts
- Sharing of relevant information with healthcare providers

7. DATA COLLECTION AND PRIVACY
Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information. By using MindGuard, you consent to our data practices as described in our Privacy Policy.

8. INTELLECTUAL PROPERTY
All content, features, and functionality of MindGuard are owned by us and are protected by copyright, trademark, and other intellectual property laws.

9. LIMITATION OF LIABILITY
To the fullest extent permitted by law, MindGuard and its affiliates shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the service.

10. TERMINATION
We reserve the right to terminate or suspend your account at any time for violation of these terms or for any other reason at our sole discretion.

11. CHANGES TO TERMS
We may modify these terms at any time. We will notify you of significant changes through the app or via email. Continued use of the service after changes constitutes acceptance of the new terms.

12. CONTACT INFORMATION
If you have questions about these Terms of Service, please contact us at:
Email: support@mindguard.app
Phone: 1-800-MINDGUARD

By using MindGuard, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.
''';
  }

  String _getPrivacyPolicyContent() {
    return '''
MINDGUARD PRIVACY POLICY

Last Updated: September 15, 2025

1. INTRODUCTION
MindGuard ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mental health monitoring application.

2. INFORMATION WE COLLECT

Personal Information:
- Name, email address, age, and university affiliation
- Academic year, major, and educational information
- Emergency contact information

Mental Health Data:
- Mood assessments and self-reported mental health status
- Sentiment analysis from text inputs and communications
- Activity tracking and behavioral patterns
- Crisis intervention interactions and outcomes

Technical Information:
- Device information, IP address, and usage analytics
- App performance data and error reports
- Location data (only when explicitly consented for crisis services)

3. HOW WE USE YOUR INFORMATION

We use your information to:
- Provide personalized mental health monitoring and support
- Detect early signs of mental health crises
- Offer tailored coping strategies and recommendations
- Facilitate crisis intervention when necessary
- Improve our services through analytics and research
- Communicate with you about your account and our services

4. INFORMATION SHARING AND DISCLOSURE

We may share your information in the following circumstances:
- With emergency services during mental health crises
- With designated emergency contacts as consented
- With healthcare providers when you request or consent
- With service providers who assist in app functionality
- When required by law or to protect safety

We do NOT sell your personal information to third parties.

5. DATA SECURITY

We implement robust security measures to protect your information:
- End-to-end encryption for sensitive mental health data
- Secure cloud storage with industry-standard protections
- Regular security audits and vulnerability assessments
- Limited access controls for authorized personnel only

6. YOUR PRIVACY RIGHTS

You have the right to:
- Access and review your personal information
- Request correction of inaccurate data
- Delete your account and associated data
- Opt-out of certain data collection practices
- Receive a copy of your data in a portable format

7. DATA RETENTION

We retain your information for as long as necessary to:
- Provide our services and support your mental health
- Comply with legal obligations
- Resolve disputes and enforce our agreements

You may request deletion of your data at any time, subject to legal requirements.

8. INTERNATIONAL DATA TRANSFERS

Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your privacy rights.

9. CHILDREN'S PRIVACY

We take special care to protect the privacy of users under 18. Parental consent is required for users under 18, and we limit data collection to what is necessary for mental health support.

10. CHANGES TO THIS POLICY

We may update this Privacy Policy periodically. We will notify you of significant changes through the app or via email. Your continued use of MindGuard after changes constitutes acceptance of the updated policy.

11. CONTACT US

If you have questions about this Privacy Policy or our privacy practices, please contact us at:

Email: privacy@mindguard.app
Phone: 1-800-MINDGUARD
Address: MindGuard Privacy Office, 123 Mental Health Way, Wellness City, WC 12345

For EU residents, you may also contact our Data Protection Officer at: dpo@mindguard.app

This Privacy Policy is designed to be transparent about our data practices while ensuring we can provide effective mental health support services.
''';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Text(
            'By creating an account, you agree to our',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showTermsOfService(context),
                child: Text(
                  'Terms of Service',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: () => _showPrivacyPolicy(context),
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
