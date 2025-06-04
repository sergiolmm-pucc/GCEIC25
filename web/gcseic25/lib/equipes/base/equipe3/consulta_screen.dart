import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultaScreen extends StatefulWidget {
  @override
  _ConsultaScreenState createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  String _resposta = '';
  final _custoProdutosLimpeza = TextEditingController();
  final _custoMaoDeObra = TextEditingController();
  final _custoTrocaFiltro = TextEditingController();


  Future<void> _consultarAPI() async {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/calcular');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "custoProdutosLimpeza": double.tryParse(_custoProdutosLimpeza.text) ?? 0,
        "custoMaoDeObra": double.tryParse(_custoMaoDeObra.text) ?? 0,
        "custoTrocaFiltro": double.tryParse(_custoTrocaFiltro.text) ?? 0,
      }),
    );

    setState(() {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _resposta = 'Custo total da manutenção da piscina: R\$ ${data["custoTotalPiscina"]}';
      } else {
        _resposta = 'Erro na requisição';
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
                  child: RepaintBoundary(
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
                                'Custos da Manutenção',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildInputField('Custo Produtos Limpeza', _custoProdutosLimpeza),
                          SizedBox(height: 16),
                          _buildInputField('Custo Mão de Obra', _custoMaoDeObra),
                          SizedBox(height: 16),
                          _buildInputField('Custo Troca de Filtro', _custoTrocaFiltro),
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
