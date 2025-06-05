class Treino {
  final int? id;
  final String nome;
  final String objetivo;

  Treino({this.id, required this.nome, required this.objetivo});

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'objetivo': objetivo,
      };
}
