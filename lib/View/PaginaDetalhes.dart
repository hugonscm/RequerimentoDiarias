import 'dart:async';

import 'package:Requerimento_de_diarias/db/DatabaseFavoritos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../model/Dados.dart';

class PaginaDetalhes extends StatefulWidget {
  final Dados dados;

  const PaginaDetalhes({Key? key, required this.dados}) : super(key: key);

  @override
  _PaginaDetalhesState createState() => _PaginaDetalhesState();
}

class _PaginaDetalhesState extends State<PaginaDetalhes> {
  final ScreenshotController screenshotController = ScreenshotController();
  late Future<bool> _favorito;
  bool favorito = false;

  @override
  void initState() {
    super.initState();
    _favorito = consultarFavorito().then((value) {
      setState(() {
        favorito = value; // Atualizando favorito após a consulta
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: FutureBuilder<bool>(
        future: _favorito,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return Scrollbar(
              thumbVisibility: true,
              child:
                  SingleChildScrollView(child: CardItens(dados: widget.dados)),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Lógica para o botao de favoritos
              favorito ? removerDado() : inserirDado();
            },
            backgroundColor: Colors.grey,
            foregroundColor: favorito ? Colors.red : Colors.white,
            child: const Icon(
              Icons.favorite,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              // Lógica para o botao de share
              final image = await screenshotController.captureFromWidget(
                  CardItens(dados: widget.dados),
                  pixelRatio: 2);
              Share.shareXFiles([XFile.fromData(image, mimeType: "jpg")]);
            },
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            child: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }

  Future<void> inserirDado() async {
    final dbFavoritos = DBFavoritos.instance;
    await dbFavoritos.inserirDado(widget.dados);
    await dbFavoritos.close();
    setState(() {
      _favorito = consultarFavorito();
      favorito = true;
    });
  }

  Future<void> removerDado() async {
    final dbFavoritos = DBFavoritos.instance;
    await dbFavoritos.removerDado(widget.dados);
    await dbFavoritos.close();
    setState(() {
      _favorito = consultarFavorito();
      favorito = false;
    });
  }

  //verifica se o item ja esta no banco local de favoritos
  Future<bool> consultarFavorito() async {
    final dbFavoritos = DBFavoritos.instance;
    final List<Map<String, dynamic>> favoritos =
        await dbFavoritos.verificarFavoritoExistente(
            matricula: widget.dados.matricula,
            inicioPeriodo: widget.dados.inicioPeriodo,
            fimPeriodo: widget.dados.fimPeriodo,
            valorDiarias: widget.dados.valorDiarias,
            finalidade: widget.dados.finalidade,
            roteiro: widget.dados.roteiro);
    await dbFavoritos.close();
    return favoritos.isNotEmpty;
  }
}

class CardItens extends StatelessWidget {
  final Dados dados;

  const CardItens({required this.dados, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          //usado para o container pegar a altura dos itens
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('MATRÍCULA: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text('${dados.matricula}',
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NOME: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(dados.nome,
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CARGO: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(dados.cargo,
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SIGLA: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(dados.sigla,
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SETOR LOTAÇÃO: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(dados.setorLotacao,
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('INÍCIO DO PERÍODO: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(DateFormat('dd/MM/yyyy').format(dados.inicioPeriodo),
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('FIM DO PERÍODO: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(DateFormat('dd/MM/yyyy').format(dados.fimPeriodo),
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('QUANTIDADE DE DIAS: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text('${dados.qtdeDias}',
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('VALOR DIÁRIAS: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text('R\$ ${dados.valorDiarias}',
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('FINALIDADE (JUSTIFICATIVA): ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(dados.finalidade,
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ROTEIRO: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(dados.roteiro,
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 60),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
