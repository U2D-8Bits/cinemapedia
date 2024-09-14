import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getMessages() {
    final messages = <String>[
      'Cargando películas',
      'Comprando palomitas',
      'Cargando películas populares',
      'Ya estamos a punto de empezar',
      'Cargando películas mejor valoradas',
      'Cargando películas próximas',
      'Preparando los guiones de los actores',
      'Rellenando los vaso de refresco',
      'Limpiando las salas de cine',
    ];

    return Stream.periodic(const Duration(seconds: 2), (int index) {
      return messages[index];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere porfavor...'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(
            strokeWidth: 2,
          ),
          StreamBuilder(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Cargando...');

                return Text(snapshot.data!);
              })
        ],
      ),
    );
  }
}
