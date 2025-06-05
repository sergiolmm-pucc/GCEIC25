import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CofinsScreen extends StatefulWidget {
  @override
  _CofinsScreenState createState() => _CofinsScreenState();
}

class _CofinsScreenState extends State<CofinsScreen> {
  final _valorController = TextEditingController();
  final _percentualController = TextEditingController();
  double? _resultado;

  void _calcularCOFINS() async {
    final valor = double.tryParse(_valorController.text.replaceAll(',', '.'));
    final percentual = double.tryParse(_percentualController.text.replaceAll(',', '.'));

    if (valor != null && percentual != null) {
      final url = Uri.parse('http://localhost:3000/api/cofins');



      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'valorProduto': valor,
          'percentualCOFINS': percentual,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _resultado = double.parse(data['cofins']);
        });
      } else {
        setState(() => _resultado = null);
        print('Erro: ${response.body}');
      }
    } else {
      setState(() => _resultado = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cálculo de COFINS')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Valor do produto (R\$)'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _percentualController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Percentual do COFINS (%)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularCOFINS,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            if (_resultado != null)
              Text(
                'Valor do COFINS: R\$ ${_resultado!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
