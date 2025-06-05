import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/treinos_model.dart';
import '../models/exercicio_model.dart';

class ApptreinosDbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'treino.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE treinos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            objetivo TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE exercicios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            treinoId INTEGER,
            nome TEXT,
            series INTEGER,
            repeticoes INTEGER,
            carga REAL,
            tipo TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertTreino(Treino treino) async {
    final db = await database;
    await db.insert('treinos', treino.toMap());
  }

  static Future<List<Treino>> getTreinos() async {
    final db = await database;
    final maps = await db.query('treinos');
    return maps.map((e) => Treino(
      id: e['id'] as int,
      nome: e['nome'] as String,
      objetivo: e['objetivo'] as String,
    )).toList();
  }

  static Future<void> insertExercicio(Exercicio ex) async {
    final db = await database;
    await db.insert('exercicios', ex.toMap());
  }

  static Future<List<Exercicio>> getExercicios(int treinoId) async {
    final db = await database;
    final maps = await db.query('exercicios', where: 'treinoId = ?', whereArgs: [treinoId]);
    return maps.map((e) => Exercicio(
      id: e['id'] as int,
      treinoId: e['treinoId'] as int,
      nome: e['nome'] as String,
      series: e['series'] as int,
      repeticoes: e['repeticoes'] as int,
      carga: e['carga'] as double,
      tipo: e['tipo'] as String,
    )).toList();
  }
}
