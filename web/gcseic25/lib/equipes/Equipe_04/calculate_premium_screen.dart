import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiBaseUrl = 'https://animated-occipital-buckthorn.glitch.me';

class CalculatePremiumScreen extends StatefulWidget {
  @override
  _CalculatePremiumScreenState createState() => _CalculatePremiumScreenState();
}

class _CalculatePremiumScreenState extends State<CalculatePremiumScreen> {
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _tempoHabilitacaoController = TextEditingController();
  String? _resultado;
  bool _loading = false;

  Future<void> _calcularSeguro() async {
    setState(() {
      _loading = true;
      _resultado = null;
    });

    final url = Uri.parse('$apiBaseUrl/calculatepremium/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'year': int.tryParse(_anoController.text.trim()),
          'make': _marcaController.text.trim(),
          'model': _modeloController.text.trim(),
          'driverAge': int.tryParse(_idadeController.text.trim()),
          'licenseDuration': int.tryParse(_tempoHabilitacaoController.text.trim()),
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _resultado = data['mensagem'] ?? 'Cálculo realizado!';
        });
      } else {
        setState(() {
          _resultado = 'Erro ao calcular seguro.';
        });
      }
    } catch (e) {
      setState(() {
        _resultado = 'Erro de conexão: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Calcular Seguro'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Preencha os dados para calcular o seguro',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                _buildTextField(_anoController, 'Ano do veículo'),
                SizedBox(height: 16),
                _buildTextField(_marcaController, 'Marca'),
                SizedBox(height: 16),
                _buildTextField(_modeloController, 'Modelo'),
                SizedBox(height: 16),
                _buildTextField(_idadeController, 'Idade do motorista'),
                SizedBox(height: 16),
                _buildTextField(_tempoHabilitacaoController, 'Tempo de habilitação (anos)'),
                SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _calcularSeguro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: _loading
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text('Calcular'),
                  ),
                ),
                SizedBox(height: 32),
                if (_resultado != null)
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _resultado!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.black),
      keyboardType: label.contains('Ano') || label.contains('Idade') || label.contains('Tempo')
          ? TextInputType.number
          : TextInputType.text,
    );
  }
} 