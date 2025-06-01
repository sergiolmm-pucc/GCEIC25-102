import 'package:flutter/material.dart';
import 'package:gcseic25/equipes/equipe_1/uso_app.dart';
import 'splash.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Semantics(
              label: 'Usuário',
              textField: true,
              child: TextField(
                controller: _userController,
                decoration: InputDecoration(labelText: 'Usuário'),
              ),
            ),
            Semantics(
              label: 'Senha',
              textField: true,
              child: TextField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            Semantics(
              label: 'Entrar',
              button: true,
              child: ElevatedButton(
                onPressed: () {
                  if (_userController.text == 'admin' &&
                      _passController.text == '1234') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UsoAppPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Usuário ou senha incorretos')),
                    );
                  }
                },
                child: Text('Entrar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
