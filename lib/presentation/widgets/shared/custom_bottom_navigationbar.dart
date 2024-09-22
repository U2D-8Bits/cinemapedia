import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationbar extends StatelessWidget {
  final int currentIndex;
  const BottomNavigationbar({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index){

    switch(index){
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int value) {
          onItemTapped(context, value);
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_max_outlined), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium_rounded), label: 'Populares'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_outlined), label: 'Favoritos'),
        ]);
  }
}
