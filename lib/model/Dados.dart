class Dados {
  final int matricula;
  final String nome;
  final String cargo;
  final String sigla;
  final String setorLotacao;
  final DateTime inicioPeriodo;
  final DateTime fimPeriodo;
  final int qtdeDias;
  final double valorDiarias;
  final String finalidade;
  final String roteiro;


  Dados({
    required this.matricula,
    required this.nome,
    required this.cargo,
    required this.sigla,
    required this.setorLotacao,
    required this.inicioPeriodo,
    required this.fimPeriodo,
    required this.qtdeDias,
    required this.valorDiarias,
    required this.finalidade,
    required this.roteiro,
  });

  Map<String, dynamic> toMap() {
    return {
      'matricula': matricula,
      'nome': nome,
      'cargo': cargo,
      'sigla': sigla,
      'setor_lotacao': setorLotacao,
      'inicio_periodo': inicioPeriodo.toString(),
      'fim_periodo': fimPeriodo.toString(),
      'qtde_dias': qtdeDias,
      'valor_diarias': valorDiarias,
      'finalidade': finalidade,
      'roteiro': roteiro,
    };
  }
}