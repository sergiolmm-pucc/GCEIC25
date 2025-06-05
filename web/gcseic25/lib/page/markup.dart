import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sobre_page.dart';
import 'help.dart';

class MultiplierMarkupPage extends StatefulWidget {
  @override
  _MultiplierMarkupPageState createState() => _MultiplierMarkupPageState();
}

class _MultiplierMarkupPageState extends State<MultiplierMarkupPage> {
  final _formKey = GlobalKey<FormState>();
  final _custoController = TextEditingController();
  final _despesasVariaveisController = TextEditingController();
  final _despesasFixasController = TextEditingController();
  final _margemLucroController = TextEditingController();

  String _resultado = '';

  Future<void> _calcularMarkup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/markup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'custo': double.parse(_custoController.text),
            'despesasVariaveis': double.parse(
              _despesasVariaveisController.text,
            ),
            'despesasFixas': double.parse(_despesasFixasController.text),
            'margemLucro': double.parse(_margemLucroController.text),
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _resultado =
                'Markup: ${data['markup']}\nPreço de Venda: R\$ ${data['precoVenda']}';
          });
        } else {
          final data = jsonDecode(response.body);
          setState(() {
            _resultado = 'Erro: ${data['error'] ?? 'Erro ao calcular'}';
          });
        }
      } catch (e) {
        setState(() {
          _resultado = 'Erro ao conectar com o servidor';
        });
      }
    }
  }

  String? _validarCampo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    final numero = double.tryParse(value);
    if (numero == null || numero < 0) {
      return 'Digite um número válido e >= 0';
    }
    return null;
  }

  @override
  void dispose() {
    _custoController.dispose();
    _despesasVariaveisController.dispose();
    _despesasFixasController.dispose();
    _margemLucroController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      keyboardType: TextInputType.number,
      validator: _validarCampo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Calculadora de Markup'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(
                  Icons.calculate_outlined,
                  size: 80,
                  color: Colors.blue[700],
                ),
                const SizedBox(height: 24),
                _buildInputField(
                  controller: _custoController,
                  label: 'Custo',
                  icon: Icons.attach_money,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _despesasVariaveisController,
                  label: 'Despesas Variáveis (%)',
                  icon: Icons.percent,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _despesasFixasController,
                  label: 'Despesas Fixas (%)',
                  icon: Icons.percent,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _margemLucroController,
                  label: 'Margem de Lucro (%)',
                  icon: Icons.show_chart,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _calcularMarkup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Calcular',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_resultado.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      _resultado,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SobrePage()),
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Sobre o App'),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HelpPage()),
                        );
                      },
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Help'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}