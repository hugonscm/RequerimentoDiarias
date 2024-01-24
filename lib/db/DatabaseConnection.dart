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

  static Future<List<Dados>> getDados() async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];

    try {
      final results = await connection.query('SELECT * FROM funcionarios');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as String,
          fimPeriodo: row[6] as String,
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

  static Future<List<Dados>> getMatricula(int matricula) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];

    try {
      final results = await connection
          .query(' SELECT * FROM funcionarios WHERE matricula = $matricula ');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as String,
          fimPeriodo: row[6] as String,
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

  static Future<List<Dados>> getCargo(String cargo) async {
    final connection = await getConnection();
    await connection.open();

    List<Dados> dadosList = [];

    try {
      final results = await connection
          .query(' SELECT * FROM funcionarios WHERE LOWER(cargo) = LOWER(\'$cargo\') ');
      for (var row in results) {
        Dados dados = Dados(
          matricula: row[0] as int,
          nome: row[1] as String,
          cargo: row[2] as String,
          sigla: row[3] as String,
          setorLotacao: row[4] as String,
          inicioPeriodo: row[5] as String,
          fimPeriodo: row[6] as String,
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
