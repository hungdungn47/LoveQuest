import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxList<ChatUser> matchedUsers = <ChatUser>[].obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Load sample data for testing
    loadMatchedUsers();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void loadMatchedUsers() {
    // Sample data for testing
    matchedUsers.value = [
      ChatUser(
        id: '1',
        name: 'Sarah Johnson',
        profilePicture: null,
        lastMessage: 'Hey, how are you doing?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        isOnline: true,
        unreadCount: 2,
      ),
      ChatUser(
        id: '2',
        name: 'Michael Chen',
        profilePicture: null,
        lastMessage: 'Did you see the new movie?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        isOnline: false,
        unreadCount: 0,
      ),
      ChatUser(
        id: '3',
        name: 'Emily Rodriguez',
        profilePicture: null,
        lastMessage: 'Let\'s meet for coffee!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        isOnline: true,
        unreadCount: 1,
      ),
    ];
  }

  void searchUsers(String query) {
    searchQuery.value = query;
    // TODO: Implement search functionality
  }

  void sendMessage(String message, String userId) {
    if (message.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'currentUserId', // Replace with actual current user ID
      receiverId: userId,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
    );

    messages.add(newMessage);
    messageController.clear();

    // TODO: Send message to backend
  }

  void loadMessages(String userId) {
    // Sample messages for testing
    messages.value = [
      ChatMessage(
        id: '1',
        senderId: userId,
        receiverId: 'currentUserId',
        message: 'Hey, how are you doing?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        senderId: 'currentUserId',
        receiverId: userId,
        message: 'I\'m good, thanks! How about you?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        senderId: userId,
        receiverId: 'currentUserId',
        message: 'Doing great! Want to meet for coffee?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isRead: true,
      ),
    ];
  }
}

class ChatUser {
  final String id;
  final String name;
  final String? profilePicture;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isOnline;
  final int unreadCount;

  ChatUser({
    required this.id,
    required this.name,
    this.profilePicture,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isOnline,
    required this.unreadCount,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });
}
