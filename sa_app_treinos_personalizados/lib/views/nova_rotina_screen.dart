import 'package:flutter/material.dart';
import '../controllers/treino_controller.dart';

class NovaRotinaScreen extends StatefulWidget {
  @override
  _NovaRotinaScreenState createState() => _NovaRotinaScreenState();
}

class _NovaRotinaScreenState extends State<NovaRotinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _objetivoController = TextEditingController();
  final TreinoController controller = TreinoController();

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      await controller.adicionarTreino(
        _nomeController.text,
        _objetivoController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Rotina Personalizada de Treino')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Rotina de Treino'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _objetivoController,
                decoration: InputDecoration(labelText: 'Objetivo e/ou Metas'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
