import '../services/apptreinos_db_helper.dart';
import '../models/treinos_model.dart';
import '../models/exercicio_model.dart';

class TreinoController {
  Future<void> adicionarTreino(String nome, String objetivo) async {
    final treino = Treino(nome: nome, objetivo: objetivo);
    await ApptreinosDbHelper.insertTreino(treino);
  }

  Future<List<Treino>> listarTreinos() async {
    return await ApptreinosDbHelper.getTreinos();
  }

  Future<void> adicionarExercicio(
      int treinoId,
      String nome,
      int series,
      int repeticoes,
      double carga,
      String tipo) async {
    final exercicio = Exercicio(
      treinoId: treinoId,
      nome: nome,
      series: series,
      repeticoes: repeticoes,
      carga: carga,
      tipo: tipo,
    );
    await ApptreinosDbHelper.insertExercicio(exercicio);
  }

  Future<List<Exercicio>> listarExercicios(int treinoId) async {
    return await ApptreinosDbHelper.getExercicios(treinoId);
  }

  Future<void> excluirTreino(int treinoId) async {
    final db = await ApptreinosDbHelper.database;
    await db.delete('treinos', where: 'id = ?', whereArgs: [treinoId]);
  }

  Future<void> excluirExercicio(int id) async {}

  Future<void> excluirExerciciosDoTreino(int treinoId) async {
    await ApptreinosDbHelper.deleteExerciciosByTreinoId(treinoId);
  }
}
