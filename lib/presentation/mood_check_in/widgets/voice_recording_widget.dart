import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceRecordingWidget extends StatefulWidget {
  final Function(String) onVoiceRecorded;

  const VoiceRecordingWidget({
    super.key,
    required this.onVoiceRecorded,
  });

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _recordingPath;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    try {
      if (!await _requestMicrophonePermission()) {
        _showErrorMessage(
            "Microphone permission is required for voice mood logging");
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        _pulseController.repeat();
        _waveController.repeat();
        HapticFeedback.mediumImpact();

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'mood_recording.wav',
          );
        } else {
          final directory = await getTemporaryDirectory();
          final path =
              '${directory.path}/mood_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: path,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _pulseController.stop();
      _waveController.stop();
      _showErrorMessage("Failed to start recording. Please try again.");
    }
  }

  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      _pulseController.stop();
      _waveController.stop();
      HapticFeedback.lightImpact();

      final path = await _audioRecorder.stop();

      if (path != null) {
        setState(() {
          _recordingPath = path;
        });

        // Process the recording at the saved path
        if (_recordingPath != null && _recordingPath!.isNotEmpty) {
          debugPrint('Processing recording at: $_recordingPath');
          // Simulate voice-to-text processing
          await Future.delayed(const Duration(seconds: 2));
        }

        // Mock transcription result
        final mockTranscriptions = [
          "I'm feeling a bit overwhelmed with my studies today",
          "Had a great day, feeling really positive and motivated",
          "Feeling anxious about the upcoming exams",
          "Pretty tired but satisfied with what I accomplished",
          "Excited about the weekend plans with friends",
        ];

        final transcription = mockTranscriptions[
            DateTime.now().millisecond % mockTranscriptions.length];

        widget.onVoiceRecorded(transcription);

        setState(() {
          _isProcessing = false;
        });

        _showSuccessMessage("Voice mood logged successfully!");
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
      _showErrorMessage("Failed to process voice recording. Please try again.");
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'mic',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Text(
                "Voice Mood Logging",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: _isProcessing
                ? null
                : (_isRecording ? _stopRecording : _startRecording),
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseController, _waveController]),
              builder: (context, child) {
                return Container(
                  width: 20.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.2)
                        : AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: _isRecording
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.primary,
                      width:
                          _isRecording ? 2 + (_pulseController.value * 2) : 2,
                    ),
                    boxShadow: _isRecording
                        ? [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.3),
                              blurRadius: 10 + (_pulseController.value * 10),
                              spreadRadius: _pulseController.value * 5,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: _isProcessing
                        ? SizedBox(
                            width: 6.w,
                            height: 6.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          )
                        : CustomIconWidget(
                            iconName: _isRecording ? 'stop' : 'mic',
                            size: 28,
                            color: _isRecording
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.colorScheme.primary,
                          ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _isProcessing
                ? "Processing your voice..."
                : _isRecording
                    ? "Tap to stop recording"
                    : "Tap to start voice mood logging",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
