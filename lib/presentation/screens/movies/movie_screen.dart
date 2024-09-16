import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const String routeName = '/movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieDetailsProvider.notifier).loadMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailsProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final sizePhone = MediaQuery.of(context).size;

    return SliverAppBar(
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      backgroundColor: Colors.black,
      expandedHeight: sizePhone.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            movie.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          background: _CustomStackAppBar(movie: movie)),
    );
  }
}

class _CustomStackAppBar extends StatelessWidget {
  const _CustomStackAppBar({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.network(
            movie.posterPath,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox.expand(
          child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1.0],
                      colors: [Colors.transparent, Colors.black54]))),
        ),
        const SizedBox.expand(
          child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, stops: [
            0.0,
            0.4
          ], colors: [
            Colors.black54,
            Colors.transparent,
          ]))),
        )
      ],
    );
  }
}

class _MovieDetails extends StatefulWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  State<_MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<_MovieDetails> {
  bool _showFullText = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la Pelicula
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.movie.posterPath,
                  height: size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),

              // Titulo de la Película y su descripción
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Text(
                        widget.movie.title,
                        style: textStyles.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      AnimatedCrossFade(
                        firstChild: Text(
                          widget.movie.overview,
                          style: textStyles.bodyMedium,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                        secondChild: Text(
                          widget.movie.overview,
                          style: textStyles.bodyMedium,
                          textAlign: TextAlign.justify,
                        ),
                        crossFadeState: _showFullText
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFullText = !_showFullText;
                          });
                        },
                        child: Text(
                          _showFullText ? 'Ver menos' : 'Ver más',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Detalles de la Película
        const SizedBox(height: 10),
        // Catergorias
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton.tonal(
                onPressed: (){}, 
                child: const Text('Categorías')
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for ( final genre in widget.movie.genreIds)
                    Chip(
                      label: Text(genre),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Actores
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              FilledButton.tonal(onPressed: (){}, child: const Text('Actores')),
            ],
          ),
        ),

        const SizedBox(height: 250),
      ],
    );
  }
}
