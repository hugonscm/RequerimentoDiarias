import 'package:card_tjsp/card_tjsp.dart';
import 'package:flutter/material.dart';

import '../db/DatabaseFavoritos.dart';
import '../model/Dados.dart';
import 'PaginaDetalhes.dart';

class PaginaFavoritos extends StatelessWidget {
  const PaginaFavoritos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: const DadosListView(),
    );
  }
}

class DadosListView extends StatefulWidget {
  const DadosListView({super.key});

  @override
  _DadosListViewState createState() => _DadosListViewState();
}

class _DadosListViewState extends State<DadosListView> {
  List<Dados>? listaDeDados;

  @override
  void initState() {
    super.initState();
    _getDados();
  }

  Future<void> _getDados() async {
    final dbFavoritos = DBFavoritos.instance;
    List<Dados> dados = await dbFavoritos.getDados();
    await dbFavoritos.close();
    setState(() {
      listaDeDados = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listaDeDados == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: listaDeDados?.length ?? 0,
        itemBuilder: (context, index) {
          var dado = listaDeDados?[index];
          Color? backgroundColor =
          index % 2 == 0 ? Colors.grey[300] : Colors.white;

          return Card(
            child: InkWell(
              //adicionar a animação de toque
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaDetalhes(dados: dado)),
                ).then((value) => _getDados());
              },
              child: CardTjsp(dado!.nome, dado.cargo, dado.matricula.toString(), dado.roteiro, dado.qtdeDias.toString(), backgroundColor)
            ),
          );
        },
      ),
    );
  }
}