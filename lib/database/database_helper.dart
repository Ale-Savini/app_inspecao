import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/subestacao.dart';
import '../models/equipamento.dart';
import '../models/inspecao.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_inspecao.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, filePath);
      
      print('📁 Caminho do banco: $path');
      
      final db = await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
      
      print('✅ Banco aberto com sucesso');
      return db;
    } catch (e) {
      print('❌ Erro ao abrir banco: $e');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    print('🔄 Criando tabelas...');
    
    await db.execute('''
      CREATE TABLE subestacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        localizacao TEXT NOT NULL
      )
    ''');
    print('✅ Tabela subestacoes criada');

    await db.execute('''
      CREATE TABLE equipamentos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subestacaoId INTEGER NOT NULL,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        FOREIGN KEY (subestacaoId) REFERENCES subestacoes (id) ON DELETE CASCADE
      )
    ''');
    print('✅ Tabela equipamentos criada');

    await db.execute('''
      CREATE TABLE inspecoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipamentoId INTEGER NOT NULL,
        descricao TEXT NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (equipamentoId) REFERENCES equipamentos (id) ON DELETE CASCADE
      )
    ''');
    print('✅ Tabela inspecoes criada');
    
    print('✅ Todas as tabelas criadas com sucesso!');
  }

  // CRUD Subestação
  Future<int> inserirSubestacao(Subestacao sub) async {
    try {
      final db = await database;
      print('📝 Inserindo subestação: ${sub.nome}');
      final id = await db.insert('subestacoes', sub.toMap());
      print('✅ Subestação inserida com ID: $id');
      return id;
    } catch (e) {
      print('❌ Erro ao inserir: $e');
      rethrow;
    }
  }

  Future<List<Subestacao>> listarSubestacoes() async {
    try {
      final db = await database;
      final result = await db.query('subestacoes', orderBy: 'nome');
      print('📋 Listando ${result.length} subestações');
      return result.map((e) => Subestacao.fromMap(e)).toList();
    } catch (e) {
      print('❌ Erro ao listar: $e');
      return [];
    }
  }

  Future<int> deletarSubestacao(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'subestacoes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('❌ Erro ao deletar: $e');
      rethrow;
    }
  }

  // CRUD Equipamento
  Future<int> inserirEquipamento(Equipamento eq) async {
    try {
      final db = await database;
      return await db.insert('equipamentos', eq.toMap());
    } catch (e) {
      print('❌ Erro ao inserir equipamento: $e');
      rethrow;
    }
  }

  Future<List<Equipamento>> listarEquipamentos(int subestacaoId) async {
    try {
      final db = await database;
      final result = await db.query(
        'equipamentos',
        where: 'subestacaoId = ?',
        whereArgs: [subestacaoId],
        orderBy: 'nome',
      );
      return result.map((e) => Equipamento.fromMap(e)).toList();
    } catch (e) {
      print('❌ Erro ao listar equipamentos: $e');
      return [];
    }
  }

  Future<int> deletarEquipamento(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'equipamentos',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('❌ Erro ao deletar equipamento: $e');
      rethrow;
    }
  }

  // CRUD Inspeção
  Future<int> inserirInspecao(Inspecao inspecao) async {
    try {
      final db = await database;
      return await db.insert('inspecoes', inspecao.toMap());
    } catch (e) {
      print('❌ Erro ao inserir inspeção: $e');
      rethrow;
    }
  }

  Future<List<Inspecao>> listarInspecoes(int equipamentoId) async {
    try {
      final db = await database;
      final result = await db.query(
        'inspecoes',
        where: 'equipamentoId = ?',
        whereArgs: [equipamentoId],
        orderBy: 'data DESC',
      );
      return result.map((e) => Inspecao.fromMap(e)).toList();
    } catch (e) {
      print('❌ Erro ao listar inspeções: $e');
      return [];
    }
  }

  Future<int> deletarInspecao(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'inspecoes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('❌ Erro ao deletar inspeção: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      // Ignorar
    }
  }
}