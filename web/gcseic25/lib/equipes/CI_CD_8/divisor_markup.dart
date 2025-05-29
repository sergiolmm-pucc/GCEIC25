import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DivisorMarkupPage extends StatefulWidget {
  @override
  _DivisorMarkupPageState createState() => _DivisorMarkupPageState();
}

class _DivisorMarkupPageState extends State<DivisorMarkupPage> {
  final _formKey = GlobalKey<FormState>();
  final _precoVendaController = TextEditingController();
  final _custoTotalVendasController = TextEditingController();
  String _resultado = '';

  Future<void> _calcularMarkup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://animated-occipital-buckthorn.glitch.me/MKP2/calcDivisorMarkup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'precoVenda': double.parse(_precoVendaController.text),
            'custoTotalVendas': double.parse(_custoTotalVendasController.text),
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _resultado = 'Divisor do Markup: ${response.body}';
          });
        } else {
          setState(() {
            _resultado = 'Erro ao calcular o divisor do markup';
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
    if (numero <= 0) {
      return 'O valor deve ser maior que zero';
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
                controller: _precoVendaController,
                decoration: InputDecoration(
                  labelText: 'Preço de Venda',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validarCampo,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _custoTotalVendasController,
                decoration: InputDecoration(
                  labelText: 'Custo Total de Vendas',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validarCampo,
              ),
              SizedBox(height: 16),
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
    _precoVendaController.dispose();
    _custoTotalVendasController.dispose();
    super.dispose();
  }
}
