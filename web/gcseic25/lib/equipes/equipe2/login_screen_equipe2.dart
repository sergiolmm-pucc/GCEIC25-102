// PROJETO SERGIO NODE/web/gcseic25/lib/equipes/equipe2/login_screen_equipe2.dart
import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe2/travel_calculator_screen_equipe2.dart';

class LoginScreenEquipe2 extends StatefulWidget { //
  const LoginScreenEquipe2({Key? key}) : super(key: key);

  @override
  State<LoginScreenEquipe2> createState() => _LoginScreenEquipe2State();
}

class _LoginScreenEquipe2State extends State<LoginScreenEquipe2> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final String _fixedUsername = 'admin'; // Usuário fixo
    final String _fixedPassword = '123'; // Senha fixa

void _login() {
    if (_usernameController.text == _fixedUsername &&
        _passwordController.text == _fixedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
    );

    // Navega para a tela da calculadora de viagens após o login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TravelCalculatorScreenEquipe2()),
    );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Usuário ou senha inválidos!')),
   );
  }
 }
}