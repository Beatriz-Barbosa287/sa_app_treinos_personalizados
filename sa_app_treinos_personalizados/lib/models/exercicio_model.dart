class Exercicio {
  final int? id;
  final int treinoId;
  final String nome;
  final int series;
  final int repeticoes;
  final double carga;
  final String tipo;

  Exercicio({
    this.id,
    required this.treinoId,
    required this.nome,
    required this.series,
    required this.repeticoes,
    required this.carga,
    required this.tipo,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'treinoId': treinoId,
        'nome': nome,
        'series': series,
        'repeticoes': repeticoes,
        'carga': carga,
        'tipo': tipo,
      };
}
