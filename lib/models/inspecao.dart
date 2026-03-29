class Inspecao {
  final int? id;
  final String descricao;
  final String data;
  final int equipamentoId;

  Inspecao({
    this.id,
    required this.descricao,
    required this.data,
    required this.equipamentoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'data': data,
      'equipamentoId': equipamentoId,
    };
  }

  factory Inspecao.fromMap(Map<String, dynamic> map) {
    return Inspecao(
      id: map['id'],
      descricao: map['descricao'],
      data: map['data'],
      equipamentoId: map['equipamentoId'],
    );
  }
}