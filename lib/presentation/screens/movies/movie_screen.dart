import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {

  static const String routeName = '/movie-screen';  
  final String movieId;


  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Movie ID $movieId'),
      ),
    );
  }
}