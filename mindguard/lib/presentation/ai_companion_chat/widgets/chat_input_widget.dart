import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String)? onVoiceMessage;
  final Function(String)? onImageSelected;
  final bool isEnabled;

  const ChatInputWidget({
    super.key,
    required this.onSendMessage,
    this.onVoiceMessage,
    this.onImageSelected,
    this.isEnabled = true,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isRecording = false;
  bool _hasText = false;
  late AnimationController _recordingAnimationController;
  late Animation<double> _recordingAnimation;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);

    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _recordingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _recordingAnimationController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _textController.text.trim().isNotEmpty;
    });
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isNotEmpty && widget.isEnabled) {
      final message = _textController.text.trim();
      _textController.clear();
      setState(() {
        _hasText = false;
      });
      widget.onSendMessage(message);
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_message.m4a');
        setState(() {
          _isRecording = true;
        });
        _recordingAnimationController.repeat(reverse: true);
      } else {
        await Permission.microphone.request();
      }
    } catch (e) {
      // Handle recording error silently
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      _recordingAnimationController.stop();

      if (path != null && widget.onVoiceMessage != null) {
        widget.onVoiceMessage!(path);
      }
    } catch (e) {
      // Handle stop recording error silently
    }
  }

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null && widget.onImageSelected != null) {
        widget.onImageSelected!(image.path);
      }
    } catch (e) {
      // Handle image selection error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              onPressed: widget.isEnabled ? _selectImage : null,
              icon: CustomIconWidget(
                iconName: 'attach_file',
                color: widget.isEnabled
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                size: 6.w,
              ),
              tooltip: 'Attach Image',
            ),

            // Text input field
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 15.h,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Voice/Send button
            GestureDetector(
              onTap: _hasText ? _sendMessage : null,
              onLongPressStart: !_hasText && widget.isEnabled
                  ? (_) => _startRecording()
                  : null,
              onLongPressEnd:
                  !_hasText && _isRecording ? (_) => _stopRecording() : null,
              child: AnimatedBuilder(
                animation: _recordingAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isRecording ? _recordingAnimation.value : 1.0,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: _isRecording
                            ? theme.colorScheme.error
                            : _hasText
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.error
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: _isRecording
                              ? 'stop'
                              : _hasText
                                  ? 'send'
                                  : 'mic',
                          color: _isRecording
                              ? Colors.white
                              : _hasText
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                          size: 6.w,
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
    );
  }
}
