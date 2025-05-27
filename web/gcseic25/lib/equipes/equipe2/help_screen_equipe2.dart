// PROJETO SERGIO NODE/web/gcseic25/lib/equipes/equipe2/help_screen_equipe2.dart
import 'package:flutter/material.dart';

class HelpScreenEquipe2 extends StatelessWidget {
  const HelpScreenEquipe2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda Equipe 2')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guia Rápido de Uso da Calculadora de Viagens:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 15),
            Text(
              'Este aplicativo permite que você estime o custo total da sua viagem ideal, personalizando diversos aspectos:',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

