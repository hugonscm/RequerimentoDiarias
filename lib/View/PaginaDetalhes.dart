import 'package:flutter/material.dart';

import '../model/Dados.dart';

class PaginaDetalhes extends StatelessWidget {
  final Dados dados;

  const PaginaDetalhes({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes'),
        ),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: IntrinsicHeight( //usado para o container pegar a altura dos itens
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Matrícula: ${dados.matricula}', style: const TextStyle(fontSize: 16)),
                        Text('Nome: ${dados.nome}', style: const TextStyle(fontSize: 16)),
                        Text('Cargo: ${dados.cargo}', style: const TextStyle(fontSize: 16)),
                        Text('Sigla: ${dados.sigla}', style: const TextStyle(fontSize: 16)),
                        Text('Setor Lotação: ${dados.setorLotacao}', style: const TextStyle(fontSize: 16)),
                        Text('Início Período: ${dados.inicioPeriodo}', style: const TextStyle(fontSize: 16)),
                        Text('Fim Período: ${dados.fimPeriodo}', style: const TextStyle(fontSize: 16)),
                        Text('Quantidade de dias: ${dados.qtdeDias}', style: const TextStyle(fontSize: 16)),
                        Text('Valor diárias: ${dados.valorDiarias}', style: const TextStyle(fontSize: 16)),
                        Text('Finalidade (Justificativa): ${dados.finalidade}', style: const TextStyle(fontSize: 16)),
                        Text('Roteiro: ${dados.roteiro}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  //logica para compartilhar esse card
                },
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                child: const Icon(Icons.share),
              ),
            )
          ],
        )
    );
  }
}