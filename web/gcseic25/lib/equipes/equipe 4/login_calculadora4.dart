import 'package:flutter/material.dart';
import 'calculadora4.dart';

class LoginCalculadora4Page extends StatelessWidget {
  const LoginCalculadora4Page({super.key});

  void _loginSucesso(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Calculadora4Page()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usuarioController = TextEditingController(text: 'admin');
    final TextEditingController senhaController = TextEditingController(text: '**');

    return Scaffold(
      appBar: AppBar(title: const Text("Login Equipe 4")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usuarioController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Usuário",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              readOnly: true,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _loginSucesso(context),
              child: const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}