import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E7CA0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'SplashMath',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              // Navegar para Help
            },
            child: const Text(
              'Ajuda',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              // Navegar para Sobre
            },
            child: const Text(
              'Sobre',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              // Navegar para Perfil/User
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/equipe4/user_team4.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 6),
                const Text('User'),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/equipe4/apis_background.png',
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
                      width: 360,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
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
                      color: Colors.white.withOpacity(0.3),
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
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.white70),
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
