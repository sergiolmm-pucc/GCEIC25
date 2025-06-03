import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaHidraulicaScreen extends StatefulWidget {
  @override
  _ConsultaHidraulicaScreenState createState() => _ConsultaHidraulicaScreenState();
}

class _ConsultaHidraulicaScreenState extends State<ConsultaHidraulicaScreen> {
  final _tubulacaoController = TextEditingController();
  final _conexoesController = TextEditingController();
  final _precoTubulacaoController = TextEditingController();
  final _precoConexaoController = TextEditingController();
  final _maoDeObraController = TextEditingController();

  String _resultado = '';

  Future<void> _calcularParteHidraulica() async {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/calcularHidraulica');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "quantidadeTubulacao": double.tryParse(_tubulacaoController.text) ?? 0,
        "quantidadeConexoes": int.tryParse(_conexoesController.text) ?? 0,
        "precoPorMetroTubulacao": double.tryParse(_precoTubulacaoController.text) ?? 0,
        "precoPorConexao": double.tryParse(_precoConexaoController.text) ?? 0,
        "custoMaoDeObra": double.tryParse(_maoDeObraController.text) ?? 0,
      }),
    );

    setState(() {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _resultado = 'Custo total hidráulico estimado: R\$ ${data["custoTotalHidraulico"]}';
      } else {
        _resultado = 'Erro ao calcular.';
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
                              'Cálculo Hidráulico',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildInputField(_tubulacaoController, 'Qtd. Tubulação (m)'),
                        SizedBox(height: 16),
                        _buildInputField(_conexoesController, 'Qtd. Conexões'),
                        SizedBox(height: 16),
                        _buildInputField(_precoTubulacaoController, 'Preço/m Tubulação (R\$)'),
                        SizedBox(height: 16),
                        _buildInputField(_precoConexaoController, 'Preço/unid Conexão (R\$)'),
                        SizedBox(height: 16),
                        _buildInputField(_maoDeObraController, 'Custo Mão de Obra (R\$)'),
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
                            onPressed: _calcularParteHidraulica,
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
