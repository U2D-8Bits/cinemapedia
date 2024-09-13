import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider = StateNotifierProvider< MoviesNotifier, List<Movie> >( (ref) {
  
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlayingMovies;
  return MoviesNotifier( fetchMoreMovies: fetchMoreMovies );
});

typedef MovieCallBack = Future<List<Movie>> Function({int page});


class MoviesNotifier extends StateNotifier<List<Movie>>{

  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]);
  
  int currentPage = 0;
  MovieCallBack fetchMoreMovies;

  Future<void> loadNextPage() async {
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }

}