

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';




class IsarDatasource extends LocalStorageDatasource{

  late Future<Isar> db;

  IsarDatasource(){
    db = openDB();
  }

  Future<Isar> openDB() async {
    
    final dir = await getApplicationDocumentsDirectory();

    if( Isar.instanceNames.isEmpty ){
      return await Isar.open(
        [MovieSchema],
        directory: dir.path,
        inspector: true
      );
    }

    return Future.value(Isar.getInstance());
  }


  @override
  Future<List<Movie>> getFavoriteMovies({int limit = 10, offset = 0}) async {
    
    final isar = await db;

    return isar.movies.where()
    .offset(offset)
    .limit(limit)
    .findAll();

  }

  @override
  Future<bool> isFavoriteMovie(int movieId) async  {
    
    final isar = await db;

    final Movie? movie = await isar.movies
    .filter()
    .idEqualTo(movieId)
    .findFirst();

    return movie != null;

  }

  @override
  Future<bool> toggleFavorite(Movie movie) async {

    final isar = await db;

    final isFavorite = await isar.movies
    .filter()
    .idEqualTo(movie.id)
    .findFirst();

    if( isFavorite != null ){
      // Borrar
      isar.writeTxnSync( () => isar.movies.deleteSync(isFavorite.isarId! ) );
      return Future<bool>.value(false);
    }

    // Guardar
    // isar.writeTxnSync( () => isar.movies.putSync(movie) ); 
    return isar.writeTxnSync( (){
      isar.movies.putSync(movie);
      return Future<bool>.value(true);
    }); 
  }

}