import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Import necessário para inputFormatters
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/tab_bar.dart';

class EletricMaterialPage extends StatefulWidget {
  const EletricMaterialPage({super.key});

  @override
  State<EletricMaterialPage> createState() => _EletricMaterialPageState();
}

class _EletricMaterialPageState extends State<EletricMaterialPage> {
  final TextEditingController quantidadeLuzController = TextEditingController();
  final TextEditingController pricelightController = TextEditingController();

  final TextEditingController metrofioController = TextEditingController();
  final TextEditingController pricefioController = TextEditingController();

  final TextEditingController qtdcomandoController = TextEditingController();
  final TextEditingController priceComandoController = TextEditingController();

  final TextEditingController qtdDisjuntorController = TextEditingController();
  final TextEditingController priceDisjuntorController = TextEditingController();

  final TextEditingController qtdDprogramadorController = TextEditingController();
  final TextEditingController priceProgramadorController = TextEditingController();

  String resultado = '';
  bool isLoading = false;

  bool get _todosCamposPreenchidos {
    return 
      quantidadeLuzController.text.isNotEmpty &&
      pricelightController.text.isNotEmpty &&
      metrofioController.text.isNotEmpty &&
      pricefioController.text.isNotEmpty &&
      qtdcomandoController.text.isNotEmpty &&
      priceComandoController.text.isNotEmpty &&
      qtdDisjuntorController.text.isNotEmpty &&
      priceDisjuntorController.text.isNotEmpty &&
      qtdDprogramadorController.text.isNotEmpty &&
      priceProgramadorController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    quantidadeLuzController.addListener(_onInputChanged);
    pricelightController.addListener(_onInputChanged);
    metrofioController.addListener(_onInputChanged);
    pricefioController.addListener(_onInputChanged);
    qtdcomandoController.addListener(_onInputChanged);
    priceComandoController.addListener(_onInputChanged);
    qtdDisjuntorController.addListener(_onInputChanged);
    priceDisjuntorController.addListener(_onInputChanged);
    qtdDprogramadorController.addListener(_onInputChanged);
    priceProgramadorController.addListener(_onInputChanged);
  }

  void _onInputChanged() => setState(() {});

  @override
  void dispose() {
    quantidadeLuzController.dispose();
    pricelightController.dispose();
    metrofioController.dispose();
    pricefioController.dispose();
    qtdcomandoController.dispose();
    priceComandoController.dispose();
    qtdDisjuntorController.dispose();
    priceDisjuntorController.dispose();
    qtdDprogramadorController.dispose();
    priceProgramadorController.dispose();
    super.dispose();
  }

  Future<void> calcularCustoEletrico() async {
    setState(() {
      isLoading = true;
      resultado = '';
    });

    final url = Uri.parse('http://localhost:3000/CCP/eletrico');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'luminaria_qtd': int.parse(quantidadeLuzController.text),
          'luminaria_preco': double.parse(pricelightController.text.replaceAll(',', '.')),
          'fio_metros': int.parse(metrofioController.text),
          'fio_preco': double.parse(pricefioController.text.replaceAll(',', '.')),
          'comando_qtd': int.parse(qtdcomandoController.text),
          'comando_preco': double.parse(priceComandoController.text.replaceAll(',', '.')),
          'disjuntor_qtd': int.parse(qtdDisjuntorController.text),
          'disjuntor_preco': double.parse(priceDisjuntorController.text.replaceAll(',', '.')),
          'programador_qtd': int.parse(qtdDprogramadorController.text),
          'programador_preco': double.parse(priceProgramadorController.text.replaceAll(',', '.')),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          resultado = 'R\$ ${data["custo_mensal"]}';
        });
      } else {
        setState(() {
          resultado = 'Erro ao calcular: ${json.decode(response.body)['error']}';
        });
      }
    } catch (e) {
      setState(() {
        resultado = 'Erro de conexão com a API.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Custo de máterial elétrico',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, fontFamily: 'Montserrat', color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 834),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSection('Luminária subaquática', [
                                _inputLabelField(label: 'Quantidade', controller: quantidadeLuzController, isInteger: true),
                                _inputLabelField(label: 'Preço unitário (R\$)', controller: pricelightController),
                              ]),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSection('Cabo elétrico', [
                                _inputLabelField(label: 'Metro do fio', controller: metrofioController, isInteger: true),
                                _inputLabelField(label: 'Preço unitário (R\$)', controller: pricefioController),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSection('Quadro de comando', [
                                _inputLabelField(label: 'Quantidade', controller: qtdcomandoController, isInteger: true),
                                _inputLabelField(label: 'Preço unitário (R\$)', controller: priceComandoController),
                              ]),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSection('Disjuntor', [
                                _inputLabelField(label: 'Quantidade', controller: qtdDisjuntorController, isInteger: true),
                                _inputLabelField(label: 'Preço unitário (R\$)', controller: priceDisjuntorController),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSection('Programador', [
                          _inputLabelField(label: 'Quantidade', controller: qtdDprogramadorController, isInteger: true),
                          _inputLabelField(label: 'Preço unitário (R\$)', controller: priceProgramadorController),
                        ]),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1274F1),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed:
                                    (isLoading || !_todosCamposPreenchidos)
                                        ? null
                                        : calcularCustoEletrico,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2)
                                    : const Text(
                                        "CALCULAR",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
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
              const SizedBox(height: 24),

              // Resultado na parte de informações adicionais
              Center(
                child: SizedBox(
                  width: 577,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          resultado.isEmpty ? '' : resultado,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> inputs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Montserrat', color: Color(0xFF1274F1))),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: inputs[0]),
          const SizedBox(width: 12),
          Expanded(child: inputs[1]),
        ]),
      ]),
    );
  }

  Widget _inputLabelField({
    required String label,
    required TextEditingController controller,
    bool isInteger = false, // novo parâmetro
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w200, fontFamily: 'Montserrat')),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
          inputFormatters: isInteger ? [FilteringTextInputFormatter.digitsOnly] : [],
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200, fontFamily: 'Montserrat', color: Color(0xFF676767)),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          ),
        ),
      ],
    );
  }
}
