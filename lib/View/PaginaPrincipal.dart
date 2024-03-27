import 'package:card_tjsp/card_tjsp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../db/DatabaseConnection.dart';
import '../login/authentication_screen.dart';
import '../model/Dados.dart';
import '../model/Filtro.dart';
import 'PaginaDetalhes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<PaginaPrincipal> {
  String _filtroSelecionado = Filtro.matricula;
  final TextEditingController _textFieldController = TextEditingController();
  bool _ordenacaoAscendente = true;
  bool _readOnly = false; //desativar teclado na seleção da data
  List<Dados>? listaDeDados;
  String parametroOrdenacao = "matricula";

  @override
  void initState() {
    super.initState();
    _getDadosRecentes();
    Fluttertoast.showToast(msg: "Exibindo 30 Requerimentos mais recentes.");
  }

  Future<void> _getDadosRecentes() async {
    List<Dados>? dados = await DatabaseConnection.getDados(
        parametroOrdenacao, _ordenacaoAscendente);
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
                            readOnly: _readOnly,
                            onTap: () async {
                              if (_filtroSelecionado == Filtro.data) {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2025));
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('dd/MM/yyyy')
                                          .format(pickedDate);
                                  setState(() {
                                    _textFieldController.text = formattedDate;
                                  });
                                }
                              }
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
                    onPressed: () {
                      buscarDados();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
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
              padding: const EdgeInsets.only(left: 15.0, top: 6.0, bottom: 3.0),
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
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                    ),
                    onPressed: () {
                      setState(() {
                        _ordenacaoAscendente = !_ordenacaoAscendente;
                        //acho que nao precisa do setState, testa depois
                        //da pra fazer o mesmo esquema do popmenubutton, usa a funcao buscarDados e passa se quer ordenar asc ou desc
                        buscarDados();
                      });
                    },
                  ),
                  PopupMenuButton<String>(
                    padding: const EdgeInsets.only(right: 15.0),
                    icon: const Icon(Icons.sort),
                    onSelected: (String newValue) {
                      parametroOrdenacao = newValue;
                      buscarDados();
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'matricula',
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
                        value: 'nome',
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
                        value: 'cargo',
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
      _readOnly = false;
      return TextInputType.number;
    } else if (_filtroSelecionado == Filtro.data) {
      _readOnly = true;
      return TextInputType.none;
    } else {
      _readOnly = false;
      return TextInputType.text;
    }
  }

  Future<void> buscarDados() async {
    if (_textFieldController.text.isEmpty) {
      _getDadosRecentes();
    } else {
      if (_filtroSelecionado == Filtro.matricula) {
        int? matricula = int.tryParse(_textFieldController.text);
        if (matricula != null) {
          List<Dados>? dados = await DatabaseConnection.getMatricula(
              matricula, parametroOrdenacao, _ordenacaoAscendente);
          setState(() {
            listaDeDados = dados;
          });
        }
      } else if (_filtroSelecionado == Filtro.nome) {
        String nome = _textFieldController.text;
        if (nome.isNotEmpty) {
          List<Dados>? dados = await DatabaseConnection.getNome(
              nome, parametroOrdenacao, _ordenacaoAscendente);
          setState(() {
            listaDeDados = dados;
          });
        }
      } else if (_filtroSelecionado == Filtro.cargo) {
        String cargo = _textFieldController.text;
        if (cargo.isNotEmpty) {
          List<Dados>? dados = await DatabaseConnection.getCargo(
              cargo, parametroOrdenacao, _ordenacaoAscendente);
          setState(() {
            listaDeDados = dados;
          });
        }
      } else if (_filtroSelecionado == Filtro.roteiro) {
        String roteiro = _textFieldController.text;
        if (roteiro.isNotEmpty) {
          List<Dados>? dados = await DatabaseConnection.getRoteiro(
              roteiro, parametroOrdenacao, _ordenacaoAscendente);
          setState(() {
            listaDeDados = dados;
          });
        }
      } else {
        //filtro tipo Data
        String data = _textFieldController.text;
        if (data.isNotEmpty) {
          List<Dados>? dados = await DatabaseConnection.getData(
              data, parametroOrdenacao, _ordenacaoAscendente);
          setState(() {
            listaDeDados = dados;
          });
        }
      }
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
            child: GestureDetector(
              onTap: _launchUrl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("lib/assets/header1.JPG", scale: 3.8),
                  Image.asset("lib/assets/header2.JPG", scale: 2)
                ],
              ),
            ),
          ),
        ),
         Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 1.0),
              child: Text(
                'Pesquise por Requerimentos\nde diárias de funcionário',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if(context.mounted){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
                          );
                        } else {
                          print("Erro ao deslogar");
                          return;
                        }
                      },
                      child: const Icon(Icons.logout, color: Colors.black,),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://www.tjsp.jus.br/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
              index % 2 == 0 ? Colors.grey[300] : Colors.white;

          return Card(
            color: backgroundColor,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaginaDetalhes(dados: dado),
                    ),
                  );
                },
                child: CardTjsp(
                    dado!.nome,
                    dado.cargo,
                    dado.matricula.toString(),
                    dado.roteiro,
                    dado.qtdeDias.toString(),
                    backgroundColor)),
          );
        },
      ),
    );
  }
}
