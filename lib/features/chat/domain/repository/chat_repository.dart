import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/features/chat/domain/entities/conversation.dart';
import 'package:love_quest/features/chat/domain/entities/message.dart';

abstract interface class ChatRepository {
  Future<DataState<List<ConversationEntity>>> getConversations();
  Future<DataState<List<ConversationEntity>>> getConversationsByName(String name, int pageNumber, int pageSize);
  Future<DataState<List<MessageEntity>>> getMessages({required String roomId, required String user2Id});
  Future<void> sendMessage({required String userId, String title, required String body});
}