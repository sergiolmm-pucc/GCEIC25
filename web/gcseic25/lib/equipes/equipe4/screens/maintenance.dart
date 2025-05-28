import 'package:flutter/material.dart';
import '../utils/tab_bar.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Gasto mensal de manutenção',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints( 
                    maxWidth: 537,
                    maxHeight: 357, // Definindo a altura máxima
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(16),
                
                    ),
                    child: Column(
                      children: [
                        // Primeira linha de inputs
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Volume',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Volume',
                                       hintStyle: TextStyle(
                                        color: Color(0xFFADADAD),
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xFFEBEBEB)), // borda transparente
                                      ),
                                    
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.blue), // borda azul ao focar
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Produtos químicos',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                       fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Produtos químicos',
                                       hintStyle: TextStyle(
                                        color: Color(0xFFADADAD),
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xFFEBEBEB)), // borda transparente
                                      ),
                                    
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.blue), // borda azul ao focar
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Align(
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(height: 16),

                        // Segunda linha de inputs
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Energia da bomba',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Energia da bomba',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFADADAD),
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xFFEBEBEB)), // borda transparente
                                      ),
                                   
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.blue), // borda azul ao focar
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mão de obra',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Mão de obra',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFADADAD),
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Color(0xFFEBEBEB)), // borda transparente
                                    ),
                                   
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.blue), // borda azul ao focar
                                    ),

                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 4),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Obs: horas por dia",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botão calcular
                        SizedBox(
                          width: 200, // Largura menor — ajuste conforme necessário
                          height: 40, // Altura menor
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1274F1), // Azul desejado
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // lógica do cálculo aqui
                            },
                            child: const Text(
                              "CALCULAR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
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
}
