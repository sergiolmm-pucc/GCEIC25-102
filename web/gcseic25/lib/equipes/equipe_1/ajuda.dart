import 'package:flutter/material.dart';

class AjudaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajuda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Bem-vindo ao app!\n\n'
          'Este aplicativo permite consultar dados da nossa API.\n'
          'Você pode usar o botão principal para buscar informações,\n'
          'ver mais sobre a equipe ou acessar esta tela de ajuda.\n\n'
          'Usuário de login: admin\nSenha: 1234',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
