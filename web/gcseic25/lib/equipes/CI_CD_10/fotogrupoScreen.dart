import 'package:flutter/material.dart';

class FotoGrupoScreen extends StatelessWidget {
  const FotoGrupoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotos do Grupo'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Membros do Grupo',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: const [
                    MemberPhoto(
                      imagePath: 'assets/membro1.jpg',
                      name: 'Membro 1',
                    ),
                    MemberPhoto(
                      imagePath: 'assets/membro2.jpg',
                      name: 'Membro 2',
                    ),
                    MemberPhoto(
                      imagePath: 'assets/membro3.jpg',
                      name: 'Membro 3',
                    ),
                    MemberPhoto(
                      imagePath: 'assets/membro4.jpg',
                      name: 'Membro 4',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberPhoto extends StatelessWidget {
  final String imagePath;
  final String name;

  const MemberPhoto({
    super.key,
    required this.imagePath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}