import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe4/screens/mob.dart';
import 'package:gcseic25/equipes/equipe4/screens/water_volume.dart';
import 'package:gcseic25/equipes/equipe4/screens/hydraulic_material.dart';
import 'package:gcseic25/equipes/equipe4/screens/maintenance.dart';
import 'package:gcseic25/equipes/equipe4/screens/water_cost.dart';
import 'package:gcseic25/equipes/equipe4/screens/about.dart';
import 'package:gcseic25/equipes/equipe4/screens/eletric_material.dart';
import '../utils/tab_bar.dart';

class HomeScreen4 extends StatelessWidget {
  const HomeScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo ao app!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WaterVolumePage(),
                    ),
                  );
                },
                child: const Text('Cálculo do Volume'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HydraulicCostPage(),
                      ),
                    );
                  },
                  child: const Text('Material Hidraúlico'),
                ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaintenancePage(),
                    ),
                  );
                },
                child: const Text('Manutenção'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WaterCostPage(),
                    ),
                  );
                },
                child: const Text('Custo da água'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => About(),
                  ),
                );
              },
              child: const Text('Sobre'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MOBPage(),
                    ),
                  );
                },
                child: const Text('MOB'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EletricMaterialPage(),
                    ),
                  );
                },
                child: const Text('Custo do matérial elétrico'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
