import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SolarApp());
}

class SolarApp extends StatelessWidget {
  const SolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Solar',
      home: SolarHomePage(),
    );
  }
}

class SolarHomePage extends StatefulWidget {
  const SolarHomePage({super.key});

  @override
  _SolarHomePageState createState() => _SolarHomePageState();
}

class _SolarHomePageState extends State<SolarHomePage> {
  final _consumoController    = TextEditingController();
  final _horasSolController   = TextEditingController();
  final _tarifaController     = TextEditingController();
  final _precoContaController = TextEditingController();
  final _espacoController     = TextEditingController();

  bool _loading = false;
  Map<String, dynamic>? _resultado;

  Future<void> calcularSistema() async {
    // validação simples
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
      final url = Uri.parse('http://000.000.00.000:5000/calcular'); // colocar o ip que será fornecido no ngrok (talvez precise habilitar a porta 5000 no firewall), podem ser usadas outras portas, vai da preferência do dev
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text('Resultados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulador Solar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _consumoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Consumo mensal (kWh)'),
            ),
            TextField(
              controller: _horasSolController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Horas de sol por dia'),
            ),
            TextField(
              controller: _tarifaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Tarifa de energia (R\$/kWh)'),
            ),
            TextField(
              controller: _precoContaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Preço médio da conta (R\$)'),
            ),
            TextField(
              controller: _espacoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Espaço disponível (m²)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : calcularSistema,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Calcular'),
            ),
            const SizedBox(height: 20),
            _buildResultado(),
          ],
        ),
      ),
    );
  }
}
