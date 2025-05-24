import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculoIcmsPage extends StatefulWidget {
  const CalculoIcmsPage({super.key});

  @override
  State<CalculoIcmsPage> createState() => _CalculoIcmsPageState();
}

class _CalculoIcmsPageState extends State<CalculoIcmsPage> {
  final TextEditingController valorProdutoController = TextEditingController();
  final TextEditingController aliquotaController = TextEditingController();
  String? resultado;

  Future<void> calcularICMS() async {
    final double? valor = double.tryParse(valorProdutoController.text);
    final double? aliquota = double.tryParse(aliquotaController.text);

    if (valor == null || aliquota == null) {
      setState(() => resultado = 'Preencha os valores corretamente.');
      return;
    }

    final url = Uri.parse('http://localhost:3000/impostos/icms');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'valorProduto': valor, 'aliquotaICMS': aliquota}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        resultado = 'Valor do ICMS: R\$ ${json['imposto']}';
      });
    } else {
      setState(() {
        resultado = 'Erro ao calcular ICMS. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo de ICMS')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: valorProdutoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Valor do produto'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: aliquotaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Alíquota (%)'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: calcularICMS,
                        child: const Text('Calcular ICMS'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (resultado != null)
                  Text(
                    resultado!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}