import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/features/chat/domain/entities/conversation.dart';
import 'package:love_quest/features/chat/presentation/chat_controller.dart';
import 'package:love_quest/features/chat/presentation/chat_conversation_screen.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Kaushan',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: (value) => controller.searchUsers(value),
            ),
          ),
          // Chat list
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = controller.conversations[index];
                  return ChatListItem(
                    conversation: conversation,
                    onTap: () {
                      controller.joinChatRoom(conversation.roomId!);
                      final String otherUserName = getOtherUserName(conversation);
                      Get.to(() => ChatConversationScreen(conversation: conversation, otherUserName: otherUserName, isOnline: true, profilePicture: getOtherUser(conversation).avatar,));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getOtherUserId(ConversationEntity conversation) {
  final authController = Get.find<AuthController>();
  if(conversation.receiver?.id == authController.user.value.id) {
      return conversation.sender!.id ?? 'unknown sender';
  } else {
    return conversation.receiver!.id ?? 'unknown sender';
  }
}

UserEntity getOtherUser(ConversationEntity conversation) {
  final authController = Get.find<AuthController>();
  if(conversation.receiver?.id == authController.user.value.id) {
    return conversation.sender!;
  } else {
    return conversation.receiver!;
  }
}

String getOtherUserName(ConversationEntity conversation) {
  final authController = Get.find<AuthController>();
  if(conversation.receiver?.id == authController.user.value.id) {
    return conversation.sender!.userName ?? 'unknown sender';
  } else {
    return conversation.receiver!.userName ?? 'unknown sender';
  }
}

class ChatListItem extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: getOtherUser(conversation).avatar != null
                  ? ClipOval(
                child: Image.network(
                  getOtherUser(conversation).avatar!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(Icons.person, color: AppColors.primary, size: 30),
            ),

            const SizedBox(width: 16),
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getOtherUserName(conversation),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatTime(conversation.latestCreatedAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         user.lastMessage,
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           color: Colors.grey[600],
                  //         ),
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //     if (user.unreadCount > 0)
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 8,
                  //           vertical: 4,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color: AppColors.primary,
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: Text(
                  //           user.unreadCount.toString(),
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
