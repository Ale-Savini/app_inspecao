import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/subestacao.dart';
import '../models/equipamento.dart';
import '../routes/app_routes.dart';
import 'cadastrar_equipamento_screen.dart';

class EquipamentosListaScreen extends StatefulWidget {
  final Subestacao subestacao;

  const EquipamentosListaScreen({
    super.key,
    required this.subestacao,
  });

  @override
  State<EquipamentosListaScreen> createState() =>
      _EquipamentosListaScreenState();
}

class _EquipamentosListaScreenState extends State<EquipamentosListaScreen> {
  late Future<List<Equipamento>> equipamentosFuture;

  @override
  void initState() {
    super.initState();
    _carregarEquipamentos();
  }

  void _carregarEquipamentos() {
    equipamentosFuture = DatabaseHelper.instance.listarEquipamentos(
      widget.subestacao.id!,
    );
  }

  Future<void> _excluirEquipamento(Equipamento eq) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text(
          'Deseja realmente excluir o equipamento "${eq.nome}"?\n\n'
          'Todas as inspeções relacionadas também serão excluídas.',
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
      await DatabaseHelper.instance.deletarEquipamento(eq.id!);
      if (!mounted) return;
      setState(() {
        _carregarEquipamentos();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Equipamento excluído com sucesso!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subestacao.nome),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CadastrarEquipamentoScreen(
                subestacao: widget.subestacao,
              ),
            ),
          );
          
          if (result == true) {
            setState(() {
              _carregarEquipamentos();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Equipamento>>(
        future: equipamentosFuture,
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
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar equipamentos: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _carregarEquipamentos()),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final equipamentos = snapshot.data!;

          if (equipamentos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.devices,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum equipamento cadastrado',
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
            itemCount: equipamentos.length,
            itemBuilder: (context, index) {
              final eq = equipamentos[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.devices, color: Colors.blue),
                  ),
                  title: Text(
                    eq.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(eq.tipo),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'excluir') {
                        _excluirEquipamento(eq);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
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
                      AppRoutes.equipamentoDetalhe,
                      arguments: eq,
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