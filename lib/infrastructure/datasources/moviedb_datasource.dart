import 'package:cinemapedia/config/constants/environments.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDataSource {
  
  final dio = Dio(
      BaseOptions(baseUrl: 'https://api.themoviedb.org/3', queryParameters: {
    'api_key': Environment.movieDbKey,
    'language': 'es-MX',
  }));

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {

    final response = await dio.get('/movie/now_playing');

    final movieDBResponse = MovieDbResponse.fromJson( response.data );

    final List<Movie> movies = movieDBResponse.results
    .where( (moviedb) => moviedb.posterPath != '' )
    .map( 
      (moviedb) => MovieMapper.movieDBToEntity(moviedb) 
    ).toList();
    
    return movies;
  }
}
