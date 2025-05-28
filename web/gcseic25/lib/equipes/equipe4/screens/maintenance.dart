import 'package:flutter/material.dart';
import '../utils/tab_bar.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

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
                  constraints: const BoxConstraints( 
                    maxWidth: 577,
                    maxHeight: 387,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 34),
                        // Primeira linha de inputs
                        Row(
                          children: [
                            const SizedBox(height: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Volume',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w200
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Volume',
                                       hintStyle: TextStyle(
                                        color: Color(0xFF676767),
                                        fontSize: 12,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w200
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
                                        horizontal: 12,
                                        vertical: 8,
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
                                      fontWeight: FontWeight.w200,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,

                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Produtos químicos',
                                       hintStyle: TextStyle(
                                        color: Color(0xFF676767),
                                        fontSize: 12,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w200
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
                                        horizontal: 12,
                                        vertical: 8,
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
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Obs. cloro, algicida, pH+ ou pH-, clarificante.",
                            style: TextStyle(fontSize: 12,  fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w200, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

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
                                      fontWeight: FontWeight.w200,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Energia da bomba',
                                      hintStyle: TextStyle(
                                          color: Color(0xFF676767),
                                          fontSize: 12,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w200
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
                                        horizontal: 19,
                                        vertical: 8,
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
                                      fontWeight: FontWeight.w200,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Mão de obra',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF676767),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200,
                                        fontFamily: 'Montserrat',
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
                                        horizontal: 12,
                                        vertical: 8,
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
                            style: TextStyle(fontSize: 12,  fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w200, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botão calcular
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1274F1),
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
              const SizedBox(height: 24), // Espaço entre os boxes
              
              // Novo box adicionado aqui
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 577,
                    // Você pode definir uma altura fixa ou deixar ajustar automaticamente
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Informações adicionais',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Aqui você pode colocar qualquer informação extra, resumo ou dados adicionais relacionados à manutenção.',
                          style: TextStyle(
                            fontSize: 14,
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
}
