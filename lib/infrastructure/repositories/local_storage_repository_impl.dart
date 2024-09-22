
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);
  
  
  
  @override
  Future<List<Movie>> getFavoriteMovies({int limit = 10, offset = 0}) {
    return datasource.getFavoriteMovies(limit: limit, offset: offset);
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    return datasource.isFavoriteMovie(movieId);
  }

  @override
  Future<bool> toggleFavorite(Movie movie) {
    return datasource.toggleFavorite(movie);
  }
}