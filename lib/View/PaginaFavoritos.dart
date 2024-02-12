import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      body: DadosListView(),
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
        itemCount: listaDeDados!.length,
        itemBuilder: (context, index) {
          var dado = listaDeDados![index];
          Color? backgroundColor =
              index % 2 == 0 ? Colors.white : Colors.grey[300];

          return Container(
            color: backgroundColor,
            child: ListTile(
              title: Text(dado.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Matrícula: ${dado.matricula}'),
                  Text(
                      'Inicio: ${DateFormat('dd/MM/yyyy').format(dado.inicioPeriodo)}, Fim: ${DateFormat('dd/MM/yyyy').format(dado.fimPeriodo)}')
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaDetalhes(dados: dado)),
                ).then((value) => _getDados());
              },
            ),
          );
        },
      ),
    );
  }
}
