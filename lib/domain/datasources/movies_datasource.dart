import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesDataSource{

  // Peliculas que se encuentran en cartelera
  Future <List<Movie>> getNowPlayingMovies({ int page = 1 });

  Future <List<Movie>> getPopularMovies({ int page = 1 });

  Future <List<Movie>> getTopRatedMovies({ int page = 1});

  Future <List<Movie>> getUpcomingMovies({ int page = 1});


}