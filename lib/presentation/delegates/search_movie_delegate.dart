import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallBack searchMovies;

  SearchMovieDelegate({
    required this.searchMovies,
  });

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
          animate: query.isNotEmpty,
          duration: const Duration(milliseconds: 300),
          child: IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.clear))),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: searchMovies(query),
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _MovieItem(
                movie: movies[index],
                onMovieSelected: close,
              );
            },
          );
        });
  }
}


class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
        child: Row(
          children: [
      
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress != null ) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2,),
                      );
                    }
      
                    return child;
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyle.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie.overview,
                    style: textStyle.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon( Icons.star_half_outlined, color: Colors.yellow.shade800, size: 20,),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyle.bodySmall!.copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),  
      ),
    );
  }
}
