import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImpactoAmbientalScreen extends StatefulWidget {
  @override
  State<ImpactoAmbientalScreen> createState() => _ImpactoAmbientalScreenState();
}

class _ImpactoAmbientalScreenState extends State<ImpactoAmbientalScreen> {
  final _potenciaController = TextEditingController();
  final _cidadeEstadoController = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _resultado;

  Future<void> calcularImpacto() async {
    if (_potenciaController.text.isEmpty || _cidadeEstadoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }
    setState(() {
      _loading = true;
      _resultado = null;
    });
    try {
      final url = Uri.parse('http://localhost:5000/calculation/impacto-ambiental');
      final body = {
        'potencia_kwp': double.parse(_potenciaController.text),
        'cidade_estado': _cidadeEstadoController.text,
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
    _potenciaController.dispose();
    _cidadeEstadoController.dispose();
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
            Text('CO₂ evitado por ano: ${_resultado!['co2_evitado_anual_kg']} kg'),
            Text('Árvores equivalentes: ${_resultado!['arvores_equivalentes']}'),
            Text('Distância de carro evitada: ${_resultado!['distancia_carro_evitada_km']} km'),
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
                    Text('Impacto Ambiental', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2))),
                    SizedBox(height: 24),
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
                    TextField(
                      controller: _cidadeEstadoController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city, color: Color(0xFF2196F3)),
                        labelText: 'Cidade-Estado (ex: São Paulo-SP)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : calcularImpacto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Calcular Impacto', style: TextStyle(fontSize: 18)),
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