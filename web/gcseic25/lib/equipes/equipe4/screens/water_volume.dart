import 'package:flutter/material.dart';
import '../utils/tab_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WaterVolumePage extends StatefulWidget {
  const WaterVolumePage({super.key});

  @override
  State<WaterVolumePage> createState() => _WaterVolumePageState();
}

class _WaterVolumePageState extends State<WaterVolumePage> {
  String? selectedShape;
  double? volumeCalculado;

  final Map<String, TextEditingController> controllers = {};

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool isFormValid(List<String> labels) {
    if (selectedShape == null) return false;
    for (var label in labels) {
      if (controllers[label]?.text.isEmpty ?? true) {
        return false;
      }
    }
    return true;
  }

  bool loading = false;
  String? erro;

  Future<double?> calcularVolume(Map<String, String> inputs) async {
    setState(() {
      loading = true;
      erro = null;
    });

    final url = Uri.parse('http://localhost:3000/CCP/calcular-volume');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(inputs),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['sucesso'] == true) {
        return data['volume']?.toDouble();
      } else {
        setState(() {
          erro = data['mensagem'] ?? 'Erro desconhecido';
        });
        return null;
      }
    } catch (e) {
      setState(() {
        erro = e.toString();
      });
      return null;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Cálculo do Volume',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tipo de piscina',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 60,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText:
                                  selectedShape == null ? 'Tipo de Piscina' : null,
                              labelStyle: const TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            value: selectedShape,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3C3C3C),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Retangular',
                                child: Text('Retangular'),
                              ),
                              DropdownMenuItem(
                                value: 'Circular',
                                child: Text('Circular'),
                              ),
                              DropdownMenuItem(
                                value: 'Oval',
                                child: Text('Oval'),
                              ),
                              DropdownMenuItem(
                                value: 'Irregular',
                                child: Text('Irregular'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedShape = value;
                                controllers.clear();
                                volumeCalculado = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (selectedShape != null) buildShapeInputs(selectedShape!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShapeInputs(String shape) {
    List<String> labels;
    String description;
    String imagePath;

    switch (shape) {
      case 'Retangular':
        labels = ['Comprimento (m)', 'Largura (m)', 'Profundidade (m)'];
        description = 'Volume da piscina retangular';
        imagePath = 'assets/equipe4/retangular.png';
        break;
      case 'Circular':
        labels = ['Diâmetro (m)', 'Profundidade (m)'];
        description = 'Volume da piscina circular';
        imagePath = 'assets/equipe4/circular.png';
        break;
      case 'Oval':
        labels = ['Comprimento (m)', 'Largura (m)', 'Profundidade (m)'];
        description = 'Volume da piscina oval';
        imagePath = 'assets/equipe4/oval.png';
        break;
      case 'Irregular':
        labels = ['Comprimento (m)', 'Largura (m)', 'Profundidade (m)'];
        description = 'Volume da piscina irregular';
        imagePath = 'assets/equipe4/irregular.png';
        break;
      default:
        return const SizedBox();
    }

    return Center(
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            buildInputCard(labels, description, imagePath),
            const SizedBox(height: 24),
            buildResultCard(labels),
          ],
        ),
      ),
    );
  }

  Widget buildInputCard(List<String> labels, String description, String imagePath) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Card(
          color: const Color(0xFFF2F2F2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Color(0xFF3C3C3C),
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(imagePath, height: 38, fit: BoxFit.contain),
                const SizedBox(height: 28),

                if (labels.length >= 2)
                  Row(
                    children: [
                      Expanded(child: buildInputField(labels[0])),
                      const SizedBox(width: 16),
                      Expanded(child: buildInputField(labels[1])),
                    ],
                  ),
                const SizedBox(height: 16),

                if (labels.length > 2)
                  for (var label in labels.sublist(2)) ...[
                    buildInputField(label),
                    const SizedBox(height: 16),
                  ],

                const SizedBox(height: 8),

                SizedBox(
                  width: 110,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: isFormValid(labels)
                      ? () async {
                          final inputs = <String, String>{};
                            for (var label in labels) {
                              inputs[label] = controllers[label]?.text ?? '';
                            }
                            inputs['tipo_piscina'] = selectedShape ?? '';

                          final resultado = await calcularVolume(inputs);
                          setState(() {
                            volumeCalculado = resultado;
                          });
                        }
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1274F1),
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'CALCULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget buildInputField(String label) {
    controllers[label] = controllers[label] ?? TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF3C3C3C)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controllers[label],
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFFADADAD), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFEBEBEB),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget buildResultCard(List<String> labels) {
    return Center(  
      child: SizedBox(
        width: 350,    
        height: 330,   
        child: Card(
          color: const Color(0xFFF2F2F2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                const Text(
                  'Volume da piscina',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF3C3C3C),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                if (labels.length >= 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Expanded(child: buildResultItem(labels[0])),
                      const SizedBox(width: 16),
                      Expanded(child: buildResultItem(labels[1])),
                    ],
                  ),

                if (labels.length > 2) ...[
                  const SizedBox(height: 16),
                  buildResultItem(labels[2]),
                ],

                const SizedBox(height: 24),

                const Text(
                  'Volume',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1274F1),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  volumeCalculado != null ? '${volumeCalculado!.toStringAsFixed(2)} m³' : '-',
                  style: const TextStyle(
                    fontSize: 28,
                    color: Color(0xFF1274F1),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget buildResultItem(String label) {
  final value = controllers[label]?.text ?? '-';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        label.replaceAll(' (m)', ''),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF676767),
        ),
         textAlign: TextAlign.center,
      ),
      const SizedBox(height: 4),
      Text(
        value.isEmpty ? '-' : '$value m',
        style: const TextStyle(
          fontSize: 22,
          color: Color(0xFF3C3C3C),
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

}
