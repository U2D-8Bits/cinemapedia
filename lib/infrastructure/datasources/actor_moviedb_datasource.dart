import 'package:cinemapedia/config/constants/environments.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasource extends ActorsDataSource {
  final dio = Dio(
      BaseOptions(baseUrl: 'https://api.themoviedb.org/3', queryParameters: {
    'api_key': Environment.movieDbKey,
    'language': 'es-MX',
  }));

  List<Actor> returnActorsList(Response<dynamic> response) {
    
    final actorsMoviedbResponse = CreditsResponse.fromJson(response.data);

    final List<Actor> actors = actorsMoviedbResponse.cast
        .where((actor) => actor.profilePath != '')
        .map((actor) => ActorsMapper.castToEntity(actor))
        .toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieID) async {
    final response = await dio.get('/movie/$movieID/credits');

    return returnActorsList(response);
  }
}
