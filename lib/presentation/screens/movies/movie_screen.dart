import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';

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
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
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

// --------------------------------------------------------------------------
// -------------------------- AppBar Personalizado --------------------------
// --------------------------------------------------------------------------


final isFavoriteProvider = FutureProvider.family.autoDispose( (ref, int movieId){
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isFavoriteMovie(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final sizePhone = MediaQuery.of(context).size;

    return SliverAppBar(
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite_outlined, color: Colors.red)
                : const Icon(Icons.favorite_border_outlined, color: Colors.white),
            error: (error, _) => const Icon(Icons.favorite_border_outlined, color: Colors.white),
            ),
        ),
      ],
      backgroundColor: Colors.black,
      expandedHeight: sizePhone.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace:
          FlexibleSpaceBar(background: _CustomStackAppBar(movie: movie)),
    );
  }
}

// --------------------------------------------------------------------------
// -------------------------- Stack Personalizado ---------------------------
// --------------------------------------------------------------------------
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
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) return const SizedBox();

              return FadeIn(child: child);
            },
          ),
        ),
        const _CustomGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          x: 0.65,
          y: 1.0,
          colorOne: Colors.transparent,
          colorTwo: Colors.black54,
        ),
        const _CustomGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.bottomCenter,
          x: 0.7,
          y: 1.0,
          colorOne: Colors.transparent,
          colorTwo: Colors.black45,
        ),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// -------------------------- Detalles de la Película ------------------------
// --------------------------------------------------------------------------
class _MovieDetails extends StatefulWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  // ignore: no_logic_in_create_state
  State<_MovieDetails> createState() =>
      _MovieDetailsState(movieId: movie.id.toString());
}

class _MovieDetailsState extends State<_MovieDetails> {
  bool _showFullText = false;
  final String movieId;

  _MovieDetailsState({required this.movieId});

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
                  onPressed: () {}, child: const Text('Categorías')),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final genre in widget.movie.genreIds)
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
              FilledButton.tonal(
                  onPressed: () {}, child: const Text('Actores')),
            ],
          ),
        ),
        _ActorsByMovie(movieId: movieId),
        const SizedBox(height: 20),
      ],
    );
  }
}


// --------------------------------------------------------------------------
// -------------------------- Actores por Película --------------------------
// --------------------------------------------------------------------------
class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorByMovie = ref.watch(actorsByMovieProvider);

    if (actorByMovie[movieId] == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    final actors = actorByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: FadeInRight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Actor Photo con desplazamiento horizontal
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Nombre del Actor
                  Text(
                    actor.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  // Personaje del Actor
                  Text(
                    actor.character ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



// --------------------------------------------------------------------------
// -------------------------- Gradiente Personalizado -----------------------
// --------------------------------------------------------------------------
class _CustomGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final double x;
  final double y;
  final Color colorOne;
  final Color colorTwo;

  const _CustomGradient({
      required this.begin,
      required this.end, 
      required this.x, 
      required this.y, required this.colorOne, required this.colorTwo,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin,
                  end: Alignment.topCenter,
                  stops: [x, y],
                  colors: [colorOne, colorTwo]))),
    );
  }
}
