import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculoScreen extends StatefulWidget {
  const CalculoScreen({Key? key}) : super(key: key);

  @override
  State<CalculoScreen> createState() => _CalculoScreenState();
}

class _CalculoScreenState extends State<CalculoScreen> {
  final idadeController = TextEditingController();
  final contribuicaoController = TextEditingController();

  String? _sexo; // "M" ou "F"

  String resultado = '';
  bool podeAposentar = false;
  bool carregando = false;

  bool validarCampos() {
    final idade = int.tryParse(idadeController.text);
    final contribuicao = int.tryParse(contribuicaoController.text);

    if (_sexo == null) {
      setState(() {
        resultado = 'Por favor, selecione o sexo.';
        podeAposentar = false;
      });
      return false;
    }

    if (idade == null || contribuicao == null) {
      setState(() {
        resultado = 'Preencha os campos com números válidos.';
        podeAposentar = false;
      });
      return false;
    }
    if (idade <= 0) {
      setState(() {
        resultado = 'Idade deve ser maior que zero.';
        podeAposentar = false;
      });
      return false;
    }
    if (idade > 120) {
      setState(() {
        resultado = 'Idade inválida.';
        podeAposentar = false;
      });
      return false;
    }
    if (contribuicao < 0) {
      setState(() {
        resultado = 'Contribuição não pode ser negativa.';
        podeAposentar = false;
      });
      return false;
    }
    if (contribuicao > idade) {
      setState(() {
        resultado = 'Contribuição não pode ser maior que a idade.';
        podeAposentar = false;
      });
      return false;
    }
    return true;
  }

  Future<void> calcularAposentadoria() async {
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/APOS/calculoAposentadoria');

    setState(() {
      carregando = true;
      resultado = '';
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idade': int.tryParse(idadeController.text) ?? 0,
          'contribuicao': int.tryParse(contribuicaoController.text) ?? 0,
          'sexo': _sexo, // envia o sexo para o backend
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          resultado = data['mensagem'];
          podeAposentar = data['podeAposentar'] ?? false;
        });
      } else {
        setState(() {
          resultado = 'Erro na comunicação com o servidor.';
          podeAposentar = false;
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'Erro: $e';
        podeAposentar = false;
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  void dispose() {
    idadeController.dispose();
    contribuicaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal.shade700;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calculate, size: 42, color: Colors.teal),
                    SizedBox(width: 10),
                    Text(
                      'Calculadora de Aposentadoria',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Use essa ferramenta para verificar se você já pode se aposentar com base na sua idade, anos de contribuição e sexo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 30),
                // Campo para selecionar o sexo
                DropdownButtonFormField<String>(
                  value: _sexo,
                  decoration: InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'F', child: Text('Feminino')),
                    DropdownMenuItem(value: 'M', child: Text('Masculino')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sexo = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: idadeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Idade atual',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.cake, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: contribuicaoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Anos de contribuição',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.access_time, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon:
                        carregando
                            ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(Icons.calculate, size: 22),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        carregando ? 'Calculando...' : 'Calcular',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        carregando
                            ? null
                            : () {
                              FocusScope.of(context).unfocus();
                              if (validarCampos()) {
                                calcularAposentadoria();
                              }
                            },
                  ),
                ),
                const SizedBox(height: 40),
                if (resultado.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    color:
                        podeAposentar
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 24,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            podeAposentar
                                ? Icons.check_circle_outline
                                : Icons.error_outline,
                            color: podeAposentar ? Colors.green : Colors.red,
                            size: 36,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              resultado,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:
                                    podeAposentar
                                        ? Colors.green.shade900
                                        : Colors.red.shade900,
                              ),
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
      ),
    );
  }
}
