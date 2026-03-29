import 'package:flutter/material.dart';
import '../models/equipamento.dart';
import '../routes/app_routes.dart';

class EquipamentoDetalheScreen extends StatelessWidget {
  final Equipamento equipamento;

  const EquipamentoDetalheScreen({
    super.key,
    required this.equipamento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipamento.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.category),
                      title: Text('Tipo do Equipamento'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          equipamento.tipo,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.electrical_services),
                      title: Text('ID do Equipamento'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '#${equipamento.id}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nova Inspeção'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.novaInspecao,
                    arguments: equipamento,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('Histórico de Inspeções'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.historico,
                    arguments: equipamento,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}