import 'package:love_quest/core/network/dio_client.dart';

class ChatApiService {
  final DioClient _client;
  ChatApiService(this._client);

  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _client.get('/message/conversations', queryParameters: {
        "page": 1,
        "pageSize": 50
      });
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getMessages({required String roomId, required String user2Id}) async {
    try {
      final response = await _client.get('/message', queryParameters: {
        "page": 1,
        "pageSize": 50,
        "roomId": roomId,
        "user2Id": user2Id
      });
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage({required String userId, String title="message", required String body}) async {
    try {
      await _client.post('/firebase', data: {
        "userId": userId,
        "title": title,
        "body": body
      });
    } catch (e) {
      rethrow;
    }
  }
}