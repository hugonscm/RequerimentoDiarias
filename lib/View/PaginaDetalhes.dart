import 'package:Requerimento_de_diarias/db/DatabaseFavoritos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/Dados.dart';

class PaginaDetalhes extends StatefulWidget {
  final Dados dados;

  const PaginaDetalhes({Key? key, required this.dados}) : super(key: key);

  @override
  _PaginaDetalhesState createState() => _PaginaDetalhesState();
}

class _PaginaDetalhesState extends State<PaginaDetalhes> {
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
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('MATRÍCULA: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('${widget.dados.matricula}'),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('NOME: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(widget.dados.nome),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('CARGO: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(widget.dados.cargo),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('SIGLA: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(widget.dados.sigla),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('SETOR LOTAÇÃO: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(widget.dados.setorLotacao),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('INÍCIO DO PERÍODO: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(DateFormat('dd/MM/yyyy')
                                          .format(widget.dados.inicioPeriodo)),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('FIM DO PERÍODO: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(DateFormat('dd/MM/yyyy')
                                          .format(widget.dados.fimPeriodo)),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('QUANTIDADE DE DIAS: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('${widget.dados.qtdeDias}'),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('VALOR DIÁRIAS: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text('R\$ ${widget.dados.valorDiarias}'),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('FINALIDADE (JUSTIFICATIVA): ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(widget.dados.finalidade),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('ROTEIRO: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(widget.dados.roteiro),
                                      const SizedBox(height: 60),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
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
            onPressed: () {
              // Lógica para o botao de share
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
    );
    await dbFavoritos.close();
    return favoritos.isNotEmpty;
  }
}
