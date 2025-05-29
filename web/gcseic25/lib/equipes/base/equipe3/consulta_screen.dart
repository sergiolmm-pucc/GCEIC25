import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaScreen extends StatefulWidget {
  @override
  _ConsultaScreenState createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  String _resposta = '';
  final _largura = TextEditingController();
  final _comprimento = TextEditingController();
  final _profundidade = TextEditingController();

  Future<void> _consultarAPI() async {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/MOB3/calcular'); 
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "largura": double.tryParse(_largura.text) ?? 0,
        "comprimento": double.tryParse(_comprimento.text) ?? 0,
        "profundidade": double.tryParse(_profundidade.text) ?? 0,
        "precoAgua": 4.5,
        "custoEletrico": 1200,
        "custoHidraulico": 900,
        "custoManutencaoMensal": 250
      }),
    );

    setState(() {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _resposta = 'Custo total da piscina: R\$ ${data["custoTotalPiscina"]}';
    } else {
      _resposta = 'Erro na requisição';
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consulta de Piscina')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _largura, decoration: InputDecoration(labelText: 'Largura')),
            TextField(controller: _comprimento, decoration: InputDecoration(labelText: 'Comprimento')),
            TextField(controller: _profundidade, decoration: InputDecoration(labelText: 'Profundidade')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _consultarAPI, child: Text('Calcular')),
            SizedBox(height: 20),
            Text(_resposta)
          ],
        ),
      ),
    );
  }
}
