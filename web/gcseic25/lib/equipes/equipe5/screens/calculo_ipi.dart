import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculoIpiPage extends StatefulWidget {
  const CalculoIpiPage({super.key});

  @override
  State<CalculoIpiPage> createState() => _CalculoIpiPageState();
}

class _CalculoIpiPageState extends State<CalculoIpiPage> {
  final TextEditingController valorProdutoController = TextEditingController();
  final TextEditingController aliquotaController = TextEditingController();
  final TextEditingController freteController = TextEditingController();
  final TextEditingController despesasController = TextEditingController();

  String? resultado;

  Future<void> calcularIPI() async {
    final double? valor = double.tryParse(valorProdutoController.text);
    final double? aliquota = double.tryParse(aliquotaController.text);
    final double? frete = double.tryParse(freteController.text);
    final double? despesas = double.tryParse(despesasController.text);

    if (valor == null || aliquota == null) {
      setState(() => resultado = 'Preencha pelo menos valor do produto e alíquota.');
      return;
    }

    final url = Uri.parse('http://localhost:3000/impostos/ipi');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'valorProduto': valor,
        'aliquotaIPI': aliquota,
        'frete': frete ?? 0,
        'despesasAcessorias': despesas ?? 0,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        resultado =
            'Base de cálculo: R\$ ${json['baseCalculo']}\nValor do IPI: R\$ ${json['imposto']}';
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          label: 'Valor do produto',
                          textField: true,
                          child: TextField(
                            controller: valorProdutoController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Valor do produto'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          label: 'Alíquota',
                          textField: true,
                          child: TextField(
                            controller: aliquotaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Alíquota (%)'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          label: 'Frete',
                          textField: true,
                          child: TextField(
                            controller: freteController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Frete'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          label: 'Despesas acessórias',
                          textField: true,
                          child: TextField(
                            controller: despesasController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Despesas acessórias'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Semantics(
                          label: 'Calcular IPI',
                          button: true,
                          child: ElevatedButton(
                            onPressed: calcularIPI,
                            child: const Text('Calcular IPI'),
                          ),
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
      ),
    );
  }
}
