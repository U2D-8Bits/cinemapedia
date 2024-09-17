import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesRepository {
  // Peliculas que se encuentran en cartelera
  Future<List<Movie>> getNowPlayingMovies({int page = 1});

  Future<List<Movie>> getPopularMovies({int page = 1});

  Future<List<Movie>> getTopRatedMovies({int page = 1});

  Future<List<Movie>> getUpcomingMovies({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Movie>> searchMovies(String query);
}
