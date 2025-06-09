import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrientacaoScreen extends StatefulWidget {
  @override
  State<OrientacaoScreen> createState() => _OrientacaoScreenState();
}

class _OrientacaoScreenState extends State<OrientacaoScreen> {
  final _cepController = TextEditingController();
  final _potenciaController = TextEditingController();
  bool _sombra = false;
  bool _loading = false;
  Map<String, dynamic>? _resultado;

  Future<void> calcularOrientacao() async {
    if (_cepController.text.isEmpty || _potenciaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }
    setState(() {
      _loading = true;
      _resultado = null;
    });
    try {
      final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/solar-panel/orientacao');
      final body = {
        'cep': _cepController.text,
        'potencia_kwp': double.parse(_potenciaController.text),
        'sombra': _sombra,
      };
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (resp.statusCode == 200) {
        setState(() => _resultado = jsonDecode(resp.body));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao calcular: ${resp.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _cepController.dispose();
    _potenciaController.dispose();
    super.dispose();
  }

  Widget _buildResultado() {
    if (_resultado == null) return SizedBox();
    return Card(
      color: Colors.white,
      elevation: 8,
      margin: EdgeInsets.only(top: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resultados:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2))),
            SizedBox(height: 12),
            Text('Inclinação ideal: ${_resultado!['inclinacao_ideal_graus']}°'),
            Text('Orientação ideal: ${_resultado!['orientacao_ideal']}'),
            Text('Tipo de inversor recomendado: ${_resultado!['tipo_inversor_recomendado']}'),
            Text('Tecnologias de painéis sugeridas:'),
            ...(_resultado!['tecnologias_paineis_sugeridas'] as List<dynamic>).map((t) => Text('- $t')).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFF2196F3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Orientação de Instalação', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2))),
                    SizedBox(height: 24),
                    TextField(
                      controller: _cepController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on, color: Color(0xFF2196F3)),
                        labelText: 'CEP',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _potenciaController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.bolt, color: Color(0xFF2196F3)),
                        labelText: 'Potência do sistema (kWp)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _sombra,
                          onChanged: (val) {
                            setState(() {
                              _sombra = val ?? false;
                            });
                          },
                        ),
                        Text('Há sombra significativa no local?'),
                      ],
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : calcularOrientacao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Calcular Orientação', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    _buildResultado(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 