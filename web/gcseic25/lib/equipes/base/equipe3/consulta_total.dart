import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaTotalScreen extends StatefulWidget {
  @override
  _ConsultaTotalScreenState createState() => _ConsultaTotalScreenState();
}

class _ConsultaTotalScreenState extends State<ConsultaTotalScreen> {
  String _resposta = '';

  final _precoEletrica = TextEditingController();
  final _precoHidraulica = TextEditingController();
  final _precoManutencao = TextEditingController();

  Future<void> _consultarAPI() async {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/calcularCustoTotal');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "custoEletrica": double.tryParse(_precoEletrica.text) ?? 0,
        "custoHidraulica": double.tryParse(_precoHidraulica.text) ?? 0,
        "custoManutencao": double.tryParse(_precoManutencao.text) ?? 0,
      }),
    );

    setState(() {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _resposta = 'Custo total calculado: R\$ ${data["custoTotalGeral"]}';
      } else {
        _resposta = 'Erro na requisição: código ${response.statusCode}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary( 
        child: Container(
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
                        mainAxisSize: MainAxisSize.min,
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
                                'Consulta Custo Total',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildInputField('Preço da parte elétrica', _precoEletrica),
                          SizedBox(height: 16),
                          _buildInputField('Preço da parte hidráulica', _precoHidraulica),
                          SizedBox(height: 16),
                          _buildInputField('Preço da manutenção', _precoManutencao),
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
                              onPressed: _consultarAPI,
                              child: Text(
                                'Calcular',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            _resposta,
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
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }
}
