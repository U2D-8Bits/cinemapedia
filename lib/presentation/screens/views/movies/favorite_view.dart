import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({super.key});

  @override
  FavoriteViewState createState() => FavoriteViewState();
}

class FavoriteViewState extends ConsumerState<FavoriteView> {
  
  bool isLastPage = false;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Cargar las películas favoritas al iniciar la vista
    loadNextPage();
  }

  void loadNextPage() async {
    // Evitar cargar más si ya se está en el último page o si ya está cargando
    if( isLoading || isLastPage ) return;
    
    isLoading = true;

    // Llamada a cargar más películas favoritas
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();

    // Controlar estado de loading y de la última página
    isLoading = false;

    if( movies.isEmpty ){
      isLastPage = true;
    }

  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos las películas favoritas en forma de lista
    final favoriteMoviesList = ref.watch(favoriteMoviesProvider).values.toList();


    return Scaffold(
      body: MoviesMasonry(
        loadNextPage: loadNextPage,
        movies: favoriteMoviesList
      ),
    );
  }

  
}
