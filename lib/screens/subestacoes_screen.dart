import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/subestacao.dart';
import '../routes/app_routes.dart';

class SubestacoesScreen extends StatefulWidget {
  const SubestacoesScreen({super.key});

  @override
  State<SubestacoesScreen> createState() => _SubestacoesScreenState();
}

class _SubestacoesScreenState extends State<SubestacoesScreen> {
  late Future<List<Subestacao>> _future;

  @override
  void initState() {
    super.initState();
    _carregarSubestacoes();
  }

  void _carregarSubestacoes() {
    _future = DatabaseHelper.instance.listarSubestacoes();
  }

  Future<void> _adicionarSubestacao() async {
    final nomeController = TextEditingController();
    final localizacaoController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Subestação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Subestação',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: localizacaoController,
                decoration: const InputDecoration(
                  labelText: 'Localização',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomeController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe o nome da subestação'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final novaSubestacao = Subestacao(
                  nome: nomeController.text.trim(),
                  localizacao: localizacaoController.text.trim().isEmpty
                      ? 'Não informada'
                      : localizacaoController.text.trim(),
                );

                try {
                  final id = await DatabaseHelper.instance
                      .inserirSubestacao(novaSubestacao);
                  
                  if (id > 0) {
                    Navigator.pop(context, true);
                  } else {
                    throw Exception('Erro ao salvar');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao salvar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        _carregarSubestacoes();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subestação cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _excluirSubestacao(Subestacao subestacao) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text(
          'Deseja realmente excluir a subestação "${subestacao.nome}"?\n\n'
          'Todos os equipamentos e inspeções relacionados também serão excluídos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final equipamentos = await DatabaseHelper.instance
            .listarEquipamentos(subestacao.id!);
        
        for (var equipamento in equipamentos) {
          await DatabaseHelper.instance.deletarEquipamento(equipamento.id!);
        }
        
        await DatabaseHelper.instance.deletarSubestacao(subestacao.id!);
        
        setState(() {
          _carregarSubestacoes();
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subestação excluída com sucesso!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subestações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _carregarSubestacoes()),
            tooltip: 'Recarregar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarSubestacao,
        child: const Icon(Icons.add),
        tooltip: 'Nova Subestação',
      ),
      body: FutureBuilder<List<Subestacao>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar subestações: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _carregarSubestacoes()),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final subestacoes = snapshot.data ?? [];

          if (subestacoes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.electrical_services,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma subestação cadastrada',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Clique no botão + para adicionar',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: subestacoes.length,
            itemBuilder: (context, index) {
              final sub = subestacoes[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.electrical_services,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    sub.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(sub.localizacao),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'excluir') {
                        _excluirSubestacao(sub);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'excluir',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Excluir'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.equipamentos,
                      arguments: sub,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}