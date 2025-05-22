import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreenEquipeTres extends StatefulWidget {
  const SplashScreenEquipeTres({super.key});

  @override
  _SplashScreenEquipeTresState createState() => _SplashScreenEquipeTresState();
}

class _SplashScreenEquipeTresState extends State<SplashScreenEquipeTres> {
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
      body: const Center(
        child: Text(
          'Gestor de Finanças',
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
