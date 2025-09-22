import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RegistrationFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  final TextEditingController addressController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController ageController;
  final String? selectedGender;
  final String? selectedUniversity;
  final String? selectedAcademicYear;
  final String? selectedMajor;
  final bool dataCollectionConsent;
  final bool crisisInterventionConsent;
  final bool emergencyContactConsent;
  final Function(String?) onGenderChanged;
  final Function(String?) onUniversityChanged;
  final Function(String?) onAcademicYearChanged;
  final Function(String?) onMajorChanged;
  final Function(bool) onDataCollectionChanged;
  final Function(bool) onCrisisInterventionChanged;
  final Function(bool) onEmergencyContactChanged;

  const RegistrationFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.ageController,
    required this.selectedGender,
    required this.selectedUniversity,
    required this.selectedAcademicYear,
    required this.selectedMajor,
    required this.dataCollectionConsent,
    required this.crisisInterventionConsent,
    required this.emergencyContactConsent,
    required this.onGenderChanged,
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

  // Updated list of Indian Universities
  final List<String> universities = [
    'Indian Institute of Technology Bombay (IIT Bombay)',
    'Indian Institute of Technology Delhi (IIT Delhi)',
    'Indian Institute of Science (IISc Bangalore)',
    'Indian Institute of Technology Madras (IIT Madras)',
    'University of Delhi',
    'Jawaharlal Nehru University (JNU)',
    'Banaras Hindu University (BHU)',
    'Vellore Institute of Technology (VIT)',
    'Anna University',
    'Manipal Academy of Higher Education',
  ];

  final List<String> genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

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
  ];

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordStrength = '';
        _passwordStrengthColor = Colors.grey;
        return;
      }

      final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
      final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      final bool hasDigits = password.contains(RegExp(r'[0-9]'));
      final bool hasSpecialCharacters =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      final int length = password.length;

      int strength = 0;
      if (length >= 8) strength++;
      if (hasUppercase) strength++;
      if (hasLowercase) strength++;
      if (hasDigits) strength++;
      if (hasSpecialCharacters) strength++;

      switch (strength) {
        case 0:
        case 1:
          _passwordStrength = 'Weak';
          _passwordStrengthColor = Colors.red;
          break;
        case 2:
        case 3:
          _passwordStrength = 'Moderate';
          _passwordStrengthColor = Colors.orange;
          break;
        case 4:
          _passwordStrength = 'Strong';
          _passwordStrengthColor = Colors.yellow;
          break;
        case 5:
          _passwordStrength = 'Very Strong';
          _passwordStrengthColor = Colors.green;
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
          // Name Field
          TextFormField(
            controller: widget.nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person_outline',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Email Field
          TextFormField(
            controller: widget.emailController,
            // ... (email field is unchanged)
          ),
          SizedBox(height: 3.h),

          // Phone Number Field
          TextFormField(
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your 10-digit phone number',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'phone',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Gender and Age Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: widget.selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Select gender',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'person_search',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  items: genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: widget.onGenderChanged,
                  validator: (value) {
                    if (value == null) return 'Required';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: TextFormField(
                  controller: widget.ageController,
                  // ... (age field is unchanged)
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Address Field
          TextFormField(
            controller: widget.addressController,
            keyboardType: TextInputType.streetAddress,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Address',
              hintText: 'Enter your current address',
              alignLabelWithHint: true,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'home',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // ... (rest of the form fields are unchanged)
          // Password Field
          TextFormField(
            controller: widget.passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
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
                      _isPasswordVisible ? 'visibility' : 'visibility_off',
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
            onChanged: (value) {
              _checkPasswordStrength(value);
            },
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
                Icon(Icons.info_outline,
                    color: _passwordStrengthColor, size: 16),
                SizedBox(width: 1.w),
                Text(
                  'Password Strength: $_passwordStrength',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _passwordStrengthColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],

          // Confirm Password
          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
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
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility'
                      : 'visibility_off',
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
            value: widget.selectedUniversity,
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

          // Academic Year Dropdown
          DropdownButtonFormField<String>(
            value: widget.selectedAcademicYear,
            decoration: InputDecoration(
              labelText: 'Academic Year',
              hintText: 'Select your academic year',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'auto_stories',
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
                return 'Please select your academic year';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Major Dropdown
          DropdownButtonFormField<String>(
            value: widget.selectedMajor,
            decoration: InputDecoration(
              labelText: 'Major',
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
                child: Text(major),
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
          SizedBox(height: 3.h),

          // Terms and Conditions Checkboxes
          ListTile(
            title: Text(
              'I agree to data collection and analysis',
              style: theme.textTheme.bodyMedium,
            ),
            leading: Checkbox(
              value: widget.dataCollectionConsent,
              onChanged: (bool? value) =>
                  widget.onDataCollectionChanged(value ?? false),
            ),
          ),
          ListTile(
            title: Text(
              'I consent to crisis intervention support',
              style: theme.textTheme.bodyMedium,
            ),
            leading: Checkbox(
              value: widget.crisisInterventionConsent,
              onChanged: (bool? value) =>
                  widget.onCrisisInterventionChanged(value ?? false),
            ),
          ),
          ListTile(
            title: Text(
              'I allow emergency contact access',
              style: theme.textTheme.bodyMedium,
            ),
            leading: Checkbox(
              value: widget.emergencyContactConsent,
              onChanged: (bool? value) =>
                  widget.onEmergencyContactChanged(value ?? false),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
