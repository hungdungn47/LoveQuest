import 'package:love_quest/features/film_choosing/entity/film.dart';
import 'package:love_quest/features/film_choosing/services/filmChoosingService.dart';

import '../../../core/network/dio_client.dart';

class FilmChoosingServiceImp implements IFilmChoosingService {
  final DioClient _client;
  FilmChoosingServiceImp(this._client);

  @override
  Future<List<Film>> getFilmByType(String type) async {
    try {
      final response = await _client.get('/films',
          queryParameters: {"pageNumber": 1, "pageSize": 10, "type": type});
      final data = response.data[0];
      final List<dynamic> filmData = data["films"];
      print("Films Data la gi ${data}");
      print("Films la gi ${filmData}");
      return filmData.map((e) => Film.fromJson(e)).toList();
    } catch (e) {
      print('Error when fetching films $e');
      return [];
    }
  }

  @override
  Future<List<Film>> getTopsFilm() async {
    try {
      final response = await _client.get('/films/top');
      final List<dynamic> data = response.data;
      return data.map((e) => Film.fromJson(e)).toList();
    } catch (e) {
      print('Error when fetching films $e');
      return [];
    }
  }

  @override
  Future<List<String>> getTypeOfFilm() async {
    try {
      final response = await _client.get('/films/type');
      final List<dynamic> data = response.data;
      return data.cast<String>();
    } catch (e) {
      print('Error when fetching types of film ${e}');
      return [];
    }
  }
}
