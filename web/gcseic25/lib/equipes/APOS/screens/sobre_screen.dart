import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o App')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/APOS/logo.png', height: 100),
            const SizedBox(height: 20),

            Text(
              'Aposentadoria Fácil',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Text(
              'Um aplicativo criado para facilitar o planejamento da sua aposentadoria. Com ele, você calcula com base nas regras atuais, simula diferentes cenários e acompanha seu progresso de forma simples e segura.',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Text(
              'Equipe de Desenvolvimento',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Lista horizontal de membros da equipe
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                equipe.map((p) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DesenvolvedorItem(
                      nome: p['nome']!,
                      foto: p['foto']!,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const equipe = [
  {'nome': 'Emilly Bó', 'foto': 'assets/APOS/emilly.jpeg'},
  {'nome': 'Gabriel Cardoso', 'foto': 'assets/APOS/gabriel.png'},
  {'nome': 'Guilherme Maia', 'foto': 'assets/APOS/guilherme.jpeg'},
  {'nome': 'Isabella Maria', 'foto': 'assets/APOS/isabella.png'},
  {'nome': 'Izabelle Oliveira', 'foto': 'assets/APOS/izabelle.jpg'},
];

class DesenvolvedorItem extends StatelessWidget {
  final String nome;
  final String foto;

  const DesenvolvedorItem({super.key, required this.nome, required this.foto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(backgroundImage: AssetImage(foto), radius: 42),
        ),
        const SizedBox(height: 8),
        Text(
          nome,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}