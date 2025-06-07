import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  final List<Map<String, String>> integrantes = [
    {
      'nome': 'Arthur Maluf',
      'descricao': '22005252',
      'foto': 'assets/integrante1.png',
    },
    {
      'nome': 'Lucas Bertola',
      'descricao': 'RA',
      'foto': 'assets/integrante2.png',
    },
    {
      'nome': 'Marcos Miotto',
      'descricao': '23004827',
      'foto': 'assets/integrante3.png',
    },
    {
      'nome': 'Pedro Vieira',
      'descricao': 'RA',
      'foto': 'assets/integrante4.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFF2196F3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: integrantes.length,
            itemBuilder: (context, index) {
              final integrante = integrantes[index];
              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                margin: const EdgeInsets.symmetric(vertical: 18),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(integrante['foto']!),
                        onBackgroundImageError: (_, __) {},
                      ),
                      SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              integrante['nome']!,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2)),
                            ),
                            SizedBox(height: 12),
                            Text(
                              integrante['descricao']!,
                              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
} 