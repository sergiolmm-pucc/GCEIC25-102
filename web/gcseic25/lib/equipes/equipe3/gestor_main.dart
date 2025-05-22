import 'package:flutter/material.dart';
import 'splash_screen_equipe_tres.dart';

class GestorFinancasApp extends StatelessWidget {
  const GestorFinancasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Finanças',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SplashScreenEquipeTres(),
    );
  }
}
