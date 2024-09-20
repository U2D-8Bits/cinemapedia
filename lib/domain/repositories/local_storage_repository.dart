

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageRepository{
  Future<void> toggleFavorite(Movie movie);

  Future<bool> isFavoriteMovie(int movieId);

  Future<List<Movie>> getFavoriteMovies({int limit = 10, offset = 0 });
}