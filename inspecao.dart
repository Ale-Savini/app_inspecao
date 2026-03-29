class Inspecao {
  final int? id;
  final String subestacao;
  final String equipamento;
  final String contador;
  final String observacoes;
  final String checklist;
  final String data;

  Inspecao({
    this.id,
    required this.subestacao,
    required this.equipamento,
    required this.contador,
    required this.observacoes,
    required this.checklist,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subestacao': subestacao,
      'equipamento': equipamento,
      'contador': contador,
      'observacoes': observacoes,
      'checklist': checklist,
      'data': data,
    };
  }

  factory Inspecao.fromMap(Map<String, dynamic> map) {
    return Inspecao(
      id: map['id'],
      subestacao: map['subestacao'],
      equipamento: map['equipamento'],
      contador: map['contador'],
      observacoes: map['observacoes'],
      checklist: map['checklist'],
      data: map['data'],
    );
  }
}
