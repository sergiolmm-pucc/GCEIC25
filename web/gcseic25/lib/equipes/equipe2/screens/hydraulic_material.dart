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
  final TextEditingController tipoTubulacaoController = TextEditingController();
  final TextEditingController conexoesController = TextEditingController();

  double total = 0.0;

  void calcularCusto() {
    double bomba = double.tryParse(bombaController.text) ?? 0;
    double filtro = double.tryParse(filtroController.text) ?? 0;
    double tubos = double.tryParse(tubosController.text) ?? 0;
    double precoMetro = double.tryParse(precoMetroController.text) ?? 0;
    double conexoes = double.tryParse(conexoesController.text) ?? 0;

    setState(() {
      total = bomba + filtro + (tubos * precoMetro) + conexoes;
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
                              Expanded(child: buildStyledTextField(bombaController, 'Bomba')),
                              const SizedBox(width: 10),
                              Expanded(child: buildStyledTextField(filtroController, 'Filtro')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: buildStyledTextField(tubosController, 'Tubulações (m)')),
                              const SizedBox(width: 10),
                              Expanded(child: buildStyledTextField(tipoTubulacaoController, 'Tipo da tubulação')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: buildStyledTextField(precoMetroController, 'Preço por metro')),
                              const SizedBox(width: 10),
                              Expanded(child: buildStyledTextField(conexoesController, 'Conexões')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: calcularCusto,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'CALCULAR',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    width: 300,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
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
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Color(0xFF3C3C3C)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFEBEBEB),
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFFADADAD)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
