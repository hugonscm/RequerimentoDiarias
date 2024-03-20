import 'package:flutter/material.dart';

import 'PaginaFavoritos.dart';
import 'PaginaPrincipal.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        height: 60,
        indicatorColor: Colors.red,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
        ],
      ),
      body: <Widget>[
        const PaginaPrincipal(),
        const PaginaFavoritos(),
      ][currentPageIndex],
    );
  }
}