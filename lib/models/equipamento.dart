class Equipamento {
  final int? id;
  final int subestacaoId;
  final String nome;
  final String tipo;

  Equipamento({
    this.id,
    required this.subestacaoId,
    required this.nome,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subestacaoId': subestacaoId,
      'nome': nome,
      'tipo': tipo,
    };
  }

  factory Equipamento.fromMap(Map<String, dynamic> map) {
    return Equipamento(
      id: map['id'],
      subestacaoId: map['subestacaoId'],
      nome: map['nome'],
      tipo: map['tipo'],
    );
  }
}