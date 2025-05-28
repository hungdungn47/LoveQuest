import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/features/chat/domain/repository/chat_repository.dart';
import '../domain/entities/message.dart';
import '../domain/entities/conversation.dart';

class ChatController extends GetxController {
  final RxList<MessageEntity> messages = <MessageEntity>[].obs;
  final RxList<ConversationEntity> conversations = <ConversationEntity>[].obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController messageController = TextEditingController();

  final SocketService _socketService = SocketService();
  final GlobalController globalController = Get.find<GlobalController>();
  final AuthController authController = Get.find<AuthController>();
  final ChatRepository chatRepository = Get.find<ChatRepository>();
  String? currentRoomId;
  String? chattingWithUserId;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
    _initializeSocket();
  }

  @override
  void onClose() {
    messageController.dispose();
    _socketService.disconnect();
    super.onClose();
  }

  void _initializeSocket() {
    _socketService.connect();

    // Receiving a message
    _socketService.listenToMessages('receiveMessage', (data) {
      final message = MessageEntity.fromJson(data);
      print('Listening to receiveMessage');
      print(message);
      // Add message if in current chat room
      if (message.roomId == currentRoomId) {
        messages.insert(0, message);
      }

      updateConversation(message);
    });

    // Message read status
    _socketService.listenToMessages('messageRead', (data) {
      final messageId = data['messageId'];
      final index = messages.indexWhere((msg) => msg.id == messageId);
      if (index != -1) {
        messages[index] = messages[index].copyWith(
          updatedAt: DateTime.now(),
        );
      }
    });

    // You can handle 'userStatus' if needed
  }

  void loadConversations() async {
    final result = await chatRepository.getConversations();
    if(result is DataSuccess) {
      conversations.value = result.data!;
    }
  }

  void searchUsers(String query) {
    searchQuery.value = query;
    _socketService.sendMessage('searchUsers', {
      'query': query,
      'userId': authController.user.value.id
    });
  }

  void sendMessage(String text, String roomId, String receiverId) async {
    if (text.trim().isEmpty) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();
    final senderId = authController.user.value.id;

    final message = MessageEntity(
      senderId: senderId,
      receiverId: receiverId,
      message: text,
      roomId: roomId,
      createdAt: now,
      updatedAt: now,
    );

    await chatRepository.sendMessage(userId: receiverId, body: message.message!);

    messages.insert(0, message);
    messageController.clear();

    // _socketService.sendMessage('sendMessage', message.toJson());

    // If using Firebase as backup:
    // FirebaseFirestore.instance.collection('messages').doc(messageId).set(message.toJson());

    updateConversation(message);
  }

  void updateConversation(MessageEntity message) {
    final index = conversations.indexWhere((c) => c.roomId == message.roomId);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(
        latestCreatedAt: message.createdAt,
      );
      conversations.sort((a, b) => b.latestCreatedAt!.compareTo(a.latestCreatedAt!));
    } else {
      // conversations.add(ConversationEntity(
      //   roomId: message.roomId,
      //   sender: message.se,
      //   receiverId: message.receiverId,
      //   latestCreatedAt: message.createdAt,
      // ));
    }
  }

  void loadMessages(String roomId, String otherUserId) async {
    currentRoomId = roomId;
    chattingWithUserId = otherUserId;
    messages.clear();

    print('Getting messages');

    _socketService.sendMessage('getMessages', {
      'roomId': roomId,
      'userId': authController.user.value.id,
    });

    final result = await chatRepository.getMessages(roomId: roomId, user2Id: otherUserId);
    if(result is DataSuccess) {
      messages.value = result.data!;
      markMessagesAsRead(otherUserId);
    }
  }

  void markMessagesAsRead(String senderId) {
    final unread = messages.where((m) => m.senderId == senderId).toList();

    for (var msg in unread) {
      _socketService.sendMessage('markAsRead', {
        'messageId': msg.id,
        'userId': authController.user.value.id
      });
    }
  }

  void joinChatRoom(String roomId) {
    _socketService.sendMessage('joinRoom', roomId);
  }
}
