import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/subestacao.dart';

class TesteScreen extends StatefulWidget {
  const TesteScreen({super.key});

  @override
  State<TesteScreen> createState() => _TesteScreenState();
}

class _TesteScreenState extends State<TesteScreen> {
  String _status = "Aguardando teste...";
  bool _testando = false;
  List<Subestacao> _subestacoes = [];

  @override
  void initState() {
    super.initState();
    _listarSubestacoes();
  }

  Future<void> _testarConexao() async {
    setState(() {
      _testando = true;
      _status = "Testando conexão...";
    });

    try {
      final db = await DatabaseHelper.instance.database;
      setState(() {
        _status = "✅ Conexão OK! Banco de dados funcionando.";
        _testando = false;
      });
      print('✅ Conexão com banco de dados estabelecida');
    } catch (e) {
      setState(() {
        _status = "❌ Erro na conexão: $e";
        _testando = false;
      });
      print('❌ Erro na conexão: $e');
    }
  }

  Future<void> _inserirTeste() async {
    setState(() {
      _testando = true;
      _status = "Inserindo subestação de teste...";
    });

    try {
      final sub = Subestacao(
        nome: "Teste ${DateTime.now().millisecondsSinceEpoch}",
        localizacao: "Localização de Teste",
      );

      final id = await DatabaseHelper.instance.inserirSubestacao(sub);
      
      setState(() {
        _status = "✅ Subestação inserida com ID: $id";
        _testando = false;
      });
      
      await _listarSubestacoes();
      
      print('✅ Subestação inserida com ID: $id');
    } catch (e) {
      setState(() {
        _status = "❌ Erro ao inserir: $e";
        _testando = false;
      });
      print('❌ Erro ao inserir: $e');
    }
  }

  Future<void> _listarSubestacoes() async {
    try {
      final lista = await DatabaseHelper.instance.listarSubestacoes();
      setState(() {
        _subestacoes = lista;
      });
      print('📋 Listadas ${lista.length} subestações');
    } catch (e) {
      print('❌ Erro ao listar: $e');
    }
  }

  Future<void> _deletarTodas() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('Deseja deletar TODAS as subestações?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _testando = true;
        _status = "Deletando todas...";
      });

      try {
        for (var sub in _subestacoes) {
          await DatabaseHelper.instance.deletarSubestacao(sub.id!);
        }
        
        setState(() {
          _status = "✅ Todas as subestações deletadas!";
          _testando = false;
        });
        
        await _listarSubestacoes();
        
        print('✅ Todas as subestações deletadas');
      } catch (e) {
        setState(() {
          _status = "❌ Erro ao deletar: $e";
          _testando = false;
        });
        print('❌ Erro ao deletar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste do Banco de Dados'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _listarSubestacoes,
            tooltip: 'Recarregar lista',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            Card(
              color: _status.contains('✅') 
                  ? Colors.green[50] 
                  : (_status.contains('❌') ? Colors.red[50] : Colors.grey[50]),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _status.contains('✅') 
                              ? Icons.check_circle 
                              : (_status.contains('❌') ? Icons.error : Icons.info),
                          color: _status.contains('✅') 
                              ? Colors.green 
                              : (_status.contains('❌') ? Colors.red : Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _status,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    if (_testando)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botões de teste
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testando ? null : _testarConexao,
                    icon: const Icon(Icons.storage),
                    label: const Text('Testar Conexão'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testando ? null : _inserirTeste,
                    icon: const Icon(Icons.add),
                    label: const Text('Inserir Teste'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testando ? null : _deletarTodas,
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Deletar Tudo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Lista de subestações
            const Text(
              'Subestações Cadastradas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: _subestacoes.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma subestação cadastrada',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _subestacoes.length,
                      itemBuilder: (context, index) {
                        final sub = _subestacoes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: Text('${index + 1}'),
                            ),
                            title: Text(sub.nome),
                            subtitle: Text(sub.localizacao),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await DatabaseHelper.instance
                                      .deletarSubestacao(sub.id!);
                                  await _listarSubestacoes();
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Subestação deletada!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print('Erro ao deletar: $e');
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            const SizedBox(height: 16),
            
            // Botão para ir para o app principal
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/subestacoes');
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Ir para o App Principal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}