import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalcularPage extends StatefulWidget {
  const CalcularPage({super.key});

  @override
  State<CalcularPage> createState() => _CalcularPageState();
}

class _CalcularPageState extends State<CalcularPage> {
  final _formKey = GlobalKey<FormState>();
  final _salarioCtrl = TextEditingController();
  final _mesesCtrl = TextEditingController();

  double? salarioLiquido;
  double? inssEmpregado;
  double? inssEmpregador;
  double? fgtsMensal;
  double? fgtsRescisorio;
  double? decimoTerceiro;
  double? ferias;
  double? totalMensal;

  bool _carregando = false;

  @override
  void dispose() {
    _salarioCtrl.dispose();
    _mesesCtrl.dispose();
    super.dispose();
  }

  Future<void> _calcular() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final salario = double.tryParse(_salarioCtrl.text) ?? 0;
    final meses = int.tryParse(_mesesCtrl.text) ?? 0;
    const baseUrl = 'https://animated-occipital-buckthorn.glitch.me/etec2';
    const urlLocalhost = 'http://localhost:3000/etec2';

    try {
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'salarioBruto': salario,
        'mesesTrabalhados': meses,
      });

      /*
      final responses = await Future.wait([
        http.post(Uri.parse('$urlLocalhost/salario-liquido'),headers: headers,body: body,),
        http.post(Uri.parse('$urlLocalhost/inss'), headers: headers, body: body),
        http.post(Uri.parse('$urlLocalhost/fgts'), headers: headers, body: body),
        http.post(Uri.parse('$urlLocalhost/decimo'), headers: headers, body: body),
        http.post(Uri.parse('$urlLocalhost/ferias'), headers: headers, body: body),
        http.post(Uri.parse('$urlLocalhost/total-mensal'),headers: headers,body: body,),
      ]);
        */
       
      final responses = await Future.wait([
        http.post(Uri.parse('$baseUrl/salario-liquido'),headers: headers,body: body,),
        http.post(Uri.parse('$baseUrl/inss'), headers: headers, body: body),
        http.post(Uri.parse('$baseUrl/fgts'), headers: headers, body: body),
        http.post(Uri.parse('$baseUrl/decimo'), headers: headers, body: body),
        http.post(Uri.parse('$baseUrl/ferias'), headers: headers, body: body),
        http.post(Uri.parse('$baseUrl/total-mensal'),headers: headers,body: body,),
      ]);
       
      setState(() {
        salarioLiquido = double.parse(
          jsonDecode(responses[0].body)['salarioLiquido'],
        );
        inssEmpregado = double.parse(
          jsonDecode(responses[1].body)['inssEmpregado'],
        );
        inssEmpregador = double.parse(
          jsonDecode(responses[1].body)['inssEmpregador'],
        );
        fgtsMensal = double.parse(jsonDecode(responses[2].body)['fgtsMensal']);
        fgtsRescisorio = double.parse(
          jsonDecode(responses[2].body)['fgtsRescisorio'],
        );
        decimoTerceiro = double.parse(
          jsonDecode(responses[3].body)['decimoTerceiro'],
        );
        ferias = double.parse(jsonDecode(responses[4].body)['ferias']);
        totalMensal = double.parse(
          jsonDecode(responses[5].body)['totalMensal'],
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao calcular: $e')));
    }

    setState(() => _carregando = false);
  }

  Widget _campoTexto(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Informe $label' : null,
    );
  }

  Widget _resultado(String titulo, double? valor) {
    return Card(
      color: Colors.white.withOpacity(0.95),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          valor != null ? 'R\$ ${valor.toStringAsFixed(2)}' : '--',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF005AA7),
          ),
        ),
      ),
    );
  }

Widget _botaoCalcular() {
  return Semantics(
    label: 'Calcular',
    button: true,
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _carregando
          ? const SizedBox(
              height: 56,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF005AA7), Color(0xFF00CDAC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_graph),
                    SizedBox(width: 10),
                    Text(
                      'Calcular',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.attach_money, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Cálculo de Encargos',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005AA7), Color(0xFF00CDAC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _campoTexto('Salário bruto (R\$)', _salarioCtrl),
                  const SizedBox(height: 20),
                  _campoTexto('Meses trabalhados', _mesesCtrl),
                  const SizedBox(height: 30),
                  _botaoCalcular(),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  const Text(
                    'Resultados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  _resultado('Salário líquido', salarioLiquido),
                  _resultado('INSS (Empregado)', inssEmpregado),
                  _resultado('INSS (Empregador)', inssEmpregador),
                  _resultado('FGTS Mensal', fgtsMensal),
                  _resultado('FGTS Rescisório', fgtsRescisorio),
                  _resultado('13º salário (proporcional)', decimoTerceiro),
                  _resultado('Férias + 1/3', ferias),
                  _resultado('Custo mensal total (estimado)', totalMensal),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
