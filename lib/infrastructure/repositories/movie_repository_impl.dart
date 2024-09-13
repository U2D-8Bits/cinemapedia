

import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MoviedbRepositoryImpl extends MoviesRepository{
  
  final MoviesDataSource datasource;
  MoviedbRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) {
    return datasource.getNowPlayingMovies(page: page);
  }

}