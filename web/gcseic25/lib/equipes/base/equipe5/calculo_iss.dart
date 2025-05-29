import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculoIssPage extends StatefulWidget {
  const CalculoIssPage({super.key});

  @override
  State<CalculoIssPage> createState() => _CalculoIssPageState();
}

class _CalculoIssPageState extends State<CalculoIssPage> {
  final TextEditingController valorServicoController = TextEditingController();
  final TextEditingController aliquotaController = TextEditingController();
  String? resultado;

  Future<void> calcularISS() async {
    final double? valor = double.tryParse(valorServicoController.text);
    final double? aliquota = double.tryParse(aliquotaController.text);

    if (valor == null || aliquota == null) {
      setState(() => resultado = 'Preencha os valores corretamente.');
      return;
    }

    final url = Uri.parse('http://localhost:3000/impostos/iss');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'valorServico': valor, 'aliquotaISS': aliquota}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        resultado = 'Valor do ISS: R\$ ${json['imposto']}';
      });
    } else {
      setState(() {
        resultado = 'Erro ao calcular ISS. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo de ISS')),
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
                          label: 'Campo para inserir o valor do serviço',
                          textField: true,
                          child: TextField(
                            controller: valorServicoController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Valor do serviço'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          label: 'Campo para inserir a alíquota do ISS em porcentagem',
                          textField: true,
                          child: TextField(
                            controller: aliquotaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Alíquota (%)'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Semantics(
                          label: 'Botão para calcular o ISS',
                          button: true,
                          child: ElevatedButton(
                            onPressed: calcularISS,
                            child: const Text('Calcular ISS'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (resultado != null)
                    Semantics(
                      label: 'Resultado do cálculo do ISS',
                      readOnly: true,
                      child: Text(
                        resultado!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
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
