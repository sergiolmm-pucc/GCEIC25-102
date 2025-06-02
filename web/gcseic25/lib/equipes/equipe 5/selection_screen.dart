import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe 5/time_screen.dart';
import 'package:gcseic25/equipes/equipe 5/cost_calculator.dart';
import 'package:gcseic25/equipes/equipe 5/selection_screen.dart';

class HomeScreenEquipe5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Equipe 5', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text(
                'Calculadora de Custos',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeScreen()),
                );
              },
              child: Text(
                'Cálculo de Tempo de Viagem',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
