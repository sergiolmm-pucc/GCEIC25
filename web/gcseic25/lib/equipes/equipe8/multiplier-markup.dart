import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MultiplierMarkupPage extends StatefulWidget {
  @override
  _MultiplierMarkupPageState createState() => _MultiplierMarkupPageState();
}

class _MultiplierMarkupPageState extends State<MultiplierMarkupPage> {
  final _formKey = GlobalKey<FormState>();
  final _despesasVariaveisController = TextEditingController();
  final _despesasFixasController = TextEditingController();
  final _margemLucroController = TextEditingController();
  String _resultado = '';

  Future<void> _calcularMarkup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/MKP2/calcMultiplierMarkup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'despesasVariaveis': double.parse(_despesasVariaveisController.text),
            'despesasFixas': double.parse(_despesasFixasController.text),
            'margemLucro': double.parse(_margemLucroController.text),
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _resultado = 'Multiplicador do Markup: ${response.body}';
          });
        } else {
          setState(() {
            _resultado = 'Erro ao calcular o markup';
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
    double numero = double.tryParse(value) ?? -1;
    if (numero < 0 || numero > 100) {
      return 'O valor deve estar entre 0 e 100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Markup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
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

  @override
  void dispose() {
    _despesasVariaveisController.dispose();
    _despesasFixasController.dispose();
    _margemLucroController.dispose();
    super.dispose();
  }
}
