import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);
      return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});




  // ---------------------------------------------------------------------
  // ------------------- Método loadNextPage -----------------------------  
  // ---------------------------------------------------------------------
  Future<List<Movie>> loadNextPage() async {
    final movies =
        await localStorageRepository.getFavoriteMovies(offset: page * 10, limit: 20);
    page++;

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap};
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {

    final bool isMovieInFavorites = await localStorageRepository.toggleFavorite(movie);

    if( isMovieInFavorites ){
      state = {...state, movie.id: movie};
    }else{
      state.remove(movie.id);
      state = {...state};
    }

  }


}
