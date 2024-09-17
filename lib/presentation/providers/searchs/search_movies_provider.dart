
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>( (ref) => '' );



final searchMoviesProvider = StateNotifierProvider<SearchMoviesNotifier, List<Movie>>( (ref){

    final movieRepository = ref.read(movieRepositoryProvider);

    return SearchMoviesNotifier(
      searchMoviesBQ: movieRepository.searchMovies,
      ref: ref,
    );

});

typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>>{

  final SearchMoviesCallBack searchMoviesBQ;
  final Ref ref;

  SearchMoviesNotifier({
    required this.searchMoviesBQ,
    required this.ref,
  }) : super([]);


  Future<List<Movie>> searchMovieByQuery(String query) async {

    final List<Movie> movies = await searchMoviesBQ(query);  
    ref.read(searchQueryProvider.notifier).update( (state) => query ); 
    state = movies;
    return movies;
  }
}