import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DecimoTerceiroScreen extends StatefulWidget {
  const DecimoTerceiroScreen({super.key});

  @override
  State<DecimoTerceiroScreen> createState() => _DecimoTerceiroScreenState();
}

class _DecimoTerceiroScreenState extends State<DecimoTerceiroScreen> {
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _mesesController = TextEditingController();
  double? _bruto;
  double? _inss;
  double? _liquido;
  bool _loading = false;
  String? _error;

  Future<void> _buscarDecimoTerceiro() async {
    final salarioTexto = _salarioController.text.replaceAll(',', '.');
    final salario = double.tryParse(salarioTexto);
    final meses = int.tryParse(_mesesController.text);

    if (salario == null ||
        salario <= 0 ||
        meses == null ||
        meses <= 0 ||
        meses > 12) {
      setState(() {
        _error = 'Insira um salário válido e meses entre 1 e 12.';
        _bruto = null;
        _inss = null;
        _liquido = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _bruto = null;
      _inss = null;
      _liquido = null;
    });

    try {
      final uri = Uri.parse(
        'https://animated-occipital-buckthorn.glitch.me/ETEC/calcularDecimoTerceiro',
      );
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'salario': salario, 'mesesTrabalhados': meses}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          setState(() {
            _bruto = (data['data']['bruto'] as num).toDouble();
            _inss = (data['data']['inss'] as num).toDouble();
            _liquido = (data['data']['liquido'] as num).toDouble();
          });
        } else {
          setState(() {
            _error = 'Resposta inesperada da API.';
          });
        }
      } else {
        setState(() {
          _error = 'Erro ao buscar dados. Código: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _salarioController.dispose();
    _mesesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 122, 18),
        title: const Text(
          '13º Salário',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _salarioController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Salário Líquido',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                          hintText: 'Digite o salário',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _mesesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Meses Trabalhados',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                          hintText: 'Ex: 11',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _buscarDecimoTerceiro,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color.fromARGB(255, 233, 122, 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Calcular 13º',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                ),
              ),
              const SizedBox(height: 32),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              if (_liquido != null)
                Card(
                  color: Colors.orange.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Resultado do 13º',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _infoItem('Bruto', _bruto),
                        _infoItem('INSS', _inss),
                        _infoItem('Líquido', _liquido, highlight: true),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(String label, double? value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value != null ? 'R\$ ${value.toStringAsFixed(2)}' : '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? const Color.fromARGB(255, 233, 122, 18) : null,
            ),
          ),
        ],
      ),
    );
  }
}
