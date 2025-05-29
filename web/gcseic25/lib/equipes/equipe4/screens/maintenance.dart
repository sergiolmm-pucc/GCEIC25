import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/tab_bar.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {

  final TextEditingController produtosController = TextEditingController();
  final TextEditingController energiaController = TextEditingController();
  final TextEditingController maoDeObraController = TextEditingController();

  String resultado = '';
  bool isLoading = false;

  bool get _todosCamposPreenchidos {
    return 
        produtosController.text.isNotEmpty &&
        energiaController.text.isNotEmpty &&
        maoDeObraController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

   
    produtosController.addListener(_onInputChanged);
    energiaController.addListener(_onInputChanged);
    maoDeObraController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {
      // Atualiza o estado para habilitar/desabilitar o botão
    });
  }

  @override
  void dispose() {
   
    produtosController.removeListener(_onInputChanged);
    energiaController.removeListener(_onInputChanged);
    maoDeObraController.removeListener(_onInputChanged);

   
    produtosController.dispose();
    energiaController.dispose();
    maoDeObraController.dispose();

    super.dispose();
  }

  Future<void> calcularCusto() async {
  
    final produtos = produtosController.text;
    final energia = energiaController.text;
    final maoDeObra = maoDeObraController.text;

    setState(() {
      isLoading = true;
      resultado = ''; // limpa resultado anterior
    });

    final url = Uri.parse('http://localhost:3000/CCP/manutencao'); // Substitua pelo seu IP real

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'produtos_quimicos': produtos,
          'energia_bomba': energia,
          'mao_obra': maoDeObra,
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
                  'Gasto mensal de manutenção',
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
                  constraints:
                      const BoxConstraints(maxWidth: 577, maxHeight: 387),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
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
                                    label: 'Produtos químicos (R\$)',
                                    controller: produtosController)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Obs. cloro, algicida, pH+ ou pH-, clarificante.",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w200,
                                color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                                child: _inputLabelField(
                                    label: 'Energia da bomba (R\$)',
                                    controller: energiaController)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _inputLabelField(
                                    label: 'Mão de obra (R\$)',
                                    controller: maoDeObraController)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Obs: horas por dia",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w200,
                                color: Colors.grey),
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
                                    (isLoading || !_todosCamposPreenchidos)
                                        ? null
                                        : calcularCusto,
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
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}
