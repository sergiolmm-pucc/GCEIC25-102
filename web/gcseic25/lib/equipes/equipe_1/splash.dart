import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe_1/login.dart';
import 'uso_app.dart';

class SplashEquipe extends StatefulWidget {
  @override
  _SplashEquipeState createState() => _SplashEquipeState();
}

class _SplashEquipeState extends State<SplashEquipe> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Bem-vindo!', style: TextStyle(fontSize: 24))),
    );
  }
}
