import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/searchs/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../delegates/search_movie_delegate.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0 ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon( Icons.movie_outlined, color: colors.primary ,),
              const SizedBox(width: 5.0),
              Text( 'CheckMovies', style: textTheme ),
              const Spacer(),
              IconButton(

                onPressed: () {
                  final searchMoives = ref.read( searchMoviesProvider );
                  final searchQuery = ref.read( searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context, 
                    delegate: SearchMovieDelegate( 
                      initialMovies: searchMoives,
                      searchMovies: ref.read( searchMoviesProvider.notifier ).searchMovieByQuery,
                    )
                  ).then((movie){

                    if(movie == null) return;
                    // ignore: use_build_context_synchronously
                    context.push('/movie/${movie.id}');
                  });
                  

                  
                  
                }, icon: Icon( Icons.search_outlined, color: colors.primary ),
              )
            ],
          ),
        ), 
      ) 
    );
  }
}