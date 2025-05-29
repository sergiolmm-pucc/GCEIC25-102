import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gcseic25/equipes/equipe8/piscina_page.dart';

class SplashScreenPiscina extends StatefulWidget {
  const SplashScreenPiscina({super.key});

  @override
  _SplashScreenPiscinaState createState() => _SplashScreenPiscinaState();
}

class _SplashScreenPiscinaState extends State<SplashScreenPiscina> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PiscinaPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Bem-vindo à Calculadora de Piscina',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
