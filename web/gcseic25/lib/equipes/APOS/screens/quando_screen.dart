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
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/APOS/calculoTempoAposentadoria');
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _erro = null;
      _resultado = null;
    });

    try {
      final response = await http.post(
        url,
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
    final primaryColor = Colors.teal.shade700;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(Icons.hourglass_bottom, size: 60, color: Colors.teal.shade700),
                    const SizedBox(height: 12),
                    const Text(
                      'Quando posso me aposentar?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _idadeController,
                        decoration: InputDecoration(
                          labelText: 'Idade',
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today, color: primaryColor),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua idade';
                          }
                          final idade = int.tryParse(value);
                          if (idade == null || idade < 0 || idade > 120) {
                            return 'Por favor, insira uma idade válida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contribuicaoController,
                        decoration: InputDecoration(
                          labelText: 'Tempo de Contribuição (anos)',
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(Icons.work, color: primaryColor),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o tempo de contribuição';
                          }
                          final contribuicao = int.tryParse(value);
                          if (contribuicao == null || contribuicao < 0) {
                            return 'Por favor, insira um número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _sexoSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Sexo',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person, color: primaryColor),
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
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _calcularTempoAposentadoria,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                            : const Icon(Icons.calculate, color: Colors.white),
                        label: Text(
                          _isLoading ? 'Calculando...' : 'Calcular',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
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
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Ícone + Mensagem principal
                                Row(
                                  children: [
                                    Icon(
                                      _resultado!['anosPrevistosParaAposentar'] == 0
                                          ? Icons.check_circle_outline
                                          : Icons.access_time_outlined,
                                      color: _resultado!['anosPrevistosParaAposentar'] == 0
                                          ? Colors.green
                                          : Colors.orange,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _resultado!['mensagem'],
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 32, thickness: 1.5),

                                // Ano previsto e anos faltantes
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoItem(
                                      icon: Icons.calendar_today_outlined,
                                      label: 'Ano previsto',
                                      value: _resultado!['anoPrevisoAposentadoria'].toString(),
                                    ),
                                    _buildInfoItem(
                                      icon: Icons.timelapse_outlined,
                                      label: 'Anos faltantes',
                                      value: _resultado!['anosPrevistosParaAposentar'].toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Detalhes
                                const Text(
                                  'Detalhes da aposentadoria',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                _buildDetailRow(
                                  icon: Icons.person,
                                  title: 'Idade atual',
                                  subtitle: _resultado!['detalhes']['idadeAtual'].toString(),
                                ),
                                _buildDetailRow(
                                  icon: Icons.event,
                                  title: 'Idade na aposentadoria',
                                  subtitle: _resultado!['detalhes']['idadeNaAposentadoria'].toString(),
                                ),
                                _buildDetailRow(
                                  icon: Icons.work,
                                  title: 'Contribuição atual',
                                  subtitle: '${_resultado!['detalhes']['contribuicaoAtual']} anos',
                                ),
                                _buildDetailRow(
                                  icon: Icons.work_outline,
                                  title: 'Contribuição na aposentadoria',
                                  subtitle: '${_resultado!['detalhes']['contribuicaoNaAposentadoria']} anos',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoItem({required IconData icon, required String label, required String value}) {
  return Row(
    children: [
      Icon(icon, color: Colors.teal.shade400),
      const SizedBox(width: 6),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    ],
  );
}

Widget _buildDetailRow({required IconData icon, required String title, required String subtitle}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: Colors.teal.shade600),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle),
  );
}

