import 'package:flutter_test/flutter_test.dart';
import 'package:app_inspecao/models/subestacao.dart';

void main() {
  group('Testes da classe Subestacao', () {
    test('Deve criar uma subestação corretamente', () {
      // Criando uma subestação
      final subestacao = Subestacao(
        nome: 'SE Poços de Caldas',
        localizacao: 'Poços de Caldas, MG',
      );

      // Verificando se os dados estão corretos
      expect(subestacao.nome, 'SE Poços de Caldas');
      expect(subestacao.localizacao, 'Poços de Caldas, MG');
      expect(subestacao.id, null); // ID é null porque não foi definido
    });

    test('Deve criar uma subestação com ID', () {
      // Criando uma subestação com ID
      final subestacao = Subestacao(
        id: 1,
        nome: 'SE Andradas',
        localizacao: 'Andradas, MG',
      );

      // Verificando
      expect(subestacao.id, 1);
      expect(subestacao.nome, 'SE Andradas');
      expect(subestacao.localizacao, 'Andradas, MG');
    });

    test('Deve converter subestação para Map', () {
      // Criando uma subestação
      final subestacao = Subestacao(
        id: 1,
        nome: 'SE Varginha',
        localizacao: 'Varginha, MG',
      );

      // Convertendo para Map
      final map = subestacao.toMap();

      // Verificando se o Map está correto
      expect(map['id'], 1);
      expect(map['nome'], 'SE Varginha');
      expect(map['localizacao'], 'Varginha, MG');
    });

    test('Deve converter Map para subestação', () {
      // Criando um Map
      final map = {
        'id': 1,
        'nome': 'SE Alfenas',
        'localizacao': 'Alfenas, MG',
      };

      // Convertendo Map para Subestacao
      final subestacao = Subestacao.fromMap(map);

      // Verificando
      expect(subestacao.id, 1);
      expect(subestacao.nome, 'SE Alfenas');
      expect(subestacao.localizacao, 'Alfenas, MG');
    });
  });
}
