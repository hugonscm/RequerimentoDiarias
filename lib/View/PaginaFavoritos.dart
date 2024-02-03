import 'package:flutter/material.dart';

import '../model/Dados.dart';
import 'PaginaDetalhes.dart';

class PaginaFavoritos extends StatelessWidget {
  const PaginaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: DadosListView(
        listaDeDados: [
          Dados(
            matricula: 4,
            nome: 'Adalberto',
            cargo: 'Analista',
            sigla: 'ASD',
            setorLotacao: 'RH',
            inicioPeriodo: '2023-01-01',
            fimPeriodo: '2023-01-05',
            qtdeDias: 5,
            valorDiarias: 100.0,
            finalidade: 'Viagem de trabalho',
            roteiro: 'Roteiro A',
          ),
          Dados(
            matricula: 6,
            nome: 'Carlos Santos 3',
            cargo: 'Programador',
            sigla: 'ABC',
            setorLotacao: 'TI',
            inicioPeriodo: '2023-01-01',
            fimPeriodo: '2023-01-05',
            qtdeDias: 5,
            valorDiarias: 100.0,
            finalidade: 'Viagem de trabalho',
            roteiro: 'Roteiro A',
          ),
        ],
      ),
    );
  }
}

class DadosListView extends StatelessWidget {
  final List<Dados>? listaDeDados;

  const DadosListView({Key? key, required this.listaDeDados}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: listaDeDados?.length ?? 0,
        itemBuilder: (context, index) {
          var dado = listaDeDados?[index];
          Color? backgroundColor =
              index % 2 == 0 ? Colors.white : Colors.grey[300];

          return Container(
            color: backgroundColor,
            child: ListTile(
              title: Text(dado!.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Matrícula: ${dado.matricula}'),
                  Text('Inicio: ${dado.inicioPeriodo}, Fim: ${dado.fimPeriodo}')
                ],
              ),
              onTap: () {
                // Navegar para a tela de detalhes
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaDetalhes(dados: dado),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
