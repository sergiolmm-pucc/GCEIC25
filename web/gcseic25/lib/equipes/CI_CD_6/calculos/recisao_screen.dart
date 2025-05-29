import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecisaoScreen extends StatefulWidget {
  const RecisaoScreen({super.key});

  @override
  State<RecisaoScreen> createState() => _RecisaoScreenState();
}

class _RecisaoScreenState extends State<RecisaoScreen> {
  final _salarioController = TextEditingController();
  final _mesesTrabalhadosController = TextEditingController();
  final _saldoDiasController = TextEditingController();
  String _motivo = 'semJustaCausa';
  bool _feriasVencidas = false;
  double? _resultado;
  bool _loading = false;
  String? _error;

  Future<void> _calcularRescisao() async {
    final salario = double.tryParse(_salarioController.text.replaceAll(',', '.'));
    final mesesTrabalhados = int.tryParse(_mesesTrabalhadosController.text);
    final saldoDias = int.tryParse(_saldoDiasController.text);

    if (salario == null || salario <= 0 || mesesTrabalhados == null || saldoDias == null) {
      setState(() {
        _error = 'Preencha todos os campos corretamente.';
        _resultado = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _resultado = null;
    });

    try {
      final uri = Uri.parse('http://localhost:3000/ETEC/calcularRescisao');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'salarioBase': salario,
          'mesesTrabalhados': mesesTrabalhados,
          'diasTrabalhados': saldoDias,
          'motivo': _motivo,
          'feriasVencidas': _feriasVencidas,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          setState(() {
            _resultado = (data['data']['recisao']['recisao'] as num).toDouble();
          });
        } else {
          setState(() {
            _error = 'Resposta inesperada da API.';
          });
        }
      } else {
        setState(() {
          _error = 'Erro ao calcular. Código: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _salarioController.dispose();
    _mesesTrabalhadosController.dispose();
    _saldoDiasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 122, 18),
        title: const Text(
          'Rescisão',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _buildTextField(_salarioController, 'Salário', Icons.money),
              const SizedBox(height: 16),
              _buildTextField(_mesesTrabalhadosController, 'Meses Trabalhados', Icons.calendar_today, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_saldoDiasController, 'Saldo de Dias', Icons.av_timer, isNumber: true),
              const SizedBox(height: 16),
              _buildDropdownMotivo(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _feriasVencidas,
                    onChanged: (value) {
                      setState(() {
                        _feriasVencidas = value ?? false;
                      });
                    },
                  ),
                  const Text('Férias Vencidas'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _calcularRescisao,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color.fromARGB(255, 233, 122, 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Calcular Rescisão',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 32),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              if (_resultado != null)
                Card(
                  color: Colors.orange.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Total da Rescisão',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'R\$ ${_resultado!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 233, 122, 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
            hintText: 'Digite $label'.toLowerCase(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownMotivo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonFormField<String>(
          value: _motivo,
          decoration: const InputDecoration(
            labelText: 'Motivo',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'semJustaCausa', child: Text('Sem Justa Causa')),
            DropdownMenuItem(value: 'JustaCausa', child: Text('Justa Causa')),
            DropdownMenuItem(value: 'PedidoDemissao', child: Text('Pedido de Demissão')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _motivo = value;
              });
            }
          },
        ),
      ),
    );
  }
}
