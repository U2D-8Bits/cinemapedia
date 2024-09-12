import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDataSource{

  // Peliculas que se encuentran en cartelera
  Future <List<Movie>> getNowPlayingMovies({ int page = 1 });


}