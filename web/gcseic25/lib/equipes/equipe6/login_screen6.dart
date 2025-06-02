import 'package:flutter/material.dart';
import 'calculadora6.dart'; // ou a próxima tela que quiser abrir após o login
import 'menu.dart';
class LoginPage6 extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage6> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String? _error;

  void _fazerLogin() {
    final usuario = _userController.text;
    final senha = _passController.text;

    if (usuario == 'admin' && senha == '12345') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuEquipe6()),
      );
    } else {
      setState(() {
        _error = 'Usuário ou senha incorretos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(labelText: 'Usuário'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fazerLogin,
              child: Text('Entrar'),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(_error!, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
