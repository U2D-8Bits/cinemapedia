
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorMoviedbRepositoryImpl extends ActorsRepository{
  
  final ActorsDataSource dataSource;
  ActorMoviedbRepositoryImpl(this.dataSource);

  
  @override
  Future<List<Actor>> getActorsByMovieId(String movieId) {
    return dataSource.getActorsByMovie(movieId);
  }

}