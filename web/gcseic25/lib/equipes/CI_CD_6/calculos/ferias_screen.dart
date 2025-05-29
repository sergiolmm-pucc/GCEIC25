import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeriasScreen extends StatefulWidget {
  const FeriasScreen({super.key});

  @override
  State<FeriasScreen> createState() => _FeriasScreenState();
}

class _FeriasScreenState extends State<FeriasScreen> {
  final TextEditingController _salarioController = TextEditingController();
  double? _feriasMensal;
  bool _loading = false;
  String? _error;

  Future<void> _buscarFerias() async {
    final salarioTexto = _salarioController.text.replaceAll(',', '.');
    final salario = double.tryParse(salarioTexto);

    if (salario == null || salario <= 0) {
      setState(() {
        _error = 'Por favor, insira um salário válido.';
        _feriasMensal = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _feriasMensal = null;
    });

    try {
      final uri = Uri.parse('https://animated-occipital-buckthorn.glitch.me/ETEC/calcularFerias');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'salario': salario}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' && data['data'] != null) {
          setState(() {
            _feriasMensal = (data['data']['feriasMensal'] as num).toDouble();
          });
        } else {
          setState(() {
            _error = 'Resposta inesperada da API.';
          });
        }
      } else {
        setState(() {
          _error = 'Erro ao buscar dados. Código: ${response.statusCode}';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 122, 18),
        title: const Text(
          'Férias',
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
                  child: TextField(
                    controller: _salarioController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Salário Líquido',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                      hintText: 'Digite o salário líquido',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _buscarFerias,
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
                            'Buscar Férias',
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
              if (_feriasMensal != null)
                Card(
                  color: Colors.orange.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Férias Estimada',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'R\$ ${_feriasMensal!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 233, 122, 18),
                          ),
                        ),
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
}
