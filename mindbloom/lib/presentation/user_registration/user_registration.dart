import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/mindbloom_logo_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/terms_privacy_widget.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedUniversity;
  String? _selectedAcademicYear;
  String? _selectedMajor;
  bool _dataCollectionConsent = false;
  bool _crisisInterventionConsent = false;
  bool _emergencyContactConsent = false;
  bool _isLoading = false;
  bool _showSuccessAnimation = false;

  late AnimationController _successAnimationController;
  late Animation<double> _successScaleAnimation;
  late Animation<double> _successOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _successScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    ));

    _successOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true &&
        _dataCollectionConsent &&
        _crisisInterventionConsent &&
        _emergencyContactConsent;
  }

  Future<void> _createAccount() async {
    if (!_isFormValid()) {
      _showErrorMessage(
          'Please complete all required fields and accept the consent agreements.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate account creation process
      await Future.delayed(const Duration(seconds: 2));

      // Mock account creation logic - validation only for now
      if (_selectedUniversity == null ||
          _selectedAcademicYear == null ||
          _selectedMajor == null) {
        throw Exception('Please complete all required fields.');
      }

      // Check for duplicate email (mock validation)
      if (_emailController.text.trim().toLowerCase() == 'test@university.edu') {
        throw Exception(
            'An account with this email already exists. Please use a different email address.');
      }

      // Validate password strength
      if (_passwordController.text.length < 8) {
        throw Exception(
            'Password must be at least 8 characters long with mixed case letters, numbers, and symbols.');
      }

      // Success - show animation
      setState(() {
        _isLoading = false;
        _showSuccessAnimation = true;
      });

      _successAnimationController.forward();

      // Navigate to dashboard after animation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _successAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _successOpacityAnimation.value,
          child: Transform.scale(
            scale: _successScaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 20.0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 10.w,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Welcome to Mindbloom!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Your account has been created successfully. Let\'s begin your mental wellness journey together.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // Back button
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: CustomIconWidget(
                            iconName: 'arrow_back_ios',
                            color: colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Mindbloom Logo
                    const MindbloomLogoWidget(showText: true),

                    SizedBox(height: 4.h),

                    // Welcome text
                    Text(
                      'Create Your Account',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Join thousands of students taking control of their mental wellness',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 4.h),

                    // Registration Form
                    RegistrationFormWidget(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      ageController: _ageController,
                      selectedUniversity: _selectedUniversity,
                      selectedAcademicYear: _selectedAcademicYear,
                      selectedMajor: _selectedMajor,
                      dataCollectionConsent: _dataCollectionConsent,
                      crisisInterventionConsent: _crisisInterventionConsent,
                      emergencyContactConsent: _emergencyContactConsent,
                      onUniversityChanged: (value) {
                        setState(() {
                          _selectedUniversity = value;
                        });
                      },
                      onAcademicYearChanged: (value) {
                        setState(() {
                          _selectedAcademicYear = value;
                        });
                      },
                      onMajorChanged: (value) {
                        setState(() {
                          _selectedMajor = value;
                        });
                      },
                      onDataCollectionChanged: (value) {
                        setState(() {
                          _dataCollectionConsent = value;
                        });
                      },
                      onCrisisInterventionChanged: (value) {
                        setState(() {
                          _crisisInterventionConsent = value;
                        });
                      },
                      onEmergencyContactChanged: (value) {
                        setState(() {
                          _emergencyContactConsent = value;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: _isFormValid() && !_isLoading
                            ? _createAccount
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid()
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.12),
                          foregroundColor: _isFormValid()
                              ? Colors.white
                              : colorScheme.onSurface.withValues(alpha: 0.38),
                          elevation: _isFormValid() ? 2.0 : 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Create Account',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _isFormValid()
                                      ? Colors.white
                                      : colorScheme.onSurface
                                          .withValues(alpha: 0.38),
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Terms and Privacy
                    const TermsPrivacyWidget(),

                    SizedBox(height: 2.h),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Sign In',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),

          // Success Animation Overlay
          if (_showSuccessAnimation)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: _buildSuccessAnimation(),
              ),
            ),
        ],
      ),
    );
  }
}
