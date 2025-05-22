import 'package:flutter/material.dart';

class AjudaScreen extends StatelessWidget {
  const AjudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Icon(
            Icons.help_center_outlined,
            size: 60,
            color: Colors.teal.shade600,
          ),
          const SizedBox(height: 20),

          Text(
            'Como podemos ajudar?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          _buildAjudaItem(
            icon: Icons.touch_app,
            title: 'Como usar o aplicativo',
            description:
                'Utilize o menu principal para acessar as funcionalidades como cálculo da aposentadoria, simulações e visualização das regras atuais.',
          ),
          const SizedBox(height: 16),

          _buildAjudaItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Segurança dos dados',
            description:
                'Os dados são armazenados localmente no seu dispositivo. Nenhuma informação pessoal é coletada ou compartilhada.',
          ),
          const SizedBox(height: 16),

          _buildAjudaItem(
            icon: Icons.update,
            title: 'Regras atualizadas',
            description:
                'As simulações utilizam as regras atuais da aposentadoria. Verifique atualizações do app regularmente.',
          ),
        ],
      ),
    );
  }

  Widget _buildAjudaItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(description),
        ),
      ),
    );
  }
}
