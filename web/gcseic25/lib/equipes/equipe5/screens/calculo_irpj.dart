import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculoIrpjPage extends StatefulWidget {
  const CalculoIrpjPage({super.key});

  @override
  State<CalculoIrpjPage> createState() => _CalculoIrpjPageState();
}

class _CalculoIrpjPageState extends State<CalculoIrpjPage> {
  final TextEditingController lucroController = TextEditingController();
  bool isLucroReal = true;
  String? resultado;

  Future<void> calcularIRPJ() async {
    final double? lucro = double.tryParse(lucroController.text);
    if (lucro == null) {
      setState(() => resultado = 'Preencha o valor do lucro corretamente.');
      return;
    }

    final url = Uri.parse('http://localhost:3000/impostos/irpj');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'lucroTributavel': lucro,
        'isLucroReal': isLucroReal,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        resultado =
            'Regime: ${json['regime']}\n'
            'Lucro Tributável: R\$ ${json['lucroTributavel']}\n'
            'Alíquota: ${json['aliquotaIRPJ']}%\n'
            'Imposto: R\$ ${json['imposto']}\n'
            'Obs: ${json['observacao']}';
      });
    } else {
      setState(() {
        resultado = 'Erro ao calcular IRPJ. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo de IRPJ')),
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
              Semantics(
                label: 'Campo de lucro tributável',
                textField: true,
                child: TextField(
                  controller: lucroController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Lucro Tributável'),
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Selecione o regime tributário',
                child: Row(
                  children: [
                    const Text('Regime:'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<bool>(
                        value: isLucroReal,
                        onChanged: (value) {
                          setState(() {
                            isLucroReal = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: true,
                            child: Text('Lucro Real'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Lucro Presumido'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Semantics(
                label: 'Botão para calcular IRPJ',
                button: true,
                child: ElevatedButton(
                  onPressed: calcularIRPJ,
                  child: const Text('Calcular IRPJ'),
                ),
              ),
              const SizedBox(height: 16),
              if (resultado != null)
                Semantics(
                  label: 'Resultado do cálculo do IRPJ',
                  readOnly: true,
                  child: Text(
                    resultado!,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
