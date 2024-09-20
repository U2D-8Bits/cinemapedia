

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class IsarDatasource extends LocalStorageDatasource{
  @override
  Future<List<Movie>> getFavoriteMovies({int limita = 10, offset = 0}) {
    // TODO: implement getFavoriteMovies
    throw UnimplementedError();
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    // TODO: implement isFavoriteMovie
    throw UnimplementedError();
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    // TODO: implement toggleFavorite
    throw UnimplementedError();
  }

}