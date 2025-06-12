import 'package:flutter/material.dart';
import '../controllers/treino_controller.dart';

class NovaRotinaScreen extends StatefulWidget {
  @override
  _NovaRotinaScreenState createState() => _NovaRotinaScreenState();
}

class _NovaRotinaScreenState extends State<NovaRotinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final TreinoController controller = TreinoController();
  List<TextEditingController> _metasControllers = [TextEditingController()];

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        final metas = _metasControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList();
        await controller.adicionarTreino(
          _nomeController.text,
          metas.map((m) => '• $m').join('\n'),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rotina adicionada com sucesso!'),
            backgroundColor: const Color.fromARGB(132, 0, 0, 0),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar!'),
            backgroundColor: const Color.fromARGB(127, 26, 26, 26),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: const Color.fromARGB(136, 2, 2, 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    for (var c in _metasControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Treino Personalizado'),
        backgroundColor: Color.fromARGB(188, 110, 49, 207),),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Color.fromARGB(132, 49, 13, 209),
        child: Icon(Icons.close),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Rotina de Treino'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Objetivos e/ou Metas', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ..._metasControllers.asMap().entries.map((entry) {
                int idx = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: entry.value,
                        decoration: InputDecoration(labelText: 'Meta ${idx + 1}'),
                        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Color.fromARGB(115, 34, 12, 134),),
                      onPressed: _metasControllers.length > 1
                          ? () {
                              setState(() {
                                _metasControllers.removeAt(idx);
                              });
                            }
                          : null,
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
