import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {

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
                onPressed: (){
                  showSearch(
                    context: context, 
                    delegate: SearchMovieDelegate()
                  );
                }, icon: Icon( Icons.search_outlined, color: colors.primary ),
              )
            ],
          ),
        ), 
      ) 
    );
  }
}