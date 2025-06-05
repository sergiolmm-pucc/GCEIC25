import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../utils/tab_bar.dart';

class HydraulicCostPage extends StatefulWidget {
  const HydraulicCostPage({super.key});

  @override
  State<HydraulicCostPage> createState() => _HydraulicCostPageState();
}

class _HydraulicCostPageState extends State<HydraulicCostPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController bombaController = TextEditingController();
  final TextEditingController filtroController = TextEditingController();
  final TextEditingController tubosController = TextEditingController();
  final TextEditingController precoMetroController = TextEditingController();
  final TextEditingController conexoesController = TextEditingController();

  String? tipoTubulacaoSelecionado;

  final Map<String, double> precosMedios = {
    'PVC': 10.0,
    'CPVC': 12.5,
    'Cobre': 25.0,
    'PEX': 20.0,
  };

  double total = 0.0;
  bool isLoading = false;

  // Chama a API para calcular o custo
  Future<void> calcularCustoApi() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final bomba = double.tryParse(bombaController.text) ?? 0;
      final filtro = double.tryParse(filtroController.text) ?? 0;
      final tubos = double.tryParse(tubosController.text) ?? 0;
      final precoMetro = double.tryParse(precoMetroController.text) ?? 0;
      final conexoes = double.tryParse(conexoesController.text) ?? 0;

      // Substitua essa URL pela URL real da sua API
      final uri = Uri.parse('http://localhost:3000/CCP/hidraulico');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'custoBomba': bomba,
          'custoFiltro': filtro,
          'comprimentoTubos': tubos,
          'custoPorMetro': precoMetro,
          'custoValvula': conexoes,
          'tipoTubulacao': tipoTubulacaoSelecionado,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Supondo que a API retorne { "total": 123.45 }
        setState(() {
          total = (data['total'] as num).toDouble();
        });
      } else {
        // Tratar erro da API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao calcular custo: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      // Tratar erro de conexão ou outro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro na requisição: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onTipoTubulacaoChanged(String? value) {
    setState(() {
      tipoTubulacaoSelecionado = value;
      if (value != null && precosMedios.containsKey(value)) {
        precoMetroController.text = precosMedios[value]!.toStringAsFixed(2);
      } else {
        precoMetroController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/equipe2/apis_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Column(
                children: [
                  const Text(
                    'Custo da parte hidráulica',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: 460,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: buildStyledTextField(bombaController, 'Bomba (R\$)')),
                              const SizedBox(width: 10),
                              Expanded(child: buildStyledTextField(filtroController, 'Filtro (R\$)')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: buildStyledTextField(tubosController, 'Tubulações (m)')),
                              const SizedBox(width: 10),
                              Expanded(child: buildDropdownTipoTubulacao()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: buildStyledTextField(precoMetroController, 'Preço por metro (R\$)')),
                              const SizedBox(width: 10),
                              Expanded(child: buildStyledTextField(conexoesController, 'Conexões (un)')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : calcularCustoApi,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Semantics(
                              label: 'Botão calcular',
                              hint: 'Pressione para calcular o custo hidráulico',
                              button: true,
                              enabled: !isLoading,
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'CALCULAR',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3C3C3C),
                          ),
                        ),
                        Text(
                          'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1274F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStyledTextField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF3C3C3C), fontSize: 14),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Color(0xFF3C3C3C)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEBEBEB),
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFFADADAD)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            if (double.tryParse(value.replaceAll(',', '.')) == null) {
              return 'Digite um número válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildDropdownTipoTubulacao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo da tubulação',
          style: TextStyle(color: Color(0xFF3C3C3C), fontSize: 14),
        ),
        const SizedBox(height: 4),
        Semantics(
          label: 'Tipo da tubulação',
          hint: 'Escolha o material da tubulação entre PVC, CPVC, Cobre ou PEX',
          child: DropdownButtonFormField<String>(
            key: const Key('dropdown-tipo-tubulacao'),
            value: tipoTubulacaoSelecionado,
            items: const [
              DropdownMenuItem(value: 'PVC', child: Text('PVC')),
              DropdownMenuItem(value: 'CPVC', child: Text('CPVC')),
              DropdownMenuItem(value: 'Cobre', child: Text('Cobre')),
              DropdownMenuItem(value: 'PEX', child: Text('PEX')),
            ],
            onChanged: onTipoTubulacaoChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEBEBEB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecione um tipo';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
