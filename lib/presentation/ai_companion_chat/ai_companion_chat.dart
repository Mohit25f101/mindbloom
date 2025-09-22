import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/quick_suggestions_widget.dart';

class AiCompanionChat extends StatefulWidget {
  const AiCompanionChat({super.key});

  @override
  State<AiCompanionChat> createState() => _AiCompanionChatState();
}

class _AiCompanionChatState extends State<AiCompanionChat>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isAiTyping = false;
  bool _showSuggestions = true;
  late AnimationController _suggestionAnimationController;
  late Animation<double> _suggestionAnimation;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _suggestionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _suggestionAnimation = CurvedAnimation(
      parent: _suggestionAnimationController,
      curve: Curves.easeInOut,
    );
    _suggestionAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _suggestionAnimationController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Add welcome message from AI
    _messages.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content':
          'Hello! I\'m your Mindbloom AI companion. I\'m here to provide emotional support and help you navigate through any challenges you\'re facing. How are you feeling today?',
      'isUser': false,
      'timestamp': DateTime.now(),
      'isTyping': false,
    });
  }

  void _handleSendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _showSuggestions = false;
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': message,
        'isUser': true,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
    });

    _scrollToBottom();
    _simulateAiResponse(message);
  }

  void _simulateAiResponse(String userMessage) {
    setState(() {
      _isAiTyping = true;
      _messages.add({
        'id': 'typing_${DateTime.now().millisecondsSinceEpoch}',
        'content': '',
        'isUser': false,
        'timestamp': DateTime.now(),
        'isTyping': true,
      });
    });

    _scrollToBottom();

    // Simulate AI processing time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAiTyping = false;
          // Remove typing indicator
          _messages.removeWhere((msg) => msg['isTyping'] == true);

          // Add AI response
          _messages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': _generateAiResponse(userMessage),
            'isUser': false,
            'timestamp': DateTime.now(),
            'isTyping': false,
          });
        });
        _scrollToBottom();
        _checkForCrisisKeywords(userMessage);
      }
    });
  }

  String _generateAiResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('anxious') || lowerMessage.contains('anxiety')) {
      return 'I understand you\'re feeling anxious. That\'s completely valid. Let\'s try a quick breathing exercise together. Breathe in for 4 counts, hold for 4, then breathe out for 6. Would you like me to guide you through this?';
    } else if (lowerMessage.contains('stressed') ||
        lowerMessage.contains('stress')) {
      return 'Stress can feel overwhelming, but you\'re taking the right step by reaching out. What\'s the main source of your stress right now? Sometimes talking through it can help us find manageable solutions.';
    } else if (lowerMessage.contains('study') ||
        lowerMessage.contains('exam')) {
      return 'Academic pressure is real and challenging. Here are some study tips that might help: Break tasks into smaller chunks, use the Pomodoro technique (25 min study, 5 min break), and remember that your worth isn\'t defined by grades. What specific study challenge are you facing?';
    } else if (lowerMessage.contains('sleep') ||
        lowerMessage.contains('tired')) {
      return 'Sleep is crucial for mental health. Try establishing a bedtime routine: no screens 1 hour before bed, keep your room cool and dark, and consider some gentle stretching or meditation. What\'s been keeping you awake?';
    } else if (lowerMessage.contains('relax') ||
        lowerMessage.contains('calm')) {
      return 'Let\'s work on relaxation together. Try progressive muscle relaxation: tense and release each muscle group starting from your toes up to your head. I can also guide you through a mindfulness exercise. Which would you prefer?';
    } else if (lowerMessage.contains('sad') ||
        lowerMessage.contains('depressed')) {
      return 'I hear that you\'re going through a difficult time. Your feelings are valid, and it\'s brave of you to share them. While I\'m here to support you, please remember that professional help is available if you need it. What\'s been weighing on your mind lately?';
    } else {
      return 'Thank you for sharing that with me. I\'m here to listen and support you. Can you tell me more about how you\'re feeling right now? Remember, there\'s no judgment here - this is a safe space for you.';
    }
  }

  void _checkForCrisisKeywords(String message) {
    final crisisKeywords = [
      'suicide',
      'kill myself',
      'end it all',
      'hurt myself',
      'self harm',
      'want to die',
      'no point',
      'give up'
    ];

    final lowerMessage = message.toLowerCase();
    bool containsCrisisKeyword =
        crisisKeywords.any((keyword) => lowerMessage.contains(keyword));

    if (containsCrisisKeyword) {
      _showCrisisIntervention();
    }
  }

  void _showCrisisIntervention() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: Theme.of(context).colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            const Text('Crisis Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I\'m concerned about what you\'ve shared. Your safety is important, and help is available.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Crisis Hotlines:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            const Text('• National Suicide Prevention Lifeline: 988'),
            const Text('• Crisis Text Line: Text HOME to 741741'),
            const Text('• Emergency Services: 911'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/crisis-support');
            },
            child: const Text('Get Help Now'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Chat'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleClearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text(
            'Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _showSuggestions = true;
              });
              _initializeChat();
              Navigator.pop(context);
              _suggestionAnimationController.forward();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _handleVoiceMessage(String audioPath) {
    // Simulate voice-to-text conversion
    const transcribedText = "I'm feeling overwhelmed with my studies";
    _handleSendMessage(transcribedText);
  }

  void _handleImageSelected(String imagePath) {
    setState(() {
      _showSuggestions = false;
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': 'I\'ve shared a mood photo with you.',
        'isUser': true,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
    });

    _scrollToBottom();

    // Simulate AI analyzing the image
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'content':
                'Thank you for sharing that image with me. I can see this might be related to how you\'re feeling. Would you like to tell me more about what\'s going on?',
            'isUser': false,
            'timestamp': DateTime.now(),
            'isTyping': false,
          });
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Chat Header
          ChatHeaderWidget(
            onClearChat: _handleClearChat,
            onCrisisResources: () =>
                Navigator.pushNamed(context, '/crisis-support'),
            onSettings: () {
              // Settings functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
            isOnline: true,
          ),

          // Chat Messages
          Expanded(
            child: Stack(
              children: [
                // Messages list
                ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    top: 2.h,
                    bottom: _showSuggestions ? 20.h : 2.h,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ChatMessageWidget(
                      message: message,
                      onLongPress: () {
                        // Long press functionality handled in widget
                      },
                    );
                  },
                ),

                // Quick suggestions overlay
                if (_showSuggestions)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _suggestionAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              0, (1 - _suggestionAnimation.value) * 10.h),
                          child: Opacity(
                            opacity: _suggestionAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor,
                                border: Border(
                                  top: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: QuickSuggestionsWidget(
                                onSuggestionTap: (suggestion) {
                                  _suggestionAnimationController
                                      .reverse()
                                      .then((_) {
                                    _handleSendMessage(suggestion);
                                  });
                                },
                                isVisible: _showSuggestions,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Chat Input
          ChatInputWidget(
            onSendMessage: _handleSendMessage,
            onVoiceMessage: _handleVoiceMessage,
            onImageSelected: _handleImageSelected,
            isEnabled: !_isAiTyping,
          ),
        ],
      ),
    );
  }
}
