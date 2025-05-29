import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe 5/splash_screen.dart';
import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController(
    text: 'tester',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'teste123',
  );

  void login() async {
    final String username = usernameController.text;
    final String password = passwordController.text;


    final url = Uri.parse('https://sincere-magnificent-cobweb.glitch.me/calculadoraViagemRoutes/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode==401){
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Invalid username or password.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(nextScreen: 'home'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza verticalmente
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centraliza horizontalmente
              children: [
                const Text(
                  'Use o username "tester" e a senha "teste123" para acessar.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome de Usuário',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: login,
                  child: const Text(
                    'ENTRAR',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
