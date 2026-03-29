import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class TesteScreen extends StatelessWidget {
  const TesteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste Banco')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final db = await DatabaseHelper.instance.database;
              print('✅ Sucesso!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Banco funcionando!')),
              );
            } catch (e) {
              print('❌ Erro: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro: $e')),
              );
            }
          },
          child: const Text('Testar Banco'),
        ),
      ),
    );
  }
}