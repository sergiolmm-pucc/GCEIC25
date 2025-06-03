import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaEletricaScreen extends StatefulWidget {
  @override
  _ConsultaEletricaScreenState createState() => _ConsultaEletricaScreenState();
}

class _ConsultaEletricaScreenState extends State<ConsultaEletricaScreen> {
  final _refletoresController = TextEditingController();
  final _potenciaBombaController = TextEditingController();
  final _horasUsoController = TextEditingController();
  final _tarifaEnergiaController = TextEditingController();

  String _resultado = '';

  Future<void> _calcularParteEletrica() async {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/calcularEletrica');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "quantidadeRefletores": int.tryParse(_refletoresController.text) ?? 0,
        "potenciaBombaHP": double.tryParse(_potenciaBombaController.text) ?? 0,
        "horasUsoDiario": double.tryParse(_horasUsoController.text) ?? 0,
        "tarifaEnergia": double.tryParse(_tarifaEnergiaController.text) ?? 0,
      }),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (!mounted) return;

    setState(() {
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        _resultado = 'Custo elétrico mensal estimado: R\$ ${data["custoEletricoMensal"]}';
      } catch (e) {
        _resultado = 'Erro ao interpretar resposta da API.';
      }
    } else {
      _resultado = 'Erro ao calcular: ${response.statusCode}';
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cálculo Elétrico',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildInputField(_refletoresController, 'Qtd. Refletores'),
                        SizedBox(height: 16),
                        _buildInputField(_potenciaBombaController, 'Potência da Bomba (HP)'),
                        SizedBox(height: 16),
                        _buildInputField(_horasUsoController, 'Horas de Uso Diário'),
                        SizedBox(height: 16),
                        _buildInputField(_tarifaEnergiaController, 'Tarifa de Energia (R\$/kWh)'),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _calcularParteEletrica,
                            child: Text(
                              'Calcular',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          _resultado,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }
}
