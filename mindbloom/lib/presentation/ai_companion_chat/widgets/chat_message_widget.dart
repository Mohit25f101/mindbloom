import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback? onLongPress;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message['isUser'] as bool;
    final content = message['content'] as String;
    final timestamp = message['timestamp'] as DateTime;
    final isTyping = message['isTyping'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.h,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 2.5.w,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'psychology',
                color: theme.colorScheme.primary,
                size: 4.w,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                _showMessageOptions(context, content);
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 75.w,
                  minWidth: 20.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isUser
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft:
                        isUser ? Radius.circular(4.w) : Radius.circular(1.w),
                    bottomRight:
                        isUser ? Radius.circular(1.w) : Radius.circular(4.w),
                  ),
                  border: !isUser
                      ? Border.all(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isTyping)
                      _buildTypingIndicator(theme)
                    else
                      Text(
                        content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isUser
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    SizedBox(height: 1.h),
                    Text(
                      _formatTime(timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.7)
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 2.5.w,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'person',
                color: theme.colorScheme.primary,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'AI is typing',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 2.w),
        SizedBox(
          width: 6.w,
          height: 2.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 600 + (index * 200)),
                curve: Curves.easeInOut,
                width: 1.w,
                height: 1.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showMessageOptions(BuildContext context, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: Theme.of(context).colorScheme.onSurface,
                size: 6.w,
              ),
              title: const Text('Copy Message'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: content));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.onSurface,
                size: 6.w,
              ),
              title: const Text('Share Message'),
              onTap: () {
                Navigator.pop(context);
                // Share functionality would be implemented here
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'flag',
                color: Theme.of(context).colorScheme.error,
                size: 6.w,
              ),
              title: const Text('Flag Inappropriate'),
              onTap: () {
                Navigator.pop(context);
                // Flag functionality would be implemented here
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
