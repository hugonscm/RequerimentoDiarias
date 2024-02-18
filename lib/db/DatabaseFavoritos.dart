import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/Dados.dart';

class DBFavoritos {
  DBFavoritos._();
  static final DBFavoritos instance = DBFavoritos._();
  static Database? _database;

  get database async {
    if(_database != null) return _database;
    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'favoritos.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_favoritos);
  }

  String get _favoritos => '''
    CREATE TABLE funcionarios (
    matricula INTEGER NOT NULL,
    nome TEXT NOT NULL,
    cargo TEXT,
    sigla TEXT,
    setor_lotacao TEXT,
    inicio_periodo DATE,
    fim_periodo DATE,
    qtde_dias INTEGER,
    valor_diarias DOUBLE PRECISION,
    finalidade TEXT,
    roteiro TEXT,
	PRIMARY KEY (matricula, inicio_periodo, fim_periodo)
);
  ''';

  Future<int> inserirDado(Dados dado) async {
    final db = await instance.database;
    return await db.insert('funcionarios', dado.toMap());
  }

  Future<int> removerDado(Dados dado) async {
    final db = await instance.database;
    return await db.delete(
      'funcionarios',
      where: 'matricula = ? AND inicio_periodo = ? AND fim_periodo = ?',
      whereArgs: [
        dado.matricula,
        dado.inicioPeriodo.toString(),
        dado.fimPeriodo.toString(),
      ],
    );
  }

  Future<List<Dados>> getDados() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('funcionarios');
    return List.generate(maps.length, (i) {
      return Dados(
        matricula: maps[i]['matricula'],
        nome: maps[i]['nome'],
        cargo: maps[i]['cargo'],
        sigla: maps[i]['sigla'],
        setorLotacao: maps[i]['setor_lotacao'],
        inicioPeriodo: DateTime.parse(maps[i]['inicio_periodo']),
        fimPeriodo: DateTime.parse(maps[i]['fim_periodo']),
        qtdeDias: maps[i]['qtde_dias'],
        valorDiarias: maps[i]['valor_diarias'],
        finalidade: maps[i]['finalidade'],
        roteiro: maps[i]['roteiro'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> verificarFavoritoExistente({
    required int matricula,
    required DateTime inicioPeriodo,
    required DateTime fimPeriodo,
  }) async {
    final Database db = await instance.database;
    return await db.query(
      'funcionarios',
      where: 'matricula = ? AND inicio_periodo = ? AND fim_periodo = ?',
      whereArgs: [matricula, inicioPeriodo.toString(), fimPeriodo.toString()],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}


