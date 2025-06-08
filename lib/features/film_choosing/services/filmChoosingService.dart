import '../entity/film.dart';

abstract class IFilmChoosingService {
  Future<List<String>> getTypeOfFilm();
  Future<List<Film>> getTopsFilm();
  Future<List<Film>> getFilmByType(String type);
}