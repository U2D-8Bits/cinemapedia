import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class MoviePosterLink extends StatelessWidget {
  
  final Movie? movies;
  const MoviePosterLink({
    super.key, 
    required this.movies
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/home/0/movie/${movies!.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeIn(
          child: Image.network(
            movies!.posterPath,
          ),
        ),
      ),
    );
  }
}