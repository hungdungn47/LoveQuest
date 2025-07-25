import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/features/chat/data/datasources/chat_api_service.dart';
import 'package:love_quest/features/chat/domain/entities/conversation.dart';
import 'package:love_quest/features/chat/domain/entities/message.dart';
import 'package:love_quest/features/chat/domain/repository/chat_repository.dart';
import 'package:logger/logger.dart';
class ChatRepositoryImpl implements ChatRepository {
  final ChatApiService _chatApiService;
  final Logger logger = Logger();
  ChatRepositoryImpl(this._chatApiService);
  @override
  Future<DataState<List<ConversationEntity>>> getConversations() async {
    try {
      List<dynamic> data = await _chatApiService.getConversations();
      List<ConversationEntity> conversationList = data.map((json) {
        return ConversationEntity.fromJson(json);
      }).toList();
      for(var conversation in conversationList) {
        logger.i('Message from ${conversation.sender?.userName} and to ${conversation.receiver?.userName}');
      }
      return DataSuccess(conversationList);
    } catch (e) {
      return DataFailed(Exception('Error getting conversation: $e'));
    }
  }

  @override
  Future<DataState<List<ConversationEntity>>> getConversationsByName(String name, int pageNumber, int pageSize) async {
    try {
      List<dynamic> data = await _chatApiService.getConversationsByName(name, pageNumber, pageSize);
      List<ConversationEntity> conversationList = data.map((json) {
        return ConversationEntity.fromJson(json);
      }).toList();
      for(var conversation in conversationList) {
        logger.i('Message from ${conversation.sender?.userName} and to ${conversation.receiver?.userName}');
      }
      return DataSuccess(conversationList);
    } catch (e) {
      return DataFailed(Exception('Error getting conversation: $e'));
    }
  }

  @override
  Future<DataState<List<MessageEntity>>> getMessages({required String roomId, required String user2Id}) async {
    try {
      List<dynamic> data = await _chatApiService.getMessages(roomId: roomId, user2Id: user2Id);
      List<MessageEntity> messageList = data.map((json) {
        return MessageEntity.fromJson(json);
      }).toList();
      return DataSuccess(messageList);
    } catch (e) {
      return DataFailed(Exception('Error getting messages: $e'));
    }
  }

  @override
  Future<void> sendMessage({required String userId, String title="message", required String body}) async {
    try {
      await _chatApiService.sendMessage(userId: userId, body: body);
    } catch (e) {
      return;
    }
  }

}