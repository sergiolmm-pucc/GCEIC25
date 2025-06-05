import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/tab_bar.dart';

class WaterCostPage extends StatefulWidget {
  const WaterCostPage({super.key});

  @override
  State<WaterCostPage> createState() => _WaterCostPageState();
}

class _WaterCostPageState extends State<WaterCostPage> {
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController tarifaController = TextEditingController();

  String resultado = '';
  bool isLoading = false;
  bool camposPreenchidos = false;

  void verificarCampos() {
    setState(() {
      camposPreenchidos =
          volumeController.text.isNotEmpty && tarifaController.text.isNotEmpty;
    });
  }

  Future<void> calcularGasto() async {
    final volume = volumeController.text;
    final tarifa = tarifaController.text;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://localhost:3000/CCP/agua'); // Substitua pelo seu IP real

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'volume': volume,
          'tarifa': tarifa,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          resultado = 'R\$ ${data["custo_agua"]}';
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
                  'Custo da água',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 577, maxHeight: 279),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 34),
                        Row(
                          children: [
                            Expanded(
                                child: _inputLabelField(
                                    label: 'Volume (m³)', controller: volumeController)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _inputLabelField(
                                    label: 'Tarifa por m³', controller: tarifaController)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 100), // margenzinha à esquerda
                            child: Text(
                              "Tarifa vária por região.\nMédia do Brasil: R\$ 5,00 a R\$ 10,00 por m³.",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w200,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
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
                                    isLoading || !camposPreenchidos ? null : calcularGasto,
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
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
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

  Widget _inputLabelField(
      {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w200,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (_) => verificarCampos(),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(
              color: Color(0xFF676767),
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w200,
            ),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            border: InputBorder.none,
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}
