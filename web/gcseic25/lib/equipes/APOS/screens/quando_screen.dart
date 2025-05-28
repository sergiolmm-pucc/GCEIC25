import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuandoScreen extends StatefulWidget {
  const QuandoScreen({Key? key}) : super(key: key);

  @override
  _QuandoScreenState createState() => _QuandoScreenState();
}

class _QuandoScreenState extends State<QuandoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _contribuicaoController = TextEditingController();
  String _sexoSelecionado = 'M';
  Map<String, dynamic>? _resultado;
  bool _isLoading = false;
  String? _erro;

  Future<void> _calcularTempoAposentadoria() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _erro = null;
      _resultado = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://sincere-magnificent-cobweb.glitch.me/APOS/calculoTempoAposentadoria'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idade': int.parse(_idadeController.text),
          'contribuicao': int.parse(_contribuicaoController.text),
          'sexo': _sexoSelecionado,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _resultado = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _erro = 'Erro ao calcular tempo para aposentadoria';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro de conexão: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quando Posso me Aposentar?'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _idadeController,
                        decoration: const InputDecoration(
                          labelText: 'Idade',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua idade';
                          }
                          final idade = int.tryParse(value);
                          if (idade == null) {
                            return 'Por favor, insira um número válido';
                          }
                          if (idade < 0 || idade > 120) {
                            return 'Por favor, insira uma idade válida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contribuicaoController,
                        decoration: const InputDecoration(
                          labelText: 'Tempo de Contribuição (anos)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.work),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o tempo de contribuição';
                          }
                          final contribuicao = int.tryParse(value);
                          if (contribuicao == null) {
                            return 'Por favor, insira um número válido';
                          }
                          if (contribuicao < 0) {
                            return 'O tempo de contribuição não pode ser negativo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _sexoSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Sexo',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'M', child: Text('Masculino')),
                          DropdownMenuItem(value: 'F', child: Text('Feminino')),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _sexoSelecionado = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _calcularTempoAposentadoria,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                ),
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.calculate),
                label: Text(
                  _isLoading ? 'Calculando...' : 'Calcular',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              if (_erro != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Card(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _erro!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_resultado != null) ...[
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _resultado!['anosPrevistosParaAposentar'] == 0
                                  ? Icons.check_circle
                                  : Icons.access_time,
                              color: _resultado!['anosPrevistosParaAposentar'] == 0
                                  ? Colors.green
                                  : Colors.orange,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _resultado!['mensagem'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        Text(
                          'Ano previsto para aposentadoria: ${_resultado!['anoPrevisoAposentadoria']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Anos faltantes: ${_resultado!['anosPrevistosParaAposentar']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Detalhes:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(
                            'Idade atual: ${_resultado!['detalhes']['idadeAtual']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            'Idade na aposentadoria: ${_resultado!['detalhes']['idadeNaAposentadoria']}',
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.work_outline),
                          title: Text(
                            'Contribuição atual: ${_resultado!['detalhes']['contribuicaoAtual']} anos',
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            'Contribuição na aposentadoria: ${_resultado!['detalhes']['contribuicaoNaAposentadoria']} anos',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
