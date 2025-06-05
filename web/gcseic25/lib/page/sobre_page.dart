import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  final List<Map<String, String>> equipe = [
    {'nome': 'Jéssica Kushida', 'foto': 'lib/assets/Jessica.jpg'},
    {'nome': 'Gustavo Kenji', 'foto': 'lib/assets/Kenji.jpg'},
    {'nome': 'Marcela Franco', 'foto': 'lib/assets/Marcela.jpg'},
    {'nome': 'Natalia Naomi Sumida', 'foto': 'lib/assets/Natalia.jpg'},
    {'nome': 'Nicole Silvestrini', 'foto': 'lib/assets/Nicole.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: equipe.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final membro = equipe[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(membro['foto']!),
                      radius: 25,
                    ),
                    title: Text(
                      membro['nome']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}