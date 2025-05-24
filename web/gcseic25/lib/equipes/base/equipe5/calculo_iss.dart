import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculoIssPage extends StatefulWidget {
  const CalculoIssPage({super.key});

  @override
  State<CalculoIssPage> createState() => _CalculoIssPageState();
}

class _CalculoIssPageState extends State<CalculoIssPage>{
  final TextEditingController valorProdutoController = TextEditingController();
  final TextEditingController aliquotaController = TextEditingController();
  String? resultado;

  Future<void> calcularIPI() async {
    final double? valor = double.tryParse(valorProdutoController.text);
    final double? aliquota = double.tryParse(aliquotaController.text);

    if (valor == null || aliquota == null) {
      setState(() => resultado = 'Preencha os valores corretamente.');
      return;
    }

    final url = Uri.parse('http://localhost:3000/api/ipi'); // ajuste se necessário

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'valorProduto': valor, 'aliquota': aliquota}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        resultado = 'Valor do IPI: R\$ ${json['ipi'].toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        resultado = 'Erro ao calcular IPI. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo de IPI')),
      body: Center(
        child: Container(
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
                onPressed: calcularIPI,
                child: const Text('Calcular IPI'),
              ),
              const SizedBox(height: 16),
              if (resultado != null)
                Text(resultado!, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}