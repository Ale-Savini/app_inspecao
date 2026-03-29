import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/equipamento.dart';
import '../models/inspecao.dart';
import '../routes/app_routes.dart';

class HistoricoInspecaoScreen extends StatefulWidget {
  final Equipamento equipamento;

  const HistoricoInspecaoScreen({
    super.key,
    required this.equipamento,
  });

  @override
  State<HistoricoInspecaoScreen> createState() =>
      _HistoricoInspecaoScreenState();
}

class _HistoricoInspecaoScreenState extends State<HistoricoInspecaoScreen> {
  late Future<List<Inspecao>> _inspecoesFuture;

  @override
  void initState() {
    super.initState();
    _carregarInspecoes();
  }

  void _carregarInspecoes() {
    _inspecoesFuture = DatabaseHelper.instance
        .listarInspecoes(widget.equipamento.id!);
  }

  Future<void> _excluirInspecao(Inspecao inspecao) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir esta inspeção?'),
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
      await DatabaseHelper.instance.deletarInspecao(inspecao.id!);
      setState(() {
        _carregarInspecoes();
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inspeção excluída com sucesso!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatarData(String data) {
    try {
      final date = DateTime.parse(data);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico - ${widget.equipamento.nome}',
        ),
      ),
      body: FutureBuilder<List<Inspecao>>(
        future: _inspecoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar inspeções\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final inspecoes = snapshot.data ?? [];

          if (inspecoes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma inspeção cadastrada.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Clique em "Nova Inspeção" para adicionar',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: inspecoes.length,
            itemBuilder: (context, index) {
              final inspecao = inspecoes[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const Icon(
                    Icons.assignment_turned_in,
                    color: Colors.blue,
                  ),
                  title: Text(
                    _formatarData(inspecao.data),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    inspecao.descricao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'excluir') {
                        _excluirInspecao(inspecao);
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
                      AppRoutes.detalheInspecao,
                      arguments: inspecao,
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