import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe2/screens/about.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool isHome; 

  const MainLayout({
    super.key,
    required this.child,
    this.isHome = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF347CA5),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/equipe2/logo_equipe_2.png',
                height: 23,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navegar para Help
            },
            child: const Text(
              'Ajuda',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => About(),
                  ),
                );
            },
            child: const Text(
              'Sobre',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
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
                  'assets/equipe2/user_team2.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text('User'),
              ],
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isHome
                  ? 'assets/equipe2/background_home_equipe2.png' 
                  : 'assets/equipe2/apis_background.png', 
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
