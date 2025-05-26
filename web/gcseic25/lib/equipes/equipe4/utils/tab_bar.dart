import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

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
                'assets/equipe4/logo_equipe_4.png',
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
          SizedBox(width: 16),
          TextButton(
            onPressed: () {
              // Navegar para Sobre
            },
            child: const Text(
              'Sobre',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 16),
          TextButton(
            onPressed: () {
              // Navegar para Perfil/User
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/equipe4/user_team4.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text('User'),
              ],
            ),
          ),
          SizedBox(width: 30),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          
          image: DecorationImage(
            image: AssetImage('assets/equipe4/apis_background.png'),
            fit: BoxFit.cover,
          ),

        ),
        child: child,
      ),
    );
  }
}
