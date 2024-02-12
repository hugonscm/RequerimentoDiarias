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

  @override
  void initState() {
    super.initState();
    _favorito = consultarFavorito();
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
            bool favorito = snapshot.data ?? false;
            return Stack(
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
                              Text('Matrícula: ${widget.dados.matricula}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Nome: ${widget.dados.nome}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Cargo: ${widget.dados.cargo}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Sigla: ${widget.dados.sigla}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Setor Lotação: ${widget.dados.setorLotacao}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Início Período: ${DateFormat('dd/MM/yyyy').format(widget.dados.inicioPeriodo)}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Fim Período: ${DateFormat('dd/MM/yyyy').format(widget.dados.fimPeriodo)}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Quantidade de dias: ${widget.dados.qtdeDias}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Valor diárias: ${widget.dados.valorDiarias}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Finalidade (Justificativa): ${widget.dados.finalidade}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Roteiro: ${widget.dados.roteiro}',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 13.0,
                  right: 80.0,
                  child: IconButton(
                    icon: Icon(
                      favorito ? Icons.favorite : Icons.favorite_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      favorito ? removerDado() : inserirDado();
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        child: const Icon(Icons.share),
      ),
    );
  }

  Future<void> inserirDado() async {
    final dbFavoritos = DBFavoritos.instance;
    await dbFavoritos.inserirDado(widget.dados);
    await dbFavoritos.close();
    setState(() {
      _favorito = consultarFavorito();
    });
  }

  Future<void> removerDado() async {
    final dbFavoritos = DBFavoritos.instance;
    await dbFavoritos.removerDado(widget.dados);
    await dbFavoritos.close();
    setState(() {
      _favorito = consultarFavorito();
    });
  }

  //verifica se o item ja esta no banco local de favoritos
  Future<bool> consultarFavorito() async {
    final dbFavoritos = DBFavoritos.instance;
    final List<Map<String, dynamic>> favoritos = await dbFavoritos.verificarFavoritoExistente(
      matricula: widget.dados.matricula,
      inicioPeriodo: widget.dados.inicioPeriodo,
      fimPeriodo: widget.dados.fimPeriodo,
    );
    await dbFavoritos.close();
    return favoritos.isNotEmpty;
  }
}
