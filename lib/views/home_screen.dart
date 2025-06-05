import 'package:flutter/material.dart';
import '../controllers/treino_controller.dart';
import '../models/treinos_model.dart';
import '../views/detalhes_rotina_screen.dart';
import 'package:sa_app_treinos_personalizados/views/nova_rotina_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TreinoController _treinoController = TreinoController();

  List<Treino> _treinos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreinos();
  }

  Future<void> _loadTreinos() async {
    setState(() => _isLoading = true);
    try {
      _treinos = await _treinoController.listarTreinos();
    } catch (e) {
      print("Erro ao carregar treinos: $e");
      _treinos = [];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addTreino() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NovaRotinaScreen()),
    );
    _loadTreinos();
  }

  Future<void> _deleteTreino(int id) async {
    await _treinoController.excluirTreino(id);
    _loadTreinos();
  }

  Future<void> _verDetalhes(Treino treino) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalhesRotinaScreen(treino: treino),
      ),
    );
    _loadTreinos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Rotinas Personalizadas de Treino")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _treinos.isEmpty
              ? Center(child: Text("Nenhuma Rotina Personalizada de Treino encontrada."))
              : ListView.builder(
                  itemCount: _treinos.length,
                  itemBuilder: (context, index) {
                    final treino = _treinos[index];
                    return ListTile(
                      title: Text(treino.nome),
                      subtitle: Text(treino.objetivo),
                      onTap: () => _verDetalhes(treino),
                      onLongPress: () => _deleteTreino(treino.id!),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTreino,
        tooltip: "Adicionar Rotina Personalizada de Treino",
        child: Icon(Icons.add),
      ),
    );
  }
}
