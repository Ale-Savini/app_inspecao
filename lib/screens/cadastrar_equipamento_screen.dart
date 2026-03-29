import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/equipamento.dart';
import '../models/subestacao.dart';

class CadastrarEquipamentoScreen extends StatefulWidget {
  final Subestacao subestacao;

  const CadastrarEquipamentoScreen({
    super.key,
    required this.subestacao,
  });

  @override
  State<CadastrarEquipamentoScreen> createState() =>
      _CadastrarEquipamentoScreenState();
}

class _CadastrarEquipamentoScreenState
    extends State<CadastrarEquipamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  String? _tipoSelecionado;

  final List<String> tiposEquipamento = const [
    'Transformador',
    'Disjuntor',
    'Seccionadora',
    'TC',
    'TP',
    'Banco de Capacitores',
    'Relé de Proteção',
    'Outro'
  ];

  Future<void> _salvarEquipamento() async {
    if (!_formKey.currentState!.validate()) return;

    final equipamento = Equipamento(
      nome: _nomeController.text,
      tipo: _tipoSelecionado!,
      subestacaoId: widget.subestacao.id!,
    );

    await DatabaseHelper.instance.inserirEquipamento(equipamento);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipamento cadastrado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Equipamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.subestacao.nome,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Subestação',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.electrical_services),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Equipamento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.devices),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo do Equipamento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _tipoSelecionado,
                items: tiposEquipamento.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoSelecionado = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _salvarEquipamento,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Equipamento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}