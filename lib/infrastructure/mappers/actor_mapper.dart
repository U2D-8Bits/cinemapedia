
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorsMapper {

  static Actor castToEntity( Cast castResponse ) => Actor(
    adult: castResponse.adult, 
    gender: castResponse.gender, 
    id: castResponse.id, 
    knownForDepartment:castResponse.knownForDepartment, 
    name:castResponse.name, 
    originalName:castResponse.originalName, 
    popularity:castResponse.popularity, 
    profilePath: castResponse.profilePath != null 
    ? 'https://image.tmdb.org/t/p/w500${castResponse.profilePath}' 
    : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png', 
    castId: castResponse.castId ?? 0, 
    character:castResponse.character, 
    creditId:castResponse.creditId, 
    order: castResponse.order ?? 0,
  );

}