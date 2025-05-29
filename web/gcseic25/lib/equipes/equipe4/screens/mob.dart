import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/tab_bar.dart'; 

class MOBPage extends StatefulWidget {
  const MOBPage({super.key});

  @override
  State<MOBPage> createState() => _MOBPageState();
}

class _MOBPageState extends State<MOBPage> {
  final TextEditingController transporteController = TextEditingController();
  final TextEditingController instalacaoController = TextEditingController();
  final TextEditingController maoDeObraController = TextEditingController();
  final TextEditingController equipamentosController = TextEditingController();

  String resultadoTotal = 'R\$ 0.000,00';

  Future<void> calcularMOB() async {
    final uri = Uri.parse('http://localhost:3000/CCP/mob');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'transporte': transporteController.text.trim(),
          'instalacao': instalacaoController.text.trim(),
          'maoDeObra': maoDeObraController.text.trim(),
          'equipamentos': equipamentosController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final double total = data['total'];
        setState(() {
          resultadoTotal = 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';
        });
      } else {
        final erro = jsonDecode(response.body);
        _mostrarErro(erro['error'] ?? 'Erro desconhecido');
      }
    } catch (e) {
      _mostrarErro('Erro ao conectar com a API');
    }
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'MOB',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: 520,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildInputField('Transporte de materiais', transporteController),
                        _buildInputField('Instalação de canteiros', instalacaoController),
                        _buildInputField('Mão de obra', maoDeObraController),
                        _buildInputField('Equipamentos', equipamentosController),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: calcularMOB,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CALCULAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 32),
                    Text(
                      resultadoTotal,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
