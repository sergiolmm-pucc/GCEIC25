import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaEletricaScreen extends StatefulWidget {
  @override
  _ConsultaEletricaScreenState createState() => _ConsultaEletricaScreenState();
}

class _ConsultaEletricaScreenState extends State<ConsultaEletricaScreen> {
  final _comprimentoFiosController = TextEditingController();
  final _precoPorMetroFioController = TextEditingController();
  final _quantidadeDisjuntoresController = TextEditingController();
  final _precoPorDisjuntorController = TextEditingController();
  final _custoMaoDeObraController = TextEditingController();

  String _resultado = '';

  Future<void> _calcularParteEletrica() async {
    if (_comprimentoFiosController.text.isEmpty ||
        _precoPorMetroFioController.text.isEmpty ||
        _quantidadeDisjuntoresController.text.isEmpty ||
        _precoPorDisjuntorController.text.isEmpty ||
        _custoMaoDeObraController.text.isEmpty) {
      setState(() {
        _resultado = 'Por favor, preencha todos os campos com valores válidos.';
      });
      return;
    }

    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/calcularEletrica');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "comprimentoFios": double.tryParse(_comprimentoFiosController.text) ?? 0,
        "precoPorMetroFio": double.tryParse(_precoPorMetroFioController.text) ?? 0,
        "quantidadeDisjuntores": int.tryParse(_quantidadeDisjuntoresController.text) ?? 0,
        "precoPorDisjuntor": double.tryParse(_precoPorDisjuntorController.text) ?? 0,
        "custoMaoDeObra": double.tryParse(_custoMaoDeObraController.text) ?? 0,
      }),
    );

    if (!mounted) return;

    setState(() {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _resultado = 'Custo elétrico estimado: R\$ ${data["custoTotalEletrico"]}';
      } else {
        _resultado = 'Erro ao calcular. Verifique os dados e tente novamente.';
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
                        _buildInputField(_comprimentoFiosController, 'Comprimento dos Fios (metros)', isInteger: false),
                        SizedBox(height: 16),
                        _buildInputField(_precoPorMetroFioController, 'Preço por metro do fio (R\$)', isInteger: false),
                        SizedBox(height: 16),
                        _buildInputField(_quantidadeDisjuntoresController, 'Quantidade de disjuntores', isInteger: true),
                        SizedBox(height: 16),
                        _buildInputField(_precoPorDisjuntorController, 'Preço por disjuntor (R\$)', isInteger: false),
                        SizedBox(height: 16),
                        _buildInputField(_custoMaoDeObraController, 'Custo da mão de obra (R\$)', isInteger: false),
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

  Widget _buildInputField(TextEditingController controller, String label, {bool isInteger = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          isInteger
              ? RegExp(r'^\d+$') 
              : RegExp(r'^\d*\.?\d{0,2}$'), 
        ),
      ],
    );
  }
}
