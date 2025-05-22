import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            'despesasVariaveis': double.parse(_despesasVariaveisController.text),
            'despesasFixas': double.parse(_despesasFixasController.text),
            'margemLucro': double.parse(_margemLucroController.text),
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _resultado = 'Markup: ${data['markup']}\nPreço de Venda: R\$ ${data['precoVenda']}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Markup Multiplicador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _custoController,
                decoration: InputDecoration(
                  labelText: 'Custo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validarCampo,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _despesasVariaveisController,
                decoration: InputDecoration(
                  labelText: 'Despesas Variáveis (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validarCampo,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _despesasFixasController,
                decoration: InputDecoration(
                  labelText: 'Despesas Fixas (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validarCampo,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _margemLucroController,
                decoration: InputDecoration(
                  labelText: 'Margem de Lucro (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validarCampo,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calcularMarkup,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Calcular',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 24),
              if (_resultado.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    _resultado,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
