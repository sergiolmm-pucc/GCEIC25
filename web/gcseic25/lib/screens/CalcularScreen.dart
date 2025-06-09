import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalcularScreen extends StatefulWidget {
  const CalcularScreen({super.key});

  @override
  _CalcularScreenState createState() => _CalcularScreenState();
}

class _CalcularScreenState extends State<CalcularScreen> {
  final _consumoController    = TextEditingController();
  final _horasSolController   = TextEditingController();
  final _tarifaController     = TextEditingController();
  final _precoContaController = TextEditingController();
  final _espacoController     = TextEditingController();

  bool _loading = false;
  Map<String, dynamic>? _resultado;

  Future<void> calcularSistema() async {
    if (_consumoController.text.isEmpty ||
        _horasSolController.text.isEmpty ||
        _tarifaController.text.isEmpty ||
        _precoContaController.text.isEmpty ||
        _espacoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _resultado = null;
    });

    try {
      final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/solar-panel/calcular');
      final body = {
        'consumo_mensal_kwh':    double.parse(_consumoController.text),
        'horas_sol_dia':         double.parse(_horasSolController.text),
        'tarifa_energia':        double.parse(_tarifaController.text),
        'preco_medio_conta':     double.parse(_precoContaController.text),
        'espaco_disponivel_m2':  double.parse(_espacoController.text),
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
    _consumoController.dispose();
    _horasSolController.dispose();
    _tarifaController.dispose();
    _precoContaController.dispose();
    _espacoController.dispose();
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
            Text('Potência necessária: ${_resultado!['potencia_necessaria_kwp']} kWp'),
            Text('Quantidade de painéis: ${_resultado!['quantidade_paineis']}'),
            Text('Área necessária: ${_resultado!['area_necessaria_m2']} m²'),
            Text('Espaço disponível: ${_resultado!['espaco_disponivel_m2']} m²'),
            Text('Espaço suficiente? ${_resultado!['espaco_suficiente'] ? 'Sim' : 'Não'}'),
            if (!_resultado!['espaco_suficiente'])
              Text('Área extra necessária: ${_resultado!['area_extra_necessaria_m2']} m²'),
            Text('Custo total: R\$ ${_resultado!['custo_total_r\$']}'),
            Text('Payback: ${_resultado!['payback_anos']} anos'),
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
                    Text('Simulação de Cálculo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2))),
                    SizedBox(height: 24),
                    TextField(
                      controller: _consumoController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.bolt, color: Color(0xFF2196F3)),
                        labelText: 'Consumo mensal (kWh)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _horasSolController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.wb_sunny, color: Color(0xFF2196F3)),
                        labelText: 'Horas de sol por dia',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _tarifaController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money, color: Color(0xFF2196F3)),
                        labelText: 'Tarifa de energia (R\$/kWh)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _precoContaController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.receipt_long, color: Color(0xFF2196F3)),
                        labelText: 'Preço médio da conta (R\$)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _espacoController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.square_foot, color: Color(0xFF2196F3)),
                        labelText: 'Espaço disponível (m²)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : calcularSistema,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Calcular', style: TextStyle(fontSize: 18)),
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