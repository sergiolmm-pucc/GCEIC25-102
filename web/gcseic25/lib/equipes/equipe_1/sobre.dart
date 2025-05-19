import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre a Equipe')),
      body: Column(
        children: [
          Image.asset('assets/equipe1.png'), // coloque a imagem em assets/
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Integrantes da Equipe:\n- Kauan Barbosa Silva - 22020168\n- Paulo Vitor Reis Ribeiro - [RA]\n- Vinicius Kenji Okita Eugênio - 22022285\n- Gianpaolo Del Vale Aranha - [RA]',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
