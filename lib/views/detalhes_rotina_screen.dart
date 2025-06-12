import 'package:flutter/material.dart';
import '../controllers/treino_controller.dart';
import '../models/treinos_model.dart';
import '../models/exercicio_model.dart';

class DetalhesRotinaScreen extends StatefulWidget {
  final Treino treino;

  DetalhesRotinaScreen({required this.treino});

  @override
  _DetalhesRotinaScreenState createState() => _DetalhesRotinaScreenState();
}

class _DetalhesRotinaScreenState extends State<DetalhesRotinaScreen> {
  final TreinoController controller = TreinoController();
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final seriesCtrl = TextEditingController();
  final repsCtrl = TextEditingController();
  final cargaCtrl = TextEditingController();
  final tipoCtrl = TextEditingController();

  List<Exercicio> exercicios = [];

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    final lista = await controller.listarExercicios(widget.treino.id!);
    setState(() => exercicios = lista);
  }

  Future<void> adicionarExercicio() async {
    if (_formKey.currentState!.validate()) {
      await controller.adicionarExercicio(
        widget.treino.id!,
        nomeCtrl.text,
        int.parse(seriesCtrl.text),
        int.parse(repsCtrl.text),
        double.parse(cargaCtrl.text),
        tipoCtrl.text,
      );
      nomeCtrl.clear();
      seriesCtrl.clear();
      repsCtrl.clear();
      cargaCtrl.clear();
      tipoCtrl.clear();
      _carregarExercicios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.treino.nome),
        backgroundColor: Color.fromARGB(188, 110, 49, 207),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            tooltip: 'Excluir rotina',
            onPressed: () async {
              await controller.excluirExerciciosDoTreino(widget.treino.id!);
              await controller.excluirTreino(widget.treino.id!);
              Navigator.of(context).pop(true); // Passe true para indicar que houve exclusão
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          color: const Color.fromARGB(46, 150, 109, 226),
          child: Column(
            children: [
              SizedBox(height: 9),
              Text(
                widget.treino.objetivo,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 22, 0, 117),
                ),
              ),
              SizedBox(height: 12),
              Divider(),
              Text(
                'Exercícios Adicionados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: exercicios.length,
                  itemBuilder: (context, index) {
                    final ex = exercicios[index];
                    return ListTile(
                      title: Text(ex.nome),
                      subtitle: Text(
                        '${ex.series}x${ex.repeticoes} - ${ex.carga}kg (${ex.tipo})',
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              SizedBox(height: 3),
              // Formulário para adicionar novo exercício embaixo
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nomeCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nome do Exercício',
                      ),
                      validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: seriesCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Séries'),
                            validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: repsCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Repetições',
                            ),
                            validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cargaCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Carga (kg)',
                            ),
                            validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: tipoCtrl,
                            decoration: InputDecoration(labelText: 'Tipo'),
                            validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await controller.adicionarExercicio(
                              widget.treino.id!,
                              nomeCtrl.text,
                              int.parse(seriesCtrl.text),
                              int.parse(repsCtrl.text),
                              double.parse(cargaCtrl.text),
                              tipoCtrl.text,
                            );
                            nomeCtrl.clear();
                            seriesCtrl.clear();
                            repsCtrl.clear();
                            cargaCtrl.clear();
                            tipoCtrl.clear();
                            _carregarExercicios();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Exercício adicionado com sucesso!'), backgroundColor: const Color.fromARGB(132, 0, 0, 0)),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao adicionar exercício!'), backgroundColor: const Color.fromARGB(127, 26, 26, 26)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Preencha todos os campos !'), backgroundColor: const Color.fromARGB(136, 2, 2, 2)),
                          );
                        }
                      },
                      child: Text('Adicionar Exercício'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
