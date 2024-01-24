import 'package:flutter/material.dart';

class PaginaFavoritos extends StatelessWidget {
  const PaginaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: const Center(
        child: Text('Conteúdo da tela de Favoritos'),
      ),
    );
  }
}