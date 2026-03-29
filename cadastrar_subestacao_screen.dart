import 'package:flutter/material.dart';
import 'lib/database/database_helper.dart';
import 'lib/models/subestacao.dart';

class CadastrarSubestacaoScreen extends StatefulWidget {
  const CadastrarSubestacaoScreen({super.key});

  @override
  State<CadastrarSubestacaoScreen> createState() =>
      _CadastrarSubestacaoScreenState();
}

class _CadastrarSubestacaoScreenState extends State<CadastrarSubestacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _localController = TextEditingController();

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final sub = Subestacao(
      nome: _nomeController.text,
      localizacao: _localController.text,
    );

    await DatabaseHelper.instance.inserirSubestacao(sub);

    if (!mounted) return;

    Navigator.pop(context, true); // ⭐ MUITO IMPORTANTE
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Subestação')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(
                  labelText: 'Localização',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a localização' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
