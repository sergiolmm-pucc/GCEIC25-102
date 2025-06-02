import 'package:flutter/material.dart';
import 'calculadora6.dart';
import 'sobre.dart';

class MenuEquipe6 extends StatelessWidget {
  const MenuEquipe6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Equipe 6')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Calculadora6Page()));
              },
              child: const Text('Ir para Calculadora'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SobrePage6()));
              },
              child: const Text('Sobre'),
            ),
          ],
        ),
      ),
    );
  }
}
