import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController ageController;
  final String? selectedUniversity;
  final String? selectedAcademicYear;
  final String? selectedMajor;
  final bool dataCollectionConsent;
  final bool crisisInterventionConsent;
  final bool emergencyContactConsent;
  final Function(String?) onUniversityChanged;
  final Function(String?) onAcademicYearChanged;
  final Function(String?) onMajorChanged;
  final Function(bool) onDataCollectionChanged;
  final Function(bool) onCrisisInterventionChanged;
  final Function(bool) onEmergencyContactChanged;

  const RegistrationFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.ageController,
    required this.selectedUniversity,
    required this.selectedAcademicYear,
    required this.selectedMajor,
    required this.dataCollectionConsent,
    required this.crisisInterventionConsent,
    required this.emergencyContactConsent,
    required this.onUniversityChanged,
    required this.onAcademicYearChanged,
    required this.onMajorChanged,
    required this.onDataCollectionChanged,
    required this.onCrisisInterventionChanged,
    required this.onEmergencyContactChanged,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;

  final List<String> universities = [
    'Harvard University',
    'Stanford University',
    'MIT',
    'University of California, Berkeley',
    'Yale University',
    'Princeton University',
    'Columbia University',
    'University of Chicago',
    'University of Pennsylvania',
    'Cornell University',
    'Northwestern University',
    'Duke University',
    'Johns Hopkins University',
    'Dartmouth College',
    'Brown University',
    'Vanderbilt University',
    'Rice University',
    'Washington University in St. Louis',
    'University of Notre Dame',
    'Georgetown University',
  ];

  final List<String> academicYears = [
    'Freshman',
    'Sophomore',
    'Junior',
    'Senior',
    'Graduate Student',
    'PhD Student',
  ];

  final List<String> majors = [
    'Computer Science',
    'Psychology',
    'Business Administration',
    'Engineering',
    'Biology',
    'English Literature',
    'Mathematics',
    'Economics',
    'Political Science',
    'Chemistry',
    'Physics',
    'History',
    'Art',
    'Music',
    'Philosophy',
    'Sociology',
    'Anthropology',
    'Communications',
    'Education',
    'Pre-Med',
    'Pre-Law',
    'Other',
  ];

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      switch (score) {
        case 0:
        case 1:
          _passwordStrength = 'Weak';
          _passwordStrengthColor = AppTheme.lightTheme.colorScheme.error;
          break;
        case 2:
        case 3:
          _passwordStrength = 'Medium';
          _passwordStrengthColor = AppTheme.warningLight;
          break;
        case 4:
        case 5:
          _passwordStrength = 'Strong';
          _passwordStrengthColor = AppTheme.successLight;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your university email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create a secure password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            onChanged: _checkPasswordStrength,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),

          // Password Strength Indicator
          if (_passwordStrength.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  'Password Strength: ',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  _passwordStrength,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _passwordStrengthColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 3.h),

          // Confirm Password Field
          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // University Dropdown
          DropdownButtonFormField<String>(
            initialValue: widget.selectedUniversity,
            decoration: InputDecoration(
              labelText: 'University',
              hintText: 'Select your university',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'school',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            items: universities.map((String university) {
              return DropdownMenuItem<String>(
                value: university,
                child: Text(
                  university,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: widget.onUniversityChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your university';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Academic Year and Major Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: widget.selectedAcademicYear,
                  decoration: InputDecoration(
                    labelText: 'Academic Year',
                    hintText: 'Select year',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'calendar_today',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  items: academicYears.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: widget.onAcademicYearChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: TextFormField(
                  controller: widget.ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter age',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 13 || age > 100) {
                      return 'Invalid age';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Major Dropdown
          DropdownButtonFormField<String>(
            initialValue: widget.selectedMajor,
            decoration: InputDecoration(
              labelText: 'Major/Field of Study',
              hintText: 'Select your major',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'book',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            items: majors.map((String major) {
              return DropdownMenuItem<String>(
                value: major,
                child: Text(
                  major,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: widget.onMajorChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your major';
              }
              return null;
            },
          ),
          SizedBox(height: 4.h),

          // Privacy Consent Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & Consent',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),

                // Data Collection Consent
                CheckboxListTile(
                  value: widget.dataCollectionConsent,
                  onChanged: (value) =>
                      widget.onDataCollectionChanged(value ?? false),
                  title: Text(
                    'I consent to data collection for mental health monitoring',
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'Your mood data, assessments, and app usage will be securely stored to provide personalized support.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // Crisis Intervention Consent
                CheckboxListTile(
                  value: widget.crisisInterventionConsent,
                  onChanged: (value) =>
                      widget.onCrisisInterventionChanged(value ?? false),
                  title: Text(
                    'I consent to crisis intervention protocols',
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'MindGuard may contact emergency services or designated contacts if severe mental health risks are detected.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // Emergency Contact Consent
                CheckboxListTile(
                  value: widget.emergencyContactConsent,
                  onChanged: (value) =>
                      widget.onEmergencyContactChanged(value ?? false),
                  title: Text(
                    'I consent to emergency contact notifications',
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'Designated emergency contacts may be notified in crisis situations to ensure your safety and wellbeing.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
