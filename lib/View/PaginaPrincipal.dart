import 'package:flutter/material.dart';

import '../db/DatabaseConnection.dart';
import '../model/Dados.dart';
import '../model/Filtro.dart';
import 'PaginaDetalhes.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PaginaPrincipal> {
  String _filtroSelecionado = Filtro.matricula;
  final TextEditingController _textFieldController = TextEditingController();
  bool _ordenacaoAscendente = true;
  List<Dados>? listaDeDados;

  @override
  void initState() {
    super.initState();
    _getDados();
  }

  Future<void> _getDados() async {
    List<Dados>? dados = await DatabaseConnection.getDados();
    setState(() {
      listaDeDados = dados ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listaDeDados == null) {
      // Mostrar um indicador de carregamento enquanto os dados estão sendo carregados
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Builder(
                          builder: (context) => TextField(
                            key: Key(_filtroSelecionado),
                            controller: _textFieldController,
                            keyboardType: _getKeyboardType(),
                            decoration: const InputDecoration(
                              hintText: 'Pesquisar...',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                            ),
                            onChanged: (value) {
                              // Lógica de filtro aqui
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.red[400],
                        value: _filtroSelecionado,
                        onChanged: (String? novoFiltro) {
                          setState(() {
                            _filtroSelecionado = novoFiltro!;
                          });
                          _textFieldController.clear();
                        },
                        items: [
                          Filtro.matricula,
                          Filtro.nome,
                          Filtro.cargo,
                          Filtro.roteiro,
                          Filtro.data,
                        ].map<DropdownMenuItem<String>>((String filtro) {
                          return DropdownMenuItem<String>(
                            value: filtro,
                            child: Text(
                              filtro.toString().split('.').last,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          );
                        }).toList(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15), // Espaçamento entre a Row e o botão
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      //isso aqui so funciona pra matricula, faça para o resto agora

                      // Obter o valor da matrícula do TextField
                      int? matricula = int.tryParse(_textFieldController.text);

                      if (matricula != null) {
                        // Chamar o método getMatricula com a matrícula como parâmetro
                        List<Dados>? dadosMatricula =
                            await DatabaseConnection.getMatricula(matricula);

                        // Atualizar o estado com os dados obtidos
                        setState(() {
                          listaDeDados = dadosMatricula;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60.0, vertical: 10.0),
                    ),
                    child: const Text(
                      'Buscar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              padding:
                  const EdgeInsets.only(left: 15.0, top: 6.0, bottom: 3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Número de resultados: ${listaDeDados?.length}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Toque para ver detalhes',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _ordenacaoAscendente
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                    onPressed: () {
                      setState(() {
                        _ordenacaoAscendente = !_ordenacaoAscendente;
                        // ordenar asc ou desc
                      });
                    },
                  ),
                  PopupMenuButton<String>(
                    padding: const EdgeInsets.only(right: 15.0),
                    icon: const Icon(Icons.sort),
                    onSelected: (String newValue) {
                      //ordenar de acordo com o criterio
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Matricula',
                        child: Row(
                          children: [
                            Icon(Icons.format_list_numbered),
                            // Ícone para ordenar por matrícula
                            SizedBox(width: 8),
                            Text('Matrícula'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Nome',
                        child: Row(
                          children: [
                            Icon(Icons.sort_by_alpha),
                            // Ícone para ordenar por nome
                            SizedBox(width: 8),
                            Text('Nome'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Cargo',
                        child: Row(
                          children: [
                            Icon(Icons.work),
                            // Ícone para ordenar por idade
                            SizedBox(width: 8),
                            Text('Cargo'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          DadosListView(listaDeDados: listaDeDados),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType() {
    if (_filtroSelecionado == Filtro.matricula) {
      return TextInputType.number;
    } else if (_filtroSelecionado == Filtro.data) {
      return TextInputType.datetime;
    } else {
      return TextInputType.text;
    }
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          //espaço em cima do header
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("lib/assets/header1.JPG", scale: 3.8),
                Image.asset("lib/assets/header2.JPG", scale: 2)
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15.0, top: 1.0),
          child: const Text(
            'Pesquise por Requerimentos de diárias de funcionário',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
                  Text('Cargo: ${dado.cargo}, Matrícula: ${dado.matricula}'),
                  Text(
                      'Roteiro: ${dado.roteiro}, Número de dias: ${dado.qtdeDias}')
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
