import 'dart:convert';

import 'package:love_quest/core/network/dio_client.dart';
import 'package:love_quest/features/schedule/domain/models/game_schedule.dart';

class ScheduleApiService {
  final DioClient _client;
  ScheduleApiService(this._client);

  Future<List<GameSchedule>> getSchedules() async {
    try {
      print('Getting schedules');
      final response = await _client.get('/virtual/schedules', queryParameters: {
        'pageNumber': 1,
        'pageSize': 50
      });

      print('Response data: ${jsonEncode(response.data)}');

      final List<dynamic> items = response.data['data'];
      final res = items.map((item) => GameSchedule.fromJson(item)).toList().cast<GameSchedule>();
      return res;
    } catch (e) {
      print('Error getting schedules: ${e}');
      rethrow;
    }
  }
}
