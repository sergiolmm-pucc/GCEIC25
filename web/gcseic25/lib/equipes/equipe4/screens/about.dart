import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: About()));
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
      fontSize: 15.6,
      fontWeight: FontWeight.w500,
      height: 0.9, // espaçamento entre linhas reduzido
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 76, // aumentado em 70% (original 60)
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Quem\nnós '),
                    TextSpan(
                      text: 'somos?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: -0,
                runSpacing: -30, // espaçamento vertical bem menor
                alignment: WrapAlignment.start,
                children: [
                  // Aplicando padding à esquerda para deslocar a primeira linha
                  Padding(
                    padding: const EdgeInsets.only(left: 64),
                    child: PersonCard(
                      imagePath: 'assets/equipe4/alex.png',
                      name: 'Alex Chaves Insel',
                      ra: '21008278',
                      bgPath: 'assets/equipe4/bg1.png',
                      nameStyle: nameStyle,
                    ),
                  ),
                 PersonCard(
                      imagePath: 'assets/equipe4/ana.png',
                      name: 'Ana Carolina Morelli Chaves',
                      ra: '23017617',
                      bgPath: '',
                      nameStyle: nameStyle,
                    ),
              
              
                   PersonCard(
                      imagePath: 'assets/equipe4/lais.png',
                      name: 'Lais de Paula Lemos',
                      ra: '23016041',
                      bgPath: 'assets/equipe4/bg2.png',
                      nameStyle: nameStyle,
                    ),

                  const SizedBox(width: double.infinity,height: 1), // força quebra de linha

                  PersonCard(
                    imagePath: 'assets/equipe4/luiz.png',
                    name: 'Luiz Gustavo Pinto da Silva',
                    ra: '23013028',
                    bgPath: 'assets/equipe4/bg1.png',
                    nameStyle: nameStyle,
                  ),
                  PersonCard(
                    imagePath: 'assets/equipe4/manu.png',
                    name: 'Manoela Fernanda Pereira',
                    ra: '23007000',
                    bgPath: '',
                    nameStyle: nameStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String ra;
  final String bgPath;
  final TextStyle? nameStyle;

  const PersonCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.ra,
    required this.bgPath,
    this.nameStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double photoWidth = 224;
    final double photoHeight = 215.2; // 20% menor que o original
    final double bgHeight = 224;

    return SizedBox(
      width: photoWidth + 20,
      height: photoHeight + bgHeight * 0.5 + 60,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          if (bgPath.isNotEmpty)
            Positioned(
              top: 0,
              left: photoWidth * 0.4,
              child: Image.asset(
                bgPath,
                height: bgHeight,
                fit: BoxFit.contain,
                width: photoWidth + 20,
              ),
            ),
          Positioned(
            top: bgHeight * 0.3,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    width: photoWidth,
                    height: photoHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: photoWidth,
                  child: Text(
                    '$name\n$ra',
                    textAlign: TextAlign.center,
                    style: nameStyle ??
                        const TextStyle(
                          fontSize: 15.6,
                          height: 0.9,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
