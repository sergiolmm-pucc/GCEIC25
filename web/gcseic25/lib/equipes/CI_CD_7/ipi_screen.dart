import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class IpiScreen extends StatefulWidget {
  @override
  _IpiScreenState createState() => _IpiScreenState();
}

class _IpiScreenState extends State<IpiScreen> {
  final _valorController = TextEditingController();
  final _percentualController = TextEditingController();
  double? _resultado;

  void _calcularIPI() async {
  final valor = double.tryParse(_valorController.text.replaceAll(',', '.'));
  final percentual = double.tryParse(_percentualController.text.replaceAll(',', '.'));

  if (valor != null && percentual != null) {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/CI_CD_7/ipi');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'valorProduto': valor,
        'percentualIPI': percentual,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _resultado = double.parse(data['ipi']);
      });
    } else {
      setState(() {
        _resultado = null;
      });
      print('Erro: ${response.body}');
    }
  } else {
    setState(() {
      _resultado = null;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cálculo de IPI')),
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
              decoration: InputDecoration(labelText: 'Percentual do IPI (%)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularIPI,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            if (_resultado != null)
              Text(
                'Valor do IPI: R\$ ${_resultado!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
