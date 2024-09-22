import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoviesMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MoviesMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {

  final scrollController = ScrollController();

  // todo: Implementar el InitState
  @override
  void initState() {
    super.initState();

    // Listener para detectar cuando estamos cerca del final del scroll
    scrollController.addListener( (){
      if (widget.loadNextPage == null) return;

      // Detectar si estamos cerca del final del scroll (a 300 píxeles)
      if(scrollController.position.pixels + 300 >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }
    });
  }

  // todo: Implementar el dispose
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 40),
                MoviePosterLink(movies: widget.movies[index])
              ],
            );
          }

          return MoviePosterLink(movies: widget.movies[index]);
        },
      ),
    );
  }
}
