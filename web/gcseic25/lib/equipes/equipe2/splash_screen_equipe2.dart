// PROJETO SERGIO NODE/web/gcseic25/lib/equipes/equipe2/splash_screen_equipe2.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gcseic25/equipes/equipe2/login_screen_equipe2.dart';

// ***** CONFIRME ESTE NOME DE CLASSE *****
class SplashScreenEquipe2 extends StatefulWidget {
  const SplashScreenEquipe2({Key? key}) : super(key: key);

  @override
  State<SplashScreenEquipe2> createState() => _SplashScreenEquipe2State();
}

class _SplashScreenEquipe2State extends State<SplashScreenEquipe2> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreenEquipe2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text('Sistema de Viagens Equipe 2', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}