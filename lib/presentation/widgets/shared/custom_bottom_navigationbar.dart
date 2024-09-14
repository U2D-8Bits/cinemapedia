
import 'package:flutter/material.dart';

class BottomNavigationbar extends StatelessWidget {
  const BottomNavigationbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_max_outlined), label: 'Inicio'),
      BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Categorías'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite_outline_outlined), label: 'Favoritos'),
    ]);
  }
}