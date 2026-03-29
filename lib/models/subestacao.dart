class Subestacao {
  final int? id;
  final String nome;
  final String localizacao;

  Subestacao({
    this.id,
    required this.nome,
    required this.localizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'localizacao': localizacao,
    };
  }

  factory Subestacao.fromMap(Map<String, dynamic> map) {
    return Subestacao(
      id: map['id'],
      nome: map['nome'],
      localizacao: map['localizacao'],
    );
  }
}