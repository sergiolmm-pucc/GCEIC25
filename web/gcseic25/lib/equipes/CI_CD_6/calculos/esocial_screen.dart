import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ESocialScreen extends StatefulWidget {
  const ESocialScreen({super.key});

  @override
  State<ESocialScreen> createState() => _ESocialScreenState();
}

class _ESocialScreenState extends State<ESocialScreen> {
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _dependentesController = TextEditingController();

  double? _eSocial;
  bool _loading = false;
  String? _error;

  Future<void> _calcularESocial() async {
    final salarioTexto = _salarioController.text.replaceAll(',', '.');
    final dependentesTexto = _dependentesController.text;

    final salario = double.tryParse(salarioTexto);
    final dependentes = int.tryParse(dependentesTexto);

    if (salario == null || salario <= 0 || dependentes == null || dependentes < 0 || dependentes > 9) {
      setState(() {
        _error = 'Insira valores válidos para salário e dependentes.';
        _eSocial = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _eSocial = null;
    });

    try {
      final uri = Uri.parse('https://animated-occipital-buckthorn.glitch.me/ETEC/calcularESocial');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'salario': salario,
          'dependentes': dependentes,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _eSocial = (data['data']['eSocial'] as num).toDouble();
          });
        } else {
          setState(() {
            _error = 'Resposta inesperada da API.';
          });
        }
      } else {
        setState(() {
          _error = 'Erro ao buscar dados. Código: ${response.statusCode}';
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
    _dependentesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 122, 18),
        title: const Text(
          'Cálculo eSocial',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildTextField(
              controller: _salarioController,
              label: 'Salário Bruto',
              icon: Icons.attach_money,
              hint: 'Digite o salário bruto',
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _dependentesController,
              label: 'Número de Dependentes',
              icon: Icons.group,
              hint: 'Digite o número de dependentes',
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _calcularESocial,
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
                        'Calcular eSocial',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (_eSocial != null) _buildResultadoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required TextInputType keyboard,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
        ),
      ),
    );
  }

  Widget _buildResultadoCard() {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultado do eSocial',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Valor: R\$ ${_eSocial!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 233, 122, 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
