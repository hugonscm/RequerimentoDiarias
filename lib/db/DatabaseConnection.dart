import 'package:postgres/postgres.dart';

import '../model/Dados.dart';

class DatabaseConnection {
  static Future<PostgreSQLConnection> getConnection() async {
    final connection = PostgreSQLConnection(
      //tive que pegar esse ip aqui direto do emulador
      '10.0.2.2',
      5432,
      'postgres',
      username: 'postgres',
      password: 'admin',
    );

    return connection;
  }

  static Future<List<Dados>> getDados(String parametroOrdenacao, bool ordenacaoAscendente) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];
    String ordem = ordenacaoAscendente ? 'ASC' : 'DESC';

    try {
      final results = await connection.query(
          'SELECT * FROM (SELECT * FROM funcionarios ORDER BY fim_periodo DESC LIMIT 30) ORDER BY $parametroOrdenacao $ordem;');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as DateTime,
          fimPeriodo: row[6] as DateTime,
          qtdeDias: row[7] as int,
          valorDiarias: row[8] as double,
          finalidade: row[9] as String,
          roteiro: row[10] as String,
        );
        dadosList.add(dados);
      }
    } finally {
      await connection.close();
    }

    return dadosList;
  }

  static Future<List<Dados>> getMatricula(int matricula, String parametroOrdenacao, bool ordenacaoAscendente) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];
    String ordem = ordenacaoAscendente ? 'ASC' : 'DESC';

    try {
      final results = await connection.query(
          ' SELECT * FROM funcionarios WHERE matricula = $matricula  ORDER BY $parametroOrdenacao $ordem');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as DateTime,
          fimPeriodo: row[6] as DateTime,
          qtdeDias: row[7] as int,
          valorDiarias: row[8] as double,
          finalidade: row[9] as String,
          roteiro: row[10] as String,
        );
        dadosList.add(dados);
      }
    } finally {
      await connection.close();
    }

    return dadosList;
  }

  static Future<List<Dados>> getNome(String nome, String parametroOrdenacao, bool ordenacaoAscendente) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];
    String ordem = ordenacaoAscendente ? 'ASC' : 'DESC';

    try {
      final results = await connection.query(
          ' SELECT * FROM funcionarios WHERE LOWER(nome) LIKE LOWER(\'%$nome%\') ORDER BY $parametroOrdenacao $ordem');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as DateTime,
          fimPeriodo: row[6] as DateTime,
          qtdeDias: row[7] as int,
          valorDiarias: row[8] as double,
          finalidade: row[9] as String,
          roteiro: row[10] as String,
        );
        dadosList.add(dados);
      }
    } finally {
      await connection.close();
    }

    return dadosList;
  }

  static Future<List<Dados>> getCargo(String cargo, String parametroOrdenacao, bool ordenacaoAscendente) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];
    String ordem = ordenacaoAscendente ? 'ASC' : 'DESC';

    try {
      final results = await connection.query(
          ' SELECT * FROM funcionarios WHERE LOWER(cargo) LIKE LOWER(\'%$cargo%\') ORDER BY $parametroOrdenacao $ordem');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as DateTime,
          fimPeriodo: row[6] as DateTime,
          qtdeDias: row[7] as int,
          valorDiarias: row[8] as double,
          finalidade: row[9] as String,
          roteiro: row[10] as String,
        );
        dadosList.add(dados);
      }
    } finally {
      await connection.close();
    }

    return dadosList;
  }

  static Future<List<Dados>> getRoteiro(String roteiro, String parametroOrdenacao, bool ordenacaoAscendente) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];
    String ordem = ordenacaoAscendente ? 'ASC' : 'DESC';

    try {
      final results = await connection.query(
          ' SELECT * FROM funcionarios WHERE LOWER(roteiro) LIKE LOWER(\'%$roteiro%\') ORDER BY $parametroOrdenacao $ordem');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as DateTime,
          fimPeriodo: row[6] as DateTime,
          qtdeDias: row[7] as int,
          valorDiarias: row[8] as double,
          finalidade: row[9] as String,
          roteiro: row[10] as String,
        );
        dadosList.add(dados);
      }
    } finally {
      await connection.close();
    }

    return dadosList;
  }

  static Future<List<Dados>> getData(String data, String parametroOrdenacao, bool ordenacaoAscendente) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];
    String ordem = ordenacaoAscendente ? 'ASC' : 'DESC';

    try {
      final results = await connection.query(
          ' SELECT * FROM funcionarios WHERE \'$data\' >= inicio_periodo  AND \'$data\' <= fim_periodo ORDER BY $parametroOrdenacao $ordem');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as DateTime,
          fimPeriodo: row[6] as DateTime,
          qtdeDias: row[7] as int,
          valorDiarias: row[8] as double,
          finalidade: row[9] as String,
          roteiro: row[10] as String,
        );
        dadosList.add(dados);
      }
    } finally {
      await connection.close();
    }

    return dadosList;
  }
/*
  static Future<void> testConnection() async {
    final connection = await getConnection();

    try {
      await connection.open();
      print('Conexão bem-sucedida!');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
    } finally {
      await connection.close();
    }
  }*/
}
