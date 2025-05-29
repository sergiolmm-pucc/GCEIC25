import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegrasScreen extends StatefulWidget {
  const RegrasScreen({super.key});

  @override
  State<RegrasScreen> createState() => _RegrasScreenState();
}

class _RegrasScreenState extends State<RegrasScreen> {
  final idadeController = TextEditingController();
  final contribuicaoController = TextEditingController();

  String? sexo;
  String? categoria;
  List<String> regras = [];
  bool carregando = false;
  String mensagem = '';

  Future<void> calcularRegras() async {
    // Validação no frontend antes de enviar a requisição
    if (sexo == null || sexo!.isEmpty) {
      setState(() {
        mensagem = 'Por favor, selecione o sexo.';
        regras = [];
      });
      return;
    }

    if (categoria == null || categoria!.isEmpty) {
      setState(() {
        mensagem = 'Por favor, selecione a categoria.';
        regras = [];
      });
      return;
    }

    if (idadeController.text.isEmpty) {
      setState(() {
        mensagem = 'Por favor, informe a idade.';
        regras = [];
      });
      return;
    }

    if (contribuicaoController.text.isEmpty) {
      setState(() {
        mensagem = 'Por favor, informe o tempo de contribuição.';
        regras = [];
      });
      return;
    }

    // Validação para números negativos
    final idade = int.tryParse(idadeController.text);
    if (idade == null || idade < 0) {
      setState(() {
        mensagem = 'Idade inválida. Informe um número positivo.';
        regras = [];
      });
      return;
    }

    final tempoContribuicao = int.tryParse(contribuicaoController.text);
    if (tempoContribuicao == null || tempoContribuicao < 0) {
      setState(() {
        mensagem =
            'Tempo de contribuição inválido. Informe um número positivo.';
        regras = [];
      });
      return;
    }

    // Se chegou aqui, está tudo válido, pode continuar com a requisição
    final url = Uri.parse('https://animated-occipital-buckthorn.glitch.me/APOS/calculoRegra');

    setState(() {
      carregando = true;
      regras = [];
      mensagem = '';
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idade': idade,
          'tempoContribuicao': tempoContribuicao,
          'sexo': sexo,
          'categoria': categoria,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          regras = List<String>.from(data['regras'] ?? []);
          if (regras.isEmpty) {
            mensagem = 'Nenhuma regra aplicável encontrada.';
          }
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          mensagem = data['erro'] ?? 'Erro na comunicação com o servidor.';
        });
      }
    } catch (e) {
      setState(() {
        mensagem = 'Erro: $e';
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
                    Icon(Icons.rule, size: 42, color: Colors.teal),
                    SizedBox(width: 10),
                    Text(
                      'Regras de Aposentadoria',
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
                  'Verifique quais regras se aplicam ao seu caso:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 30),

                DropdownButtonFormField<String>(
                  value: sexo,
                  decoration: InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'masculino',
                      child: Text('Masculino'),
                    ),
                    DropdownMenuItem(
                      value: 'feminino',
                      child: Text('Feminino'),
                    ),
                  ],
                  onChanged: (value) => setState(() => sexo = value),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: idadeController,
                  decoration: InputDecoration(
                    labelText: 'Idade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.cake, color: primaryColor),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: contribuicaoController,
                  decoration: InputDecoration(
                    labelText: 'Tempo de Contribuição',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.access_time, color: primaryColor),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: categoria,
                  decoration: InputDecoration(
                    labelText: 'Categoria ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.work, color: primaryColor),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'comum', child: Text('Comum')),
                    DropdownMenuItem(
                      value: 'professor',
                      child: Text('Professor'),
                    ),
                    DropdownMenuItem(
                      value: 'deficiencia',
                      child: Text('Deficiência'),
                    ),
                    DropdownMenuItem(value: 'rural', child: Text('Rural')),
                    DropdownMenuItem(
                      value: 'programada',
                      child: Text('Programada'),
                    ),
                    DropdownMenuItem(
                      value: 'incapacidade',
                      child: Text('Incapacidade'),
                    ),
                  ],
                  onChanged: (value) => setState(() => categoria = value),
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
                            : const Icon(Icons.rule, size: 22),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        carregando ? 'Calculando...' : 'Ver Regras Aplicáveis',
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
                              calcularRegras();
                            },
                  ),
                ),

                const SizedBox(height: 40),

                if (mensagem.isNotEmpty)
                  Text(
                    mensagem,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),

                if (regras.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Regras aplicáveis:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...regras.map(
                        (regra) => Card(
                          color: Colors.teal.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle,
                              color: Colors.teal,
                            ),
                            title: Text(regra),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
