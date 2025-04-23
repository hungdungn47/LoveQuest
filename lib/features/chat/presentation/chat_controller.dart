import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:love_quest/core/socket/socket_service.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxList<ChatUser> matchedUsers = <ChatUser>[].obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController messageController = TextEditingController();

  final SocketService _socketService = SocketService();

  String? currentChatUserId;

  @override
  void onInit() {
    super.onInit();
    // Load sample data for testing
    loadMatchedUsers();
    _initializeSocket();
  }

  @override
  void onClose() {
    messageController.dispose();
    _socketService.disconnect();
    super.onClose();
  }

  void _initializeSocket() {
    // Connect to socket server
    _socketService.connect();

    // Listen for incoming messages
    _socketService.listenToMessages('receiveMessage', (data) {
      final message = ChatMessage(
        id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: data['senderId'],
        receiverId: data['receiverId'],
        message: data['message'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            data['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
        isRead: false,
      );

      // Only add to messages if this is for the current chat
      if (currentChatUserId != null &&
          (message.senderId == currentChatUserId ||
              message.receiverId == currentChatUserId)) {
        // Insert at beginning for reverse: true ListView
        messages.insert(0, message); // Changed from messages.add()
      }

      // Update the matched user's last message
      updateUserLastMessage(message);
    });

    // Listen for message read status updates
    _socketService.listenToMessages('messageRead', (data) {
      final messageId = data['messageId'];
      final index = messages.indexWhere((msg) => msg.id == messageId);
      if (index != -1) {
        final updatedMessage = ChatMessage(
          id: messages[index].id,
          senderId: messages[index].senderId,
          receiverId: messages[index].receiverId,
          message: messages[index].message,
          timestamp: messages[index].timestamp,
          isRead: true,
        );
        messages[index] = updatedMessage;
      }
    });

    // Listen for user online status updates
    _socketService.listenToMessages('userStatus', (data) {
      final userId = data['userId'];
      final isOnline = data['isOnline'] ?? false;

      final index = matchedUsers.indexWhere((user) => user.id == userId);
      if (index != -1) {
        final updatedUser = ChatUser(
          id: matchedUsers[index].id,
          name: matchedUsers[index].name,
          profilePicture: matchedUsers[index].profilePicture,
          lastMessage: matchedUsers[index].lastMessage,
          lastMessageTime: matchedUsers[index].lastMessageTime,
          isOnline: isOnline,
          unreadCount: matchedUsers[index].unreadCount,
        );
        matchedUsers[index] = updatedUser;
      }
    });
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

    // Send search query to server
    _socketService.sendMessage('searchUsers', {
      'query': query,
      'userId': 'currentUserId', // Replace with actual current user ID
    });
  }

  void sendMessage(String message, String userId) {
    if (message.trim().isEmpty) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = DateTime.now();

    final newMessage = ChatMessage(
      id: messageId,
      senderId: 'currentUserId', // Replace with actual current user ID
      receiverId: userId,
      message: message,
      timestamp: timestamp,
      isRead: false,
    );

    // Add to local messages list at the beginning for reverse: true ListView
    messages.insert(0, newMessage); // Changed from messages.add()
    messageController.clear();

    // Send to socket server
    _socketService.sendMessage('sendMessage', {
      'id': messageId,
      'senderId': 'currentUserId', // Replace with actual current user ID
      'receiverId': userId,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
    });

    // Also update the matched user's last message
    updateUserLastMessage(newMessage);
  }

  void updateUserLastMessage(ChatMessage message) {
    String userId = message.senderId == 'currentUserId'
        ? message.receiverId
        : message.senderId;

    final index = matchedUsers.indexWhere((user) => user.id == userId);
    if (index != -1) {
      final updatedUser = ChatUser(
        id: matchedUsers[index].id,
        name: matchedUsers[index].name,
        profilePicture: matchedUsers[index].profilePicture,
        lastMessage: message.message,
        lastMessageTime: message.timestamp,
        isOnline: matchedUsers[index].isOnline,
        unreadCount: message.senderId != 'currentUserId' && !message.isRead
            ? matchedUsers[index].unreadCount + 1
            : matchedUsers[index].unreadCount,
      );
      matchedUsers[index] = updatedUser;

      // Sort matched users by last message time
      matchedUsers
          .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    }
  }

  void loadMessages(String userId) {
    // Clear existing messages first to prevent duplicates
    messages.clear();

    // Store the current chat user ID
    currentChatUserId = userId;

    // Request messages from server
    _socketService.sendMessage('getMessages', {
      'userId': 'currentUserId', // Replace with actual current user ID
      'otherUserId': userId,
    });

    // Sample messages for testing
    final List<ChatMessage> tmpMessages = [
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

    // Sort messages by timestamp from newest to oldest for reverse ListView
    tmpMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    Future.microtask(() {
      messages.value = tmpMessages;
    });

    // Mark messages as read
    markMessagesAsRead(userId);
  }

  void markMessagesAsRead(String senderId) {
    // Find unread messages from this sender
    final unreadMessages = messages
        .where((msg) => msg.senderId == senderId && !msg.isRead)
        .toList();

    // Mark as read locally
    for (var i = 0; i < messages.length; i++) {
      if (messages[i].senderId == senderId && !messages[i].isRead) {
        final updatedMessage = ChatMessage(
          id: messages[i].id,
          senderId: messages[i].senderId,
          receiverId: messages[i].receiverId,
          message: messages[i].message,
          timestamp: messages[i].timestamp,
          isRead: true,
        );
        messages[i] = updatedMessage;
      }
    }

    // Send read status to server
    for (final msg in unreadMessages) {
      _socketService.sendMessage('markAsRead', {
        'messageId': msg.id,
        'userId': 'currentUserId', // Replace with actual current user ID
      });
    }

    // Update unread count for the user
    final index = matchedUsers.indexWhere((user) => user.id == senderId);
    if (index != -1) {
      final updatedUser = ChatUser(
        id: matchedUsers[index].id,
        name: matchedUsers[index].name,
        profilePicture: matchedUsers[index].profilePicture,
        lastMessage: matchedUsers[index].lastMessage,
        lastMessageTime: matchedUsers[index].lastMessageTime,
        isOnline: matchedUsers[index].isOnline,
        unreadCount: 0, // Reset unread count
      );
      matchedUsers[index] = updatedUser;
    }
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
