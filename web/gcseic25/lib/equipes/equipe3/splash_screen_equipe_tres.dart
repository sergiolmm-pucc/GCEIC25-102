import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreenEquipeTres extends StatefulWidget {
  const SplashScreenEquipeTres({super.key});

  @override
  SplashScreenEquipeTresState createState() => SplashScreenEquipeTresState();
}

class SplashScreenEquipeTresState extends State<SplashScreenEquipeTres> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Usamos um Container que ocupa toda a tela (width: double.infinity, height: double.infinity)
      // e definimos alignment: Alignment.center para centralizar o filho.
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: const Text(
          'Carregando o Gestor de Finanças...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
