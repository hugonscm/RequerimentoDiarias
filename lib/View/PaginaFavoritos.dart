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
        itemCount: listaDeDados?.length ?? 0,
        itemBuilder: (context, index) {
          var dado = listaDeDados?[index];
          Color? backgroundColor =
              index % 2 == 0 ? Colors.grey[300] : Colors.white;

          return Card(
            color: backgroundColor,
            child: InkWell(
              //adicionar a animação de toque
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaDetalhes(dados: dado)),
                ).then((value) => _getDados());
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dado!.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('MATRÍCULA: ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text('${dado.matricula}')
                      ],
                    ),
                    Row(
                      children: [
                        const Text('ROTEIRO: ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(dado.roteiro),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('INÍCIO: ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(DateFormat('dd/MM/yyyy')
                            .format(dado.inicioPeriodo)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('FIM: ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(DateFormat('dd/MM/yyyy')
                            .format(dado.fimPeriodo)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
