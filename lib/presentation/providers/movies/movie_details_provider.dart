import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieDetailsProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie> >( (ref) {

  final getMovieProvider = ref.watch( movieRepositoryProvider );
    return MovieMapNotifier( getMovie: getMovieProvider.getMovieById );
});



typedef GetMovieCallBack = Future<Movie> Function(String id);

class MovieMapNotifier extends StateNotifier<Map<String,Movie>>{

  final GetMovieCallBack getMovie;


  MovieMapNotifier({
    required this.getMovie
  }) : super({});

  Future<void> loadMovie( String movieId ) async{
 
    if( state[ movieId ] != null ) return;
    final movieRecived = await getMovie(movieId); 

    state = { ...state, movieId: movieRecived };

  }

}