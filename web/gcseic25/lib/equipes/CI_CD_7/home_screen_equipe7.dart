import 'package:flutter/material.dart';
import 'ipi_screen.dart';
import 'icms_screen.dart';
import 'pis_screen.dart';
import 'cofins_screen.dart';

class HomeScreenEquipe7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cálculo de Impostos')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calcular IPI'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => IpiScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calcular ICMS'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => IcmsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calcular PIS'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PisScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calcular COFINS'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CofinsScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre a Equipe'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Ajuda'),
              onTap: () {},
            ),
          ],
        ),
      ),

      body: Center(
        child: Text(
          'Bem-vindo! Escolha uma opção no menu lateral.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
