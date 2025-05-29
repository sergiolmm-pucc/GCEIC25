import 'package:flutter/material.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  final List<Map<String, String>> membros = [
    {
      'nome': 'Arthur',
      'foto': 'lib/equipes/CI_CD_6/assets/arthur.jpeg',
    },
    {
      'nome': 'Guilherme',
      'foto': 'lib/equipes/CI_CD_6/assets/guilherme.jpeg',
    },
    {
      'nome': 'João',
      'foto': 'lib/equipes/CI_CD_6/assets/joão.jpeg',
    },
    {
      'nome': 'Vinicius',
      'foto': 'lib/equipes/CI_CD_6/assets/vinicius.jpeg',
    },
    {
      'nome': 'Felipe',
      'foto': 'lib/equipes/CI_CD_6/assets/felipe.jpeg',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Equipe CI/CD 6',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ...membros.map((membro) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(membro['foto']!),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        membro['nome']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}