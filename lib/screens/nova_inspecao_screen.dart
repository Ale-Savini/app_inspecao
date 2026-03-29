import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/equipamento.dart';
import '../models/inspecao.dart';

class NovaInspecaoScreen extends StatefulWidget {
  final Equipamento equipamento;

  const NovaInspecaoScreen({
    super.key,
    required this.equipamento,
  });

  @override
  State<NovaInspecaoScreen> createState() => _NovaInspecaoScreenState();
}

class _NovaInspecaoScreenState extends State<NovaInspecaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();

  Future<void> _salvarInspecao() async {
    if (!_formKey.currentState!.validate()) return;

    final inspecao = Inspecao(
      descricao: _descricaoController.text,
      data: _dataSelecionada.toIso8601String().split('T')[0],
      equipamentoId: widget.equipamento.id!,
    );

    await DatabaseHelper.instance.inserirInspecao(inspecao);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inspeção cadastrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Inspeção'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Equipamento',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.equipamento.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tipo: ${widget.equipamento.tipo}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: _selecionarData,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data da Inspeção',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _dataSelecionada.toLocal().toString().split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Descrição / Observações',
                  border: OutlineInputBorder(),
                  hintText: 'Descreva os detalhes da inspeção...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição da inspeção';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _salvarInspecao,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Inspeção'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}