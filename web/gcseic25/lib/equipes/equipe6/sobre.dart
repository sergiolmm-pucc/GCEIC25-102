import 'package:flutter/material.dart';

class SobrePage6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Mayron Germann Sousa de Pádua\nRA: 21003182'
            '\nGabriel Scanduzzi\nRA: 21003182',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}